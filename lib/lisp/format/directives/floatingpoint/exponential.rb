# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::FloatingPoint::Exponential < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN, Fixnum::MIN, Fixnum::MIN, 1, '', ' ', 'e'], AtMod, ?E

  def execute(state, w, d, e, k, overflowchar, padchar, exponentchar)
    if (arg = state.args.get).respond_to? :to_f
      num = arg.to_f
      sign = (num >= 0 and at?) ? '+' : ''
      exp = Math.log10(num.abs).floor - (k - 1)
      exp_str = exponentchar + (exp >= 0 ? '+' : '-') + exp.abs.to_s.rjust(e, '0')
      digits = (num * (10 ** -exp)).to_s
      if d < 0 and w < 0 and e < 0
        str = sign + digits + exp_str
      else
        if d < 0
          prec = w - sign.length - digits.index('.') + 1 - exp_str.length
          str = sign + sprintf("%#.#{prec}f", num) + exp_str
        else
          if k > 0
            raise perror(3, 'scale must be less than digits + 2') if k >= d + 2
            # TODO: is this right?
            prec = d - k + 1
          else
            prec = -k + (d + k)
          end
          str = sign + sprintf("%#.#{prec}f", num * (10**-exp)) + exp_str
        end
        unless w < 0
          str.sub!(/^([+-]?)0\./, '\1.') if k <= 0 and str.length > w
          str = str.rjust(w, padchar) if str.length < w
        end
        unless w < 0 and overflowchar == '' and e >= 0 and (exp_str.length - 2) > e
          str = overflowchar * w
#          unless w < 0 and overflowchar == ''
#            if not e < 0 and (exp_str.length - 2) > e
#            end
        end
      end
      state.print str
    else
      delegate_to_d(w, state) 
    end
  end
end
