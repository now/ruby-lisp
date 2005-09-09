# contents: A parameters for the default value of a parameter.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/parameters/parameter'

class Lisp::Format::Parameters::Default < Lisp::Format::Parameters::Parameter
  parameter_parser(/,/) do |c, format|
    returning(self.new(format.pos)){ format.ungetc(c) }
  end
end
