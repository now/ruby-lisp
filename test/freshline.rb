# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_AmpersandDirective < Test::Unit::TestCase
  def_format_test :test_01, "~0&", [], ""

  def_format_test :test_02, "~&", [], ""

  def_format_test :test_03, "X~&", [], "X\n"

  def_format_test :test_04, "X~%~&", [], "X\n"

  def test_05
    1.upto(100){ |i| assert_equal("\n" * (i - 1), "~~~D&".format(i).format) }
  end

  def test_06
    1.upto(100){ |i| assert_equal("X" + "\n" * i, "X~~~D&".format(i).format) }
  end

  def_format_test :test_07, "~v&", [nil], ""

  def_format_test :test_08, "X~v&", [nil], "X\n"

  def test_09
    1.upto(100){ |i| assert_equal("\n" * (i - 1), "~V&".format(i)) }
  end

  def test_10
    1.upto(100){ |i| assert_equal("\n" * (i - 1), "~#&".format(*Array.new(i))) }
  end

  def_format_test :test_11, "X~V%", [0], "X"

  def_format_test :test_12, "X~#%", [], "X"

  def_format_test :test_13, "X~#%", [:a, :b, :c], "X\n\n\n"
end
