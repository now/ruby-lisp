# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::PrettyPrinter::ConditionalNewline < Lisp::Format::Directives::Directive
  directive [], BothMods, ?_

  def execute(state)
    state.putc ?\n if both?
  end
end
