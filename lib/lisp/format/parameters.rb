# contents: Module containing possible parameters to format directives.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::Parameters
  require 'lisp/format/parameters/argument'
  require 'lisp/format/parameters/argumentcount'
  require 'lisp/format/parameters/character'
  require 'lisp/format/parameters/default'
  require 'lisp/format/parameters/integer'
  require 'lisp/format/parameters/list'

  def self.from(values, pos = -1)
    List.new(values.map do |value|
      case value
      when ::Integer: Integer
      when ::String:  Character
      else            Parameter
      end.new(pos, value)
    end)
  end
end
