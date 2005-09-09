# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/directives/radix/integerprinter'

class Lisp::Format::Directives::Radix::Directive < Lisp::Format::Directives::Directive
  include Lisp::Format::Directives::Radix::IntegerPrinter

  def self.radix=(radix)
    unless radix.between?(2, 36)
      raise ArgumentError, 'illegal radix #{radix}; must be between 2 and 36'
    end
    @radix = radix
  end

  def self.radix
    @radix
  end

  def self.directive(symbol, radix)
    super [0, ' ', ',', 3], BothMods, symbol
    self.radix = radix
  end

  def execute(state, mincol, padchar, commachar, commainterval)
    print_int(state, self.class.radix, mincol, padchar, commachar, commainterval)
  end
end
