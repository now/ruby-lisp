# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

# TODO: the colon modifier needs to be used.
# NOTE: extension: allow padchar parameter as well
class Lisp::Format::Directives::Layout::Tabulate < Lisp::Format::Directives::Directive
  directive [1, 1, ' '], AtMod, ?T

  def execute(state, colnum, colinc, padchar)
    if at?
      state.print padchar * colnum
      c = state.column % colinc
      state.print padchar * (colinc - c) unless c.zero?
    else
      if state.column < colnum
        state.print padchar * (colnum - state.column)
      elsif colinc > 0
        k = 1 + (state.column - colnum) / colinc
        state.print padchar * ((colnum + k * colinc) - state.column)
      end
    end
  end
end
