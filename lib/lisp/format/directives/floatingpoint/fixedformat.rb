# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::FloatingPoint::FixedFormat < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN, Fixnum::MIN, 0, '', ' '], AtMod, ?F

  def execute(state, w, d, k, overflowchar, padchar)
    if (arg = state.args.get).respond_to? :to_f
      # TODO: this algorithm can probably be cleaned up a bit.
      # Try to minimize use of sprintf here
      num = arg.to_f * (10 ** k)
      sign = (at? and num >= 0) ? '+' : ''
      str = sign + (d < 0 ? num.to_s : sprintf("%.#{d}f", num))
      str << '.' if d == 0
      str = sign + sprintf("%.#{$1}f", num) if str =~ /e-([0-9]+)$/
      if w >= 0
        if d >= 0 and w <= d + 1 + (num < 0 || at? ? 1 : 0)
          str = str.sub(/^([+-]?)0\./, '\1.')
        end
        str = str.rjust(w, padchar)
        if str.length > w and d < 0
          prec = w - (str.index(/\./) + 1) 
          str = sign + sprintf("%#.#{prec}f", num)
        end
        str.sub!(/\.$/, '') if str.length > w and d < 0
        str = overflowchar * w if str.length > w and overflowchar != ''
      end
      state.print str
    else
      delegate_to_d(w, state) 
    end
  end
end
