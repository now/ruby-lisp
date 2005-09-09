# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_JustificationDirective < Test::Unit::TestCase
  def_format_test :test_01, "~<~>", [], ""

  def test_02
    1.upto 20 do |i|
      xs = "x" * i
      assert_equal(xs, "~<~A~>".format(xs))
    end
  end

  def test_03
    1.upto 20 do |i|
      xs = "x" * i
      assert_equal(xs + xs, "~<~A~;~A~>".format(xs, xs))
    end
  end

  def test_04
    1.upto 20 do |i|
      xs = "x" * i
      assert_equal(xs + " " + xs, "~,,1<~A~;~A~>".format(xs, xs))
    end
  end

  def test_05
    1.upto 20 do |i|
      xs = "x" * i
      assert_equal(xs + "," + xs, "~,,1,',<~A~;~A~>".format(xs, xs))
    end
  end

  def test_06
    1.upto 20 do |i|
      xs = "x" * i
      assert_equal(xs + "  " + xs, "~,,2,<~A~;~A~>".format(xs, xs))
    end
  end

  def test_07
    100.times do
      mincol = rand(50)
      len = rand(50)
      xs = "x" * len
      expected = len < mincol ? " " * (mincol - len) + xs : xs
      assert_equal(expected, "~v<~A~>".format(mincol, xs))
    end
  end

  def test_08
    100.times do
      mincol = rand(50)
      minpad = rand(10)
      len = rand(50)
      xs = "x" * len
      expected = len < mincol ? " " * (mincol - len) + xs : xs
      assert_equal(expected, "~v,,v<~A~>".format(mincol, minpad, xs))
    end
  end

  def test_09
    100.times do
      mincol = rand(50)
      padchar = StandardChars[rand(StandardChars.length)].chr
      len = rand(50)
      xs = "x" * len
      expected = len < mincol ? padchar * (mincol - len) + xs : xs
      assert_equal(expected, "~v,,,v<~A~>".format(mincol, padchar, xs))
    end
  end

  def test_10
    500.times do
      mincol = rand(50)
      padchar = StandardChars[rand(StandardChars.length)].chr
      len = rand(50)
      xs = "x" * len
      expected = len < mincol ? padchar * (mincol - len) + xs : xs
      assert_equal(expected, "~~~d,,,'~c<~~A~~>".format(mincol, padchar[0]).format(xs))
    end
  end

  def test_11
    10.times do
      i = rand(20) + 1
      colinc = rand(10) + 1
      xs = "x" * i
      expected_len = colinc * (i / colinc.to_f).ceil
      expected = " " * (expected_len - i) + xs
      assert_equal(expected, "~,v<~A~>".format(colinc, xs))
    end
  end

  def_format_test :test_12, "~<XXXXXX~^~>", [], ""

  def_format_test :test_13, "~<XXXXXX~;YYYYYYY~^~>", [], "XXXXXX"

  def_format_test :test_13a, "~<~<XXXXXX~;YYYYYYY~^~>~>", [], "XXXXXX"

  def_format_test :test_14, "~<XXXXXX~;YYYYYYY~^~;ZZZZZ~>", [], "XXXXXX"

  def_format_test :test_15, "~13,,2<aaa~;bbb~;ccc~>", [], "aaa  bbb  ccc"

  def_format_test :test_16, "~10@<abcdef~>", [], "abcdef    "

  def_format_test :test_17, "~10:@<abcdef~>", [], "  abcdef  "

  def_format_test :test_18, "~10:<abcdef~>", [], "    abcdef"

  def_format_test :test_19, "~4@<~>", [], "    "

  def_format_test :test_20, "~5:@<~>", [], "     "

  def_format_test :test_21, "~6:<~>", [], "      "

  def_format_test :test_22, "~v<~A~>", [nil, "XYZ"], "XYZ"

  def_format_test :test_23, "~,v<~A~;~A~>", [nil, "ABC", "DEF"], "ABCDEF"

  def_format_test :test_24, "~,,v<~A~;~A~>", [nil, "ABC", "DEF"], "ABCDEF"

  def_format_test :test_25, "~,,1,v<~A~;~A~>", [nil, "ABC", "DEF"], "ABC DEF"

  def_format_test :test_26, "~,,1,v<~A~;~A~>", [',', "ABC", "DEF"], "ABC,DEF"

  def_format_test :test_27, "~6<abc~;def~^~>", [], "   abc"

  def_format_test :test_28, "~6@<abc~;def~^~>", [], "abc   "

  # ~:; tests

  def_format_test :test_29, "~%X ~,,1<~%X ~:;AAA~;BBB~;CCC~>", [], "\nX AAA BBB CCC"

  def_format_test :test_30, "~%X ~<~%X ~0,3:;AAA~>~<~%X ~0,3:;BBB~>~<~%X ~0,3:;CCC~>", [], "\nX \nX AAA\nX BBB\nX CCC"

  def_format_test :test_31, "~%X ~<~%X ~0,30:;AAA~>~<~%X ~0,30:;BBB~>~<~%X ~0,30:;CCC~>", [], "\nX AAABBBCCC"

  def_format_test :test_32, "~%X ~<~%X ~0,3:;AAA~>,~<~%X ~0,3:;BBB~>,~<~%X ~0,3:;CCC~>", [], "\nX \nX AAA,\nX BBB,\nX CCC"

#;;; Error cases
#
#;;; See 22.3.5.2
#
#;;; Interaction with ~W
#
#(deftest format.justify.error.w.1
#  (signals-error-always (format nil "~< ~W ~>" nil) error)
#  t t)
#
#(deftest format.justify.error.w.2
#  (signals-error-always (format nil "~<X~:;Y~>~W" nil) error)
#  t t)
#
#(deftest format.justify.error.w.3
#  (signals-error-always (format nil "~w~<X~:;Y~>" nil) error)
#  t t)
#
#;;; Interaction with ~_
#
#(deftest format.justify.error._.1
#  (signals-error-always (format nil "~< ~_ ~>") error)
#  t t)
#
#(deftest format.justify.error._.2
#  (signals-error-always (format nil "~<X~:;Y~>~_") error)
#  t t)
#
#(deftest format.justify.error._.3
#  (signals-error-always (format nil "~_~<X~:;Y~>") error)
#  t t)
#
#;;; Interaction with ~I
#
#(deftest format.justify.error.i.1
#  (signals-error-always (format nil "~< ~i ~>") error)
#  t t)
#
#(deftest format.justify.error.i.2
#  (signals-error-always (format nil "~<X~:;Y~>~I") error)
#  t t)
#
#(deftest format.justify.error.i.3
#  (signals-error-always (format nil "~i~<X~:;Y~>") error)
#  t t)
end
