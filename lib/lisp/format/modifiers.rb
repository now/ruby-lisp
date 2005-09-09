# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::Modifiers
  ModifierChars = [?:, ?@]

  Modifiers = [
    [nil, nil],
    [nil, [nil, nil]]
  ]

  def self.[]=(colon, at, both, modifier)
    if colon and at
      Modifiers[1][1][both ? 1 : 0] = modifier
    else
      Modifiers[colon ? 1 : 0][at ? 1 : 0] = modifier
    end
  end

  def self.[](colon, at, both = true)
    m = Modifiers[colon ? 1 : 0][at ? 1 : 0]
    return (colon and at) ? m[both ? 1 : 0] : m
  end

  # TODO: check that c is in ModifierChars
  def self.from(c)
    self[c == ?:, c == ?@]
  end

  def self.parse(format)
    include?(c = format.getc) ? from(c) : (format.ungetc(c); nil)
  end

  def self.include?(c)
    ModifierChars.include? c
  end

  require 'lisp/format/modifiers/modifier'

  require 'lisp/format/modifiers/none'
  require 'lisp/format/modifiers/colon'
  require 'lisp/format/modifiers/at'
  require 'lisp/format/modifiers/either'
  require 'lisp/format/modifiers/both'
end
