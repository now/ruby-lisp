# contents: A class representing integer (/[+-]\d*/) directives.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/parameters/parameter'

class Lisp::Format::Parameters::Integer < Lisp::Format::Parameters::Parameter
  parameter_parser(/[-+\d]/) do |c, f|
    sign = (c == ?-) ? -1 : 1
    i = (c == ?+ or c == ?-) ? 0 : c - ?0
    i = i * 10 + (c - ?0) until f.eof? or not (c = f.getc).between?(?0, ?9)
    f.ungetc(c) unless c.between?(?0, ?9)
    self.new(f.pos, i * sign)
  end
end
