# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/directives/radix/integerprinter'

class Lisp::Format::Directives::Radix::Radix < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN, 0, ' ', ',', 3], BothMods, ?R

  include Lisp::Format::Directives::Radix::IntegerPrinter

  def execute(state, radix, mincol, padchar, commachar, commainterval)
    if radix == Fixnum::MIN
      state.print send(modcase(:cardinal, :ordinal, :roman, :old_roman),
                        state.args.get(:to_int))
    elsif radix.between?(2, 36)
      print_int(state, radix, mincol, padchar, commachar, commainterval)
    else
      raise perror(0, 'radix must be between 2 and 36')
    end
  end

private

  Names = {
      1 => 'one',       2 => 'two',         3 => 'three',
      4 => 'four',      5 => 'five',        6 => 'six',
      7 => 'seven',     8 => 'eight',       9 => 'nine',
    10 => 'ten',      11 => 'eleven',     12 => 'twelve',
    13 => 'thirteen', 14 => 'fourteen',   15 => 'fifteen',
    16 => 'sixteen',  17 => 'seventeen',  18 => 'eighteen',
    19 => 'nineteen', 20 => 'twenty',     30 => 'thirty',
    40 => 'forty',    50 => 'fifty',      60 => 'sixty',
    70 => 'seventy',  80 => 'eighty',     90 => 'ninety'
  }

  Illions = %w[ \ 
    thousand      million         billion           trillion
    quadrillion   quintillion     sextillion        septillion
    octillion     nonillion       decillion         undecillion
    duodecillion  tredecillion    quattuordecillion quindecillion
    sexdecillion  septendecillion octodecillion     novemdecillion
    vigintillion
  ]

  OrdinalOnes = %w[
    \         first     second      third       fourth
    fifth     sixth     seventh     eighth      ninth
    tenth     eleventh  twelfth     thirteenth  fourteenth
    fifteenth sixteenth seventeenth eighteenth  nineteenth
  ]

  OrdinalTens = %w[
    \     \             twentieth   thirtieth fortieth
    fiftieth  sixtieth  seventieth  eightieth ninetieth
  ]

  Romans = [
    [1000, 'M'],  [900, 'CM'],    [500, 'D'], [400, 'CD'],
    [100,  'C'],  [90,  'XC'],    [50,  'L'], [40,  'XL'],
    [10,   'X'],  [9,  'IX'],     [5,   'V'], [4,   'IV'],
    [1,   'I']
  ]

  OldRomans = [
    [1000,  'M'], [900, 'DCCCC'], [500, 'D'], [400, 'CCCC'],
    [100,   'C'], [90,  'LXXXX'], [50,  'L'], [40,  'XXXX'],
    [10,    'X'], [9,   'VIIII'], [5,   'V'], [4,   'IIII'],
    [1,     'I']
  ]

  def cardinal(n)
    return 'zero' if n.zero?
    out = []
    negative = n < 0
    n = n.abs
    p = 0
    until n.zero?
      q, r = n.divmod 1000
      unless r.zero?
        c = cardinal_100s(r)
        unless p.zero?
          c << ' '
          c << p < Illions.size ?
                              Illions[p] :
                              (' times ten to the ' + (p * 3).to_s + ' power')
        end
        out << c
      end
      n = q
      p += 1
    end
    (negative ? 'minus ' : '') + out.reverse.join(', ')
  end

  def cardinal_100s(n)
    out = []
    h, to = n.divmod 100
    out << Names[h] + ' hundred' unless h.zero?
    if to >= 20
      t, o = to.divmod 10
      out << Names[t * 10] + (o.nonzero? ? '-' + Names[o] : "")
    elsif to.nonzero?
      out << Names[to]
    end
    out.join(' ')
  end

  def ordinal(n)
    return 'zeroth' if n.zero?
    out = []
    if n < 0
      out << 'minus'
      n = n.abs
    end
    h, to = n.divmod 100
    out << cardinal(h * 100) + (to.zero? ? 'th' : "") unless h.zero?
    if to >= 20
      t, o = to.divmod 10
      out << (o.zero? ? OrdinalTens[t] : (Names[t * 10] + '-' + OrdinalOnes[o]))
    elsif to.nonzero?
      out << OrdinalOnes[to]
    end
    out.join(' ')
  end

  def roman_helper(n, table)
    unless n.is_a? Fixnum
      raise error('only Fixnum values can be converted to roman numerals')
    end
    table.map{ |decimal, roman|
      q, r = n.divmod(decimal)
      unless q.zero?
        n = r
        roman * q
      end
    }.join
  end

  def roman(n)
    roman_helper(n, Romans)
  end

  def old_roman(n)
    roman_helper(n, OldRomans)
  end
end
