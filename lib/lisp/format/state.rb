# contents: Object that keeps track of state while processing format directives.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'forwardable'
require 'injector'

require 'lisp/format/io/columntrackingoutput'

class Lisp::Format::State
  extend Forwardable
  extend Injector

  needs 'lisp/format/error'

  def initialize(args, output)
    @args, @output = Arguments.new(args), output
    connect(Lisp::Format::IO::ColumnTrackingOutput.new)
  end

  def dup_with_args(args)
    returning(self.class.new(args, @output)){ |state| state.parent = self }
  end

  def with_output_to(output)
    connect(output)
    yield
    output
  ensure
    disconnect(output)
  end

  def execute(directives)
    directives.each do |directive|
      begin
        directive.execute(self, *directive.params.values(self))
      rescue => e
        e.pos = directive.pos if e.respond_to? :pos and e.pos == -1
        raise
      end
    end
  end

  # #use or #using
  def with_sets(sets)
    raise ScriptError, 'can’t deal with more than one set at once' if @sets
    @sets = Sets.new(sets)
    @sets.each{ |set| yield set }
  ensure
    @sets = nil
  end

  def_delegators :@output, :print, :putc, :column

  attr_reader :args, :sets, :parent

protected

  attr_writer :parent

private

  def connect(output)
    output.next = @output
    @output = output
  end

  def disconnect(output)
    @output = output.next
  end

  class Arguments
    def initialize(args)
      @args, @pos = args, 0
    end

    def move(n = 1, relative = true)
      @pos = relative ? @pos + n : n
      raise error('no arguments left; all~[~:;~D~] arguments have been used',
                  @args.size) if @pos > @args.size
      raise error('can’t move past first argument') if @pos < 0
    end
    
    def get(method = nil)
      move(1)
      arg = @args[@pos - 1]
      if method
        raise error('argument doesn’t respond to ~A') unless arg.respond_to? method
        arg.send(method)
      else
        arg
      end
    end

    def unget
      move(-1)
    end

    def left
      @args.size - @pos
    end

    def error(format, *args)
      Error.new(-1, format, *args)
    end

    private :error
  end

  # FIXME: A possible way of implementing the Sets class
#  class Sets < Arguments
#    def each
#      left.times{ yield get }
#    end
#  end

  class Sets
    def initialize(sets)
      @sets, @pos = sets, 0
    end

    def each
      @sets.each do |set|
        @pos += 1
        yield set
      end
    end

    def left
      @sets.size - @pos
    end
  end
end
