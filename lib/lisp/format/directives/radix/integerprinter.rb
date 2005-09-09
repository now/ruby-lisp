# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::Directives::Radix::IntegerPrinter
  # TODO: perhaps this should be updated to not use Integer#to_s and
  # String#gsub?
  def print_int(state, radix, mincol, padchar, commachar, commainterval)
    if (arg = state.args.get).respond_to? :to_int
      num = arg.to_int
      str = num.to_s(radix)
      if colon?
        str.gsub!(/(\d)(?=(\d{#{commainterval}})+(?!\d))/, "\\1#{commachar}")
      end
      str[0,0] = '+' if at? and num >= 0
      state.print str.rjust(mincol, padchar)
    else
      state.args.unget
      delegate(?A, [], Lisp::Format::Directives::Directive::NoMods, state)
    end
  end
end
