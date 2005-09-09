# contents: A class for character (/'./) parameters.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/parameters/parameter'

class Lisp::Format::Parameters::Character < Lisp::Format::Parameters::Parameter
  parameter_parser(/'/) do |_, format|
    if format.eof?
      raise Error.new(format.pos, 'format string ended before character ~
                      parameter could be read')
    end
    self.new(format.pos, format.getc.chr)
  end
end
