# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Basic::Directive < Lisp::Format::Directives::Directive
  add_attr_accessor :character

  def self.directive(symbol, c = symbol)
    super [1], NoMods, symbol
    self.character = c
  end

  def execute(state, n)
    n.times{ state.putc self.class.character }
  end
end
