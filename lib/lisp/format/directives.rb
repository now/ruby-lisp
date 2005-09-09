# contents: Module containing format directives.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::Directives
  Directives = {}

  def self.[]=(symbol, directive)
    Directives[symbol] = directive
  end

  def self.[](symbol)
    Directives[symbol]
  end

  def self.include?(symbol)
    Directives.include? symbol
  end

  # TODO: This is a bit ugly
  require 'lisp/format/directives/directive'
  require 'lisp/format/directives/enddirective'

  require 'lisp/format/directives/basic'
  require 'lisp/format/directives/control'
  require 'lisp/format/directives/floatingpoint'
  require 'lisp/format/directives/layout'
  require 'lisp/format/directives/misc'
  require 'lisp/format/directives/prettyprinter'
  require 'lisp/format/directives/printer'
  require 'lisp/format/directives/pseudo'
  require 'lisp/format/directives/radix'
end
