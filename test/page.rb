# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_PageDirective < Test::Unit::TestCase
  def_format_test :test_1, "~0|", [], ""

  def test_2
    s = "~|".format
    unless s == ""
      c = s[0]
      2.upto(100) do |i|
        s = "~~~D|".format(i).format
        assert_equal(i, s.length)
        s.each_byte{ |b| assert_equal(c, b) }
      end
    end
  end

  def test_3
    s = "~|".format
    unless s == ""
      c = s[0]
      2.upto(100) do |i|
        s = "~v|".format(i).format
        assert_equal(i, s.length)
        s.each_byte{ |b| assert_equal(c, b) }
      end
    end
  end

  def_format_test :test_4, "~V|", [0], ""

  def_format_test :test_5, "~v|", [nil], "~|".format
end
