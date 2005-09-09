# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Basic::FreshLine < Lisp::Format::Directives::Directive
  directive [1], NoMods, ?&

  def execute(state, n)
    return if n.zero?
    state.putc ?\n if state.column > 0
    (n - 1).times{ state.putc ?\n }
  end
end
