# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_StandardDirective < Test::Unit::TestCase
  def_format_test :test_01, "~s", [nil], "nil"

  def_format_test :test_02, "~:s", [nil], "nil"

  def_format_test :test_03, "~:S", [[nil]], "[nil]"

  def test_04
    StandardChars.each do |c|
      s = c.chr
      assert_equal(s.inspect, "~s".format(c.chr))
    end
  end

  def test_05
    0.upto(255) do |i|
      s = i.chr
      assert_equal(s.inspect, "~S".format(s))
    end
  end

  def test_06
    expected = ["nil", "nil", "nil", " nil", "  nil", "   nil", "    nil",
      "     nil", "      nil", "       nil"]
    1.upto(1){ |i| assert_equal(expected[i], "~~~d@s".format(i).format(nil)) }
  end

  def test_07
    expected = ["nil", "nil", "nil", "nil ", "nil  ", "nil   ", "nil    ",
      "nil     ", "nil      ", "nil       "]
    1.upto(1){ |i| assert_equal(expected[i], "~~~ds".format(i).format(nil)) }
  end

  def test_08
    expected = ["nil", "nil", "nil", " nil", "  nil", "   nil", "    nil",
      "     nil", "      nil", "       nil"]
    1.upto(1){ |i| assert_equal(expected[i], "~~~d:@s".format(i).format(nil)) }
  end

  def test_09
    expected = ["nil", "nil", "nil", "nil ", "nil  ", "nil   ", "nil    ",
      "nil     ", "nil      ", "nil       "]
    1.upto(1){ |i| assert_equal(expected[i], "~~~d:s".format(i).format(nil)) }
  end

  def test_10
    expected = ["nil", "nil", "nil", "nil ", "nil  ", "nil   ", "nil    ",
      "nil     ", "nil      ", "nil       "]
    1.upto(1){ |i| assert_equal(expected[i], "~v:s".format(i, nil)) }
  end

  def test_11
    expected = ["nil", "nil", "nil", " nil", "  nil", "   nil", "    nil",
      "     nil", "      nil", "       nil"]
    1.upto(1){ |i| assert_equal(expected[i], "~v@:s".format(i, nil)) }
  end

  def_format_test :test_12, "~vS", [nil, nil], "nil"

  def_format_test :test_13, "~v:S", [nil, nil], "nil"

  def_format_test :test_14, "~@S", [nil], "nil"

  def_format_test :test_15, "~v@S", [nil, nil], "nil"

  def_format_test :test_16, "~v:@s", [nil, nil], "nil"

  def_format_test :test_17, "~v@:s", [nil, nil], "nil"

  # Tests of the colinc parameter.

  def_format_test :test_18, "~4,3s", [nil], "nil   "

  def_format_test :test_19, "~3,3@s", [nil], "nil"

  def_format_test :test_20, "~4,4@s", [nil], "    nil"

  def_format_test :test_21, "~5,3@s", [nil], "   nil"

  def_format_test :test_22, "~5,3S", [nil], "nil   "

  def_format_test :test_23, "~7,3@s", [nil], "      nil"

  def_format_test :test_24, "~7,3S", [nil], "nil      "

  # Tests of the minpad parameter.

  def test_25
    expected = ["\"ABC\"  ", "\"ABC\"  ", "\"ABC\"  ", "\"ABC\"  ", "\"ABC\"  ",
      "\"ABC\"  ", "\"ABC\"  ", "\"ABC\"  ", "\"ABC\"  ", "\"ABC\"  ",
      "\"ABC\"  ", "\"ABC\"  ", "\"ABC\"   ", "\"ABC\"    ", "\"ABC\"     "]
    -4.upto(10){ |i| assert_equal(expected[i + 4], "~v,,2S".format(i, "ABC")) }
  end

  def_format_test :test_26, "~5,,+2S", ["ABC"], "\"ABC\"  "

  def_format_test :test_27, "~5,,0S", ["ABC"], "\"ABC\""

  def_format_test :test_28, "~5,,-1S", ["ABC"], "\"ABC\""

  def_format_test :test_29, "~5,,0S", ["ABCD"], "\"ABCD\""

  def_format_test :test_30, "~5,,-1S", ["ABCD"], "\"ABCD\""

  # Tests of the padchar parameter.

  def_format_test :test_31, "~6,,,'XS", ["AB"], "\"AB\"XX"

  def_format_test :test_32, "~6,,,s", ["AB"], "\"AB\"  "

  def_format_test :test_33, "~6,,,'X@s", ["AB"], "XX\"AB\""

  def_format_test :test_34, "~6,,,@S", ["AB"], "  \"AB\""

  def_format_test :test_35, "~12,,,vS", [nil, "abcde"], "\"abcde\"     "

  def_format_test :test_36, "~12,,,v@S", [nil, "abcde"], "     \"abcde\""

  def_format_test :test_37, "~12,,,vs", ['*', "abcde"], "\"abcde\"*****"

  def_format_test :test_38, "~12,,,v@s", ['*', "abcde"], "*****\"abcde\""

  # Other tests.

  def_format_test :test_39, "~5,,vS", [nil, "ABC"], "\"ABC\""

  def_format_test :test_40, "~6,,vs", [-1, "abcd"], "\"abcd\""

  def_format_test :test_41, "~7,vS", [nil, "abc"], "\"abc\"  "

  def_format_test :test_42, "~7,vS", [3, "abc"], "\"abc\"   "

  def_format_test :test_43, "~7,v@S", [3, "abc"], "   \"abc\""

  # General parameter-tests.

  def_format_test :test_44, "~#S", ["abc", nil, nil, nil], "\"abc\""

  def_format_test :test_45, '~#@s', ["abc", nil, nil, nil, nil, nil], " \"abc\""

  def_format_test :test_46, "~7,#s", ["abc", nil, nil, nil], "\"abc\"    "

  def_format_test :test_47, '~7,#@S', ["abc", nil, nil, nil], "    \"abc\""

  def_format_test :test_48, "~6,#S", ["abc", nil, nil], "\"abc\"   "

  def_format_test :test_49, '~6,#@S', ["abc", nil, nil], "   \"abc\""

  def_format_test :test_50, "~#,#S", ["abc", nil, nil, nil, nil, nil], "\"abc\"      "

  def_format_test :test_51, '~#,#@S', ["abc", nil, nil, nil, nil, nil], "      \"abc\""

  def_format_test :test_52, "~-100S", ["xyz"], "\"xyz\""

  def_format_test :test_53, "~-100000000000000000000s", ["xyz"], "\"xyz\""
end
