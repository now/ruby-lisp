# contents: Scanner that lexes and parses format strings into directives.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'stringio'
require 'forwardable'
require 'injector'

require 'lisp/format/directives'
require 'lisp/format/parameters'
require 'lisp/format/modifiers'

class Lisp::Format::Scanner
  extend Forwardable
  extend Injector

  needs 'lisp/format/error'

  DirectiveChar = ?~

  def initialize(format)
    @format, @stack = StringIO.new(format), []
  end

  def rest
    returning([]){ |ds| while d = scan: ds << d end }
  end

  def with(directive)
    @stack.push directive
    while d = scan: yield d end
    raise Error.new(directive.pos, 'no corresponding end bracket found') unless d
  ensure
    @stack.pop
  end

  def between(left, right)
    right = Lisp::Format::Directives[right]
    returning [] do |directives|
      with(left) do |directive|
        directives << directive
        break if directive.is_a? right
      end
    end
  end

  def while
    returning "" do |str|
      until @format.eof?
        if not yield c = @format.getc
          @format.ungetc(c)
          break
        end
        str << c
      end
    end
  end

  def processing?(directive)
    @stack.last.is_a?(directive) ? @stack.last : nil
  end

  def_delegator :@format, :ungetc

private

  def scan
    return nil if @format.eof?
    if (c = @format.getc) == DirectiveChar
      params = parse_params
      modifiers = parse_modifiers
      directive = parse_directive
      directive.new(params, modifiers, @format.pos, self)
    else
      returning Lisp::Format::Directives::Pseudo::Literal.new(c.chr) do |literal|
        literal << c.chr while c = @format.getc and c != DirectiveChar
        @format.ungetc(c) if c == DirectiveChar
      end
    end
  end

  def parse_params
    returning Lisp::Format::Parameters::List.new do |params|
      until @format.eof?
        break unless param = Lisp::Format::Parameters::Parameter.parse(@format)
        params << param
        unless @format.eof?
          if (c = @format.getc) != ?,
            @format.ungetc(c)
            break
          end
        end
      end
    end
  end

  def parse_modifiers
    ms = none = Lisp::Format::Modifiers[false, false]
    until @format.eof
      break unless m = Lisp::Format::Modifiers.parse(@format)
      raise error('duplicate modifier ‘~C’', c) if ms & m != none
      ms |= m
    end
    ms
  end

  def parse_directive
    if @format.eof?
      raise error('format string ended before directive was found')
    elsif not Lisp::Format::Directives.include?(c = @format.getc.chr.upcase[0])
      raise error('unkown directive ‘~~~C’', c)
    else
      Lisp::Format::Directives[c]
    end
  end

  def error(format, *args)
    Error.new(@format.pos, format, *args)
  end
end
