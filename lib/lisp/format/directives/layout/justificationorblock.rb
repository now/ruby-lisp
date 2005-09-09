# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/io/bufferingoutput'
require 'lisp/format/io/filteringoutput'

class Lisp::Format::Directives::Layout::JustificationOrBlock < Lisp::Format::Directives::Directive
  directive [0, 1, 0, ' '], BothMods, ?<

  def initialize(params, modifiers, pos, scanner)
    super
    @clauses = []
    clause = []
    scanner.with(self) do |directive|
      case directive
      when Lisp::Format::Directives[?>]
        @clauses << clause
        @is_block = directive.colon?
        if @special_separator
          if @is_block and @special_separator.colon?
            raise Lisp::Format::Error.new(@special_separator.pos, '‘@’ ~
                                          modifier not allowed for ~~; within ~
                                          a justification (~~<…~~>)')
          end
          if not @is_block and @special_separator.at?
            raise Lisp::Format::Error.new(@special_separator.pos, '‘:’ ~
                                          modifier not allowed for ~~; within ~
                                          a logical block (~~<…~~:>)')
          end
        end
        break
      when Lisp::Format::Directives[?;]
        @clauses << clause
        clause = []
        if directive.colon? or directive.at?
          unless @clauses.size.eql? 1
            raise error('only the first clause may be terminated with ~~~C;',
                        directive.colon? ? ?: : ?@)
          end
          @special_separator = directive
        end
      else
        clause << directive
      end
    end
  end

  def execute(state, mincol, colinc, minpad, padchar)
    if @is_block
      process_as_blocks(state)
    else
      process_as_justification(state, mincol, colinc, minpad, padchar)
    end
  end

private

  def process_as_justification(state, mincol, colinc, minpad, padchar)
    buffers = []
    catch :up_and_out do
      @clauses.each do |clause|
        buffers << state.with_output_to(Lisp::Format::IO::BufferingOutput.new){
          state.execute(clause)
        }.contents
      end
    end
    return if buffers.empty?
    first = buffers.shift if @special_separator
    gaps = buffers.length - 1 + (colon? ? 1 : 0) + (at? ? 1 : 0)
    w = gaps * minpad + buffers.inject(0){ |sum, s| sum + s.length }
    len = w > mincol ?
      mincol + ((w - mincol) / colinc.to_f).ceil * colinc :
      mincol
    padding = len - w + gaps * minpad
    if @special_separator and
      (state.column + len + @special_separator.n(state) >
        @special_separator.line_length(state))
      state.print first
    end
    # TODO: perhaps not great to have an anonymous function here, but it
    # simplifies the algorithm considerably…
    do_padding = lambda do
      pad_len = gaps.zero? ? padding : (padding / gaps.to_f).truncate
      padding -= pad_len
      gaps -= 1
      state.print padchar * pad_len
    end
    do_padding.call if colon? or (not at? and buffers.length.eql? 1)
    unless buffers.empty?
      state.print buffers.shift
      buffers.each{ |buffer| do_padding.call; state.print buffer }
    end
    do_padding.call if at?
  end

  def new_prefixer(prefix)
    output_prefix = true
    lambda do |str| 
      returning "" do |out|
        str.each do |s|
          out << prefix if output_prefix
          out << s
          output_prefix = true
        end
        output_prefix = str =~ /\n$/
      end
    end
  end

  def process_as_blocks(state)
    args = at? ? Array.new(state.args.left){ state.args.get } : state.args.get(:to_ary)
    state = state.dup_with_args(args)
    if @clauses.size > 1 and @special_separator
      catch :up_and_out do
        state.with_output_to(IO::FilteringOutput.new(&new_prefixer(@clauses[0][0]))) do
          state.execute(@clauses[@clauses.size > 1 ? 1 : 0])
        end
      end
    else
      state.print @clauses[0] if @clauses.size > 1
      catch(:up_and_out){ state.execute(@clauses[@clauses.size > 1 ? 1 : 0]) }
    end
    state.print @clauses[2][0] if @clauses.size > 2
  end
end
