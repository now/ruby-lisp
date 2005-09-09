# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_CaseConversionDirective < Test::Unit::TestCase
  def_format_test :test_01, "~(XXyy~AuuVV~)", ["ABc dEF ghI"], "xxyyabc def ghiuuvv"

  # Conversion of simple characters to downcase.

  def test_02
    0.upto(255) do |c|
      if c =~ /[A-Z]/
        s1 = "~(~c~)".format(c)
        s2 = c.chr.downcase
        assert_equal(1, s1.length)
        assert_equal(1, s2.length)
        assert_equal(s2[0], s1[0])
      end
    end
  end

  def_format_test :test_03, "~@(this is a TEST.~)", [], "This is a test."

  def_format_test :test_04, '~@(!@#$%^&*this is a TEST.~)', [], '!@#$%^&*This is a test.'

  def_format_test :test_05, "~:(this is a TEST.~)", [], "This Is A Test."
			
  def_format_test :test_06, "~:(this is7a TEST.~)", [], "This Is7a Test."

  def_format_test :test_07, "~:@(this is AlSo A teSt~)", [], "THIS IS ALSO A TEST"

  def test_08
    0.upto(255) do |c|
      if c =~ /[a-z]/
        s1 = "~(~c~)".format(c)
        s2 = c.chr.upcase
        assert_equal(1, s1.length)
        assert_equal(1, s2.length)
        assert_equal(s2[0], s1[0])
      end
    end
  end

  # Nested conversion

  def_format_test :test_09, "~(aBc ~:(def~) GHi~)", [], "abc def ghi"

  def_format_test :test_10, "~(aBc ~(def~) GHi~)", [], "abc def ghi"

  def_format_test :test_11, "~@(aBc ~:(def~) GHi~)", [], "Abc def ghi"

  def_format_test :test_12, "~(aBc ~@(def~) GHi~)", [], "abc def ghi"

  def_format_test :test_13, "~(aBc ~:(def~) GHi~)", [], "abc def ghi"

  def_format_test :test_14, "~:(aBc ~(def~) GHi~)", [], "Abc Def Ghi"

  def_format_test :test_15, "~:(aBc ~:(def~) GHi~)", [], "Abc Def Ghi"

  def_format_test :test_16, "~:(aBc ~@(def~) GHi~)", [], "Abc Def Ghi"

  def_format_test :test_17, "~:(aBc ~@:(def~) GHi~)", [], "Abc Def Ghi"

  def_format_test :test_18, "~@(aBc ~(def~) GHi~)", [], "Abc def ghi"

  def_format_test :test_19, "~@(aBc ~:(def~) GHi~)", [], "Abc def ghi"

  def_format_test :test_20, "~@(aBc ~@(def~) GHi~)", [], "Abc def ghi"

  def_format_test :test_21, "~@(aBc ~@:(def~) GHi~)", [], "Abc def ghi"

  def_format_test :test_22, "~:@(aBc ~(def~) GHi~)", [], "ABC DEF GHI"

  def_format_test :test_23, "~@:(aBc ~:(def~) GHi~)", [], "ABC DEF GHI"

  def_format_test :test_24, "~:@(aBc ~@(def~) GHi~)", [], "ABC DEF GHI"

  def_format_test :test_25, "~@:(aBc ~@:(def~) GHi~)", [], "ABC DEF GHI"
end
