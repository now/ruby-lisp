# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::FloatingPoint::General < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN, Fixnum::MIN, Fixnum::MIN, 1, '', ' ', 'e'], AtMod, ?G

  def execute(state, w, d, e, k, overflowchar, padchar, exponentchar)
    if (arg = state.args.get).respond_to? :to_f
      num = arg.to_f
      n = num == 0.0 ? 0 : Math.log10(num.abs).floor + 1
      ee = e < 0 ? 4 : e + 2
      ww = w < 0 ? nil : w - ee
      if d < 0
        q = num.to_s.length
        d = Math.max(q, Math.min(n, 7))
      end
      dd = d - n
      state.args.unget
      if dd.between?(0, d)
        delegate(?F, [ww, dd, e, overflowchar, padchar], @modifiers, state)
        delegate(?T, [ee], [?@], state)
      else
        delegate(?E, [w, d, e, k, overflowchar, padchar, exponentchar],
                  @modifiers, state)
      end
    else
      delegate_to_d(w, state)
    end
  end
end
