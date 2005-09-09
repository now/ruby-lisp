# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_ConditionalDirective < Test::Unit::TestCase
  def_format_test :test_01, "~[~]", [0], ""

  def_format_test :test_02, "~[a~]", [0], "a"

  def_format_test :test_03, "~[a~]", [-1], ""

  def_format_test :test_04, "~[a~]", [Fixnum::MIN - 1], ""

  def_format_test :test_05, "~[a~]", [1], ""

  def_format_test :test_06, "~[a~]", [Fixnum::MAX + 1], ""

  def test_07
    expected = ["", "a", "b", "c", "d", "e", "f", "g", "h", "i", "", ""]
    -1.upto(10) do |i|
      assert_equal(expected.shift, "~[a~;b~;c~;d~;e~;f~;g~;h~;i~]".format(i))
    end
  end

  def_format_test :test_08, "~0[a~;b~;c~;d~]", [3], "a"

  def_format_test :test_09, "~-1[a~;b~;c~;d~]", [3], ""

  def_format_test :test_10, "~1[a~;b~;c~;d~]", [3], "b"

  def_format_test :test_11, "~4[a~;b~;c~;d~]", [3], ""

  def_format_test :test_12, "~100000000000000000000000000000000[a~;b~;c~;d~]", [3], ""

  def test_13
    expected = ["", "a", "b", "c", "d", "e", "f", "g", "h", "i", "", ""]
    -1.upto(10) do |i|
      assert_equal(expected.shift, "~v[a~;b~;c~;d~;e~;f~;g~;h~;i~]".format(i, nil))
    end
  end

  def test_14
    expected = ["", "a", "b", "c", "d", "e", "f", "g", "h", "i", "", ""]
    -1.upto(10) do |i|
      assert_equal(expected.shift, "~V[a~;b~;c~;d~;e~;f~;g~;h~;i~]".format(nil, i))
    end
  end

  def_format_test :test_15, "~#[A~;B~]", [], "A"

  def_format_test :test_16, "~#[A~;B~]", [nil], "B"

  # Test default case.

  def test_17
    -100.upto(100) do |i|
      assert_equal(i.zero? ? "" : "a", "~[~:;a~]".format(i))
    end
  end

  def_format_test :test_18, "~[a~:;b~]", [0], "a"

  def_format_test :test_19, "~[a~:;b~]", [Fixnum::MIN - 1], "b"

  def_format_test :test_20, "~[a~:;b~]", [Fixnum::MAX + 1], "b"

  def test_21
    expected = ["e", "a", "b", "c", "d", "e", "e", "e", "e", "e", "e", "e"]
    -1.upto(10) do |i|
      assert_equal(expected.shift, "~[a~;b~;c~;d~:;e~]".format(i))
    end
  end

  def test_22
    expected = ["e", "a", "b", "c", "d", "e", "e", "e", "e", "e", "e", "e"]
    -1.upto(10) do |i|
      assert_equal(expected.shift, "~v[a~;b~;c~;d~:;e~]".format(i, nil))
    end
  end

  def test_23
    expected = ["e", "a", "b", "c", "d", "e", "e", "e", "e", "e", "e", "e"]
    -1.upto(10) do |i|
      assert_equal(expected.shift, "~v[a~;b~;c~;d~:;e~]".format(nil, i))
    end
  end

  def_format_test :test_24, "~#[A~:;B~]", [], "A"

  def_format_test :test_25, "~#[A~:;B~]", [nil, nil], "B"

  # Test colon modifier.

  def_format_test :test_26, "~:[a~;b~]", [nil], "a"

  def test_27
    MiniUniverse.each do |e|
      assert_equal(e ? "b" : "a", "~:[a~;b~]".format(e))
    end
  end

  # Test at modifier.

  def_format_test :test_28, "~@[X~]Y~A", [1], "XY1"

  def_format_test :test_29, "~@[X~]Y~A", [nil, 2], "Y2"
end
