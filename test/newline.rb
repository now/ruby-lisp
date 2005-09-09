# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_NewlineDirective < Test::Unit::TestCase
  def_format_test :test_1, "~%", [], "\n"

  def test_2
    0.upto(100) do |i|
      s1 = "\n" * i
      format_string = "~~~D%".format(i)
      s2 = format_string.format
      assert_equal(s1, s2)
      assert_equal(s1, s2.format)
    end
  end

  def_format_test :test_3, "~v%", [nil], "\n"

  def_format_test :test_4, "~V%", [1], "\n"

  def_range_test :test_5, 0..100, "\n", "~v%"

  def_range_args_test :test_6, 0..100, "\n", "~#%"
end
