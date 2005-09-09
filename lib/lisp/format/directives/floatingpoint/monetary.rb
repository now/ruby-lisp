# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::FloatingPoint::Monetary < Lisp::Format::Directives::Directive
  directive [2, 1, 0, ' '], BothMods, ?$

  def execute(state, d, n, w, padchar)
    if (arg = state.args.get).respond_to? :to_f
      sign = (arg >= 0 ? (at? ? '+' : '') : '-')
      str = sprintf("%0#{n + d + 1}.#{d}f", arg.abs)
      str = colon? ?
        (sign + str.rjust(w, padchar)) :
        (sign + str).rjust(w, padchar)
      state.print str
    else
      delegate_to_d(w, state)
    end
  end
end
