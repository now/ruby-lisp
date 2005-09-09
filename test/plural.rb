# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_PluralDirective < Test::Unit::TestCase
  def_format_test :test_01, "~p", [1], ""

  def_format_test :test_02, "~P", [2], "s"

  def_format_test :test_03, "~p", [0], "s"

  def_format_test :test_04, "~P", [1.0], "s"

  def test_05
    MiniUniverse.each do |e|
      assert_equal("s", "~p".format(e)) unless e.eql? 1
    end
  end

  # ~:P

  def_format_test :test_06, "~D cat~:P", [1], "1 cat"

  def_format_test :test_07, "~D cat~:p", [2], "2 cats"

  def_format_test :test_08, "~D cat~:P", [0], "0 cats"

  def_format_test :test_09, "~D cat~:p", ["No"], "No cats"

  # ~:@P

  def_format_test :test_10, "~D penn~:@P", [1], "1 penny"

  def_format_test :test_11, "~D penn~:@p", [2], "2 pennies"

  def_format_test :test_12, "~D penn~@:P", [0], "0 pennies"

  def_format_test :test_13, "~D penn~@:p", ["No"], "No pennies"

  # ~@P

  def_format_test :test_14, "~@p", [1], "y"

  def_format_test :test_15, "~@P", [2], "ies"

  def_format_test :test_16, "~@p", [0], "ies"

  def_format_test :test_17, "~@P", [1.0], "ies"

  def test_18
    MiniUniverse.each do |e|
      assert_equal("ies", "~@p".format(e)) unless e.eql? 1
    end
  end
end
