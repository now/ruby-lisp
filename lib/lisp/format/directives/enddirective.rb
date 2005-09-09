# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::EndDirective < Lisp::Format::Directives::Directive
  add_attr_accessor :begin_symbol

  def self.directive(begin_symbol, defaults, modifiers, symbol)
    super defaults, modifiers, symbol
    self.begin_symbol = begin_symbol
  end

  def initialize(params, modifiers, pos, scanner)
    super
    unless Lisp::Format::Directives.include? self.class.begin_symbol
      raise ScriptError, 'missing directive class for begin symbol'
    end
    directive = Lisp::Format::Directives[self.class.begin_symbol]
    unless scanner.processing? directive
      raise error('~~~C without matching ~~~C', self.class.symbol, directive.symbol)
    end
  end
end
