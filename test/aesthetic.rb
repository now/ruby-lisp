# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_AestheticDirective < Test::Unit::TestCase
  def_format_test :test_01, "~a", [nil], "nil"

  def_format_test :test_02, "~:a", [nil], "nil"

  def_format_test :test_03, "~:A", [[nil]], "[nil]"

  def test_04
    StandardChars.each do |c|
      s = c.chr
      assert_equal(s, "~a".format(s))
    end
  end

  def test_05
    0.upto(255) do |i|
      s = i.chr
      assert_equal(s, "~A".format(s))
    end
  end

  def test_06
    expected = ["nil", "nil", "nil", " nil", "  nil", "   nil", "    nil",
      "     nil", "      nil", "       nil"]
    1.upto(1){ |i| assert_equal(expected[i], "~~~d@a".format(i).format(nil)) }
  end

  def test_07
    expected = ["nil", "nil", "nil", "nil ", "nil  ", "nil   ", "nil    ",
      "nil     ", "nil      ", "nil       "]
    1.upto(1){ |i| assert_equal(expected[i], "~~~da".format(i).format(nil)) }
  end

  def test_08
    expected = ["nil", "nil", "nil", " nil", "  nil", "   nil", "    nil",
      "     nil", "      nil", "       nil"]
    1.upto(1){ |i| assert_equal(expected[i], "~~~d:@a".format(i).format(nil)) }
  end

  def test_09
    expected = ["nil", "nil", "nil", "nil ", "nil  ", "nil   ", "nil    ",
      "nil     ", "nil      ", "nil       "]
    1.upto(1){ |i| assert_equal(expected[i], "~~~d:a".format(i).format(nil)) }
  end

  def test_10
    expected = ["nil", "nil", "nil", "nil ", "nil  ", "nil   ", "nil    ",
      "nil     ", "nil      ", "nil       "]
    1.upto(1){ |i| assert_equal(expected[i], "~v:a".format(i, nil)) }
  end

  def test_11
    expected = ["nil", "nil", "nil", " nil", "  nil", "   nil", "    nil",
      "     nil", "      nil", "       nil"]
    1.upto(1){ |i| assert_equal(expected[i], "~v@:a".format(i, nil)) }
  end

  def_format_test :test_12, "~vA", [nil, nil], "nil"

  def_format_test :test_13, "~v:A", [nil, nil], "nil"

  def_format_test :test_14, "~@A", [nil], "nil"

  def_format_test :test_15, "~v@A", [nil, nil], "nil"

  def_format_test :test_16, "~v:@a", [nil, nil], "nil"

  def_format_test :test_17, "~v@:a", [nil, nil], "nil"

  # Tests of the colinc parameter.

  def_format_test :test_18, "~4,3a", [nil], "nil   "

  def_format_test :test_19, "~3,3@a", [nil], "nil"

  def_format_test :test_20, "~4,4@a", [nil], "    nil"

  def_format_test :test_21, "~5,3@a", [nil], "   nil"

  def_format_test :test_22, "~5,3A", [nil], "nil   "

  def_format_test :test_23, "~7,3@a", [nil], "      nil"

  def_format_test :test_24, "~7,3A", [nil], "nil      "

  # Tests of the minpad parameter.

  def test_25
    expected = ["ABC  ", "ABC  ", "ABC  ", "ABC  ", "ABC  ", "ABC  ", "ABC  ",
      "ABC  ", "ABC  ", "ABC  ", "ABC   ", "ABC    ", "ABC     ", "ABC      ",
      "ABC       "]
    -4.upto(10){ |i| assert_equal(expected[i + 4], "~v,,2A".format(i, "ABC")) }
  end

  def_format_test :test_26, "~3,,+2A", ["ABC"], "ABC  "

  def_format_test :test_27, "~3,,0A", ["ABC"], "ABC"

  def_format_test :test_28, "~3,,-1A", ["ABC"], "ABC"

  def_format_test :test_29, "~3,,0A", ["ABCD"], "ABCD"

  def_format_test :test_30, "~3,,-1A", ["ABCD"], "ABCD"

  # Tests of the padchar parameter.

  def_format_test :test_31, "~4,,,'XA", ["AB"], "ABXX"

  def_format_test :test_32, "~4,,,a", ["AB"], "AB  "

  def_format_test :test_33, "~4,,,'X@a", ["AB"], "XXAB"

  def_format_test :test_34, "~4,,,@A", ["AB"], "  AB"

  def_format_test :test_35, "~10,,,vA", [nil, "abcde"], "abcde     "

  def_format_test :test_36, "~10,,,v@A", [nil, "abcde"], "     abcde"

  def_format_test :test_37, "~10,,,va", ['*', "abcde"], "abcde*****"

  def_format_test :test_38, "~10,,,v@a", ['*', "abcde"], "*****abcde"

  # Other tests.

  def_format_test :test_39, "~3,,vA", [nil, "ABC"], "ABC"

  def_format_test :test_40, "~4,,va", [-1, "abcd"], "abcd"

  def_format_test :test_41, "~5,vA", [nil, "abc"], "abc  "

  def_format_test :test_42, "~5,vA", [3, "abc"], "abc   "

  def_format_test :test_43, "~5,v@A", [3, "abc"], "   abc"

  # General parameter-tests.

  def_format_test :test_44, "~#A", ["abc", nil, nil, nil], "abc "

  def_format_test :test_45, '~#@a', ["abc", nil, nil, nil, nil, nil], "   abc"

  def_format_test :test_46, "~5,#a", ["abc", nil, nil, nil], "abc    "

  def_format_test :test_47, '~5,#@A', ["abc", nil, nil, nil], "    abc"

  def_format_test :test_48, "~4,#A", ["abc", nil, nil], "abc   "

  def_format_test :test_49, '~4,#@A', ["abc", nil, nil], "   abc"

  def_format_test :test_50, "~#,#A", ["abc", nil, nil, nil], "abc    "

  def_format_test :test_51, '~#,#@A', ["abc", nil, nil, nil], "    abc"

  def_format_test :test_52, "~-100A", ["xyz"], "xyz"

  def_format_test :test_53, "~-100000000000000000000a", ["xyz"], "xyz"
end
