# contents: A parameter whose value is the number of arguments left (/#/).
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/parameters/integer'

class Lisp::Format::Parameters::ArgumentCount < Lisp::Format::Parameters::Integer
  simple_parameter_parser(/#/)

  def value(state)
    state.args.left
  end
end
