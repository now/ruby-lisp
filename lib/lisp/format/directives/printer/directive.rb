# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Printer::Directive < Lisp::Format::Directives::Directive
  add_attr_accessor :want_inspect

  def self.directive(symbol, want_inspect)
    super [0, 1, 0, ' '], BothMods, symbol
    self.want_inspect = want_inspect
  end

  # TODO: the colon directive is meaningful in Lisp, but not in Ruby.
  # It should make nil print as (), but that's only because the two are
  # synonymous in Lisp.  There's no such thing in Ruby.
  def execute(state, mincol, colinc, minpad, padchar)
    # TODO: how do we clean this up?
    if (arg = state.args.get).respond_to? :to_str and not self.class.want_inspect
      str = arg.to_str
    else
      str = arg.inspect
    end
    padmethod = at? ? :rjust : :ljust
    str = str.send(padmethod, str.length + minpad, padchar)
    if (k = ((mincol - str.length) / colinc.to_f).ceil) > 0
      str = str.send(padmethod, str.length + colinc * k, padchar)
    end
    state.print str
  end
end
