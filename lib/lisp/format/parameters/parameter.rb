# contents: Base class for format-directive parameters.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Parameters::Parameter
  @@parsers = []

  def initialize(pos, value = nil)
    @pos, @value = pos, value
  end

  def self.parameter_parser(regex, &parser)
    @@parsers << [regex, parser]
  end

  def self.simple_parameter_parser(regex)
    parameter_parser(regex){ |_, format| self.new(format.pos) }
  end

  def self.parse(format)
    s = format.getc.chr
    @@parsers.each do |regex, parser|
      return parser.call(s[0], format) if s =~ regex
    end
    format.ungetc(s[0])
    nil
  end

  def value(_state)
    @value
  end

  attr_reader :pos
  attr_writer :value
end
