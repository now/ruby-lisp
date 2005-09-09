# contents: A parameter based on an argument (/[Vv]/).
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/error'
require 'lisp/format/parameters/default'

class Lisp::Format::Parameters::Argument < Lisp::Format::Parameters::Default
  simple_parameter_parser(/[Vv]/)

  def value(state)
    begin
      arg = state.args.get
    rescue => e
      e.pos = @pos if e.respond_to? :pos and e.pos == -1
      raise
    end
    if not arg
      @value
    elsif @value.respond_to? :to_int and arg.respond_to? :to_int
      arg.to_int
    elsif @value.respond_to? :to_str and arg.respond_to? :to_str
      arg.to_str
    elsif @value.nil?
      arg
    else
      raise error('argument doesn’t respond to :to_~:[str~;int~]',
                  @value.respond_to?(:to_int))
    end
  end
end
