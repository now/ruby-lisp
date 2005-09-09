# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_IterationDirective < Test::Unit::TestCase
  def_format_test :test_01, "~{~\n~}", [[]], ""

  def_format_test :test_02, "~{~}", ["", []], ""

  def_format_test :test_03, "~0{~}", ["", [1, 2, 3]], ""

  def_format_test :test_04, "~{ ~}", [[]], ""

  def_format_test :test_05, "~{X Y Z~}", [[]], ""

  def_format_test :test_06, "~{~A~}", [[1, 2, 3, 4]], "1234"

  def_format_test :test_07, "~{~{~A~}~}", [[[1, 2, 3], [4, 5], [6, 7, 8]]], "12345678"

  def_format_test :test_08, "~{~1{~A~}~}", [[[1, 2, 3], [4, 5], [6, 7, 8]]], "146"

  def_format_test :test_09, "~1{~\n~}", [[]], ""

  def test_10
    0.upto(10) do |i|
      assert_equal("1234567890"[0, i],
                   "~v{~A~}".format(i, [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]))
    end
  end

  def_format_test :test_11, '~#{~A~}', [[1, 2, 3, 4, 5, 6, 7], nil, nil, nil], "1234"

  def_format_test :test_12, "~0{~}", ["~A", [1, 2, 3]], ""

  def_format_test :test_13, "~1{~}", ["~A", [4, 5, 6]], "4"

  def_format_test :test_14, "~V{~}", [2, "~A", [1, 2, 3, 4, 5]], "12"

  def_format_test :test_15, '~#{~}', ["~A", [1, 2, 3, 4, 5]], "12"

  def_format_test :test_16, "~{FOO~:}", [[]], "FOO"

  def_format_test :test_17, "~{~A~:}", [[1]], "1"

  def_format_test :test_18, "~{~A~:}", [[1, 2]], "12"

  def_format_test :test_19, "~{~A~:}", [[1, 2, 3]], "123"

  def_format_test :test_20, "~0{FOO~:}", [nil], ""

  def_format_test :test_21, "~V{FOO~:}", [0, nil], ""

  def_format_test :test_22, "~1{FOO~:}", [[]], "FOO"

  def_format_test :test_23, "~2{FOO~:}", [[]], "FOO"

  def_format_test :test_24, "~2{~\n~:}", [[]], ""

  def_format_test :test_25, "~2{FOO~}", [[]], ""

  def_format_test :test_26, "~v{~a~}", [nil, [1, 2, 3, 4, 5, 6, 7]], "1234567"

  # ~:{ ... ~}

  def_format_test :test_27, "~:{(~A ~A)~}", [[[1, 2, 3], [4, 5], [6, 7, 8]]], "(1 2)(4 5)(6 7)"

  def_format_test :test_28, "~:{~\n~}", [[]], ""

  def_format_test :test_29, "~:{~}", ["", []], ""

  def_format_test :test_30, "~:{~}", ["~A", []], ""

  def_format_test :test_31, "~:{~}", ["X", [[], [1, 2], [3]]], "XXX"

  def_format_test :test_32, "~0:{XYZ~}", [[[1]]], ""
	  
  def_format_test :test_33, "~2:{XYZ~}", [[[1]]], "XYZ"
	  
  def_format_test :test_34, "~2:{~A~}", [[[1], [2]]], "12"
	  
  def_format_test :test_35, "~2:{~A~}", [[[1, :X], [2, :Y], [3, :Z]]], "12"

  def test_36
    expected = ["", "1", "12", "123", "1234", "12345", "123456", "123456",
      "123456", "123456", "123456"]
    0.upto 10 do |i|
      assert_equal(expected.shift,
                   "~v:{~A~}".format(i, [[1], [2], [3, :X], [4, :Y, :Z], [5], [6]]))
    end
  end

  def_format_test :test_37, "~V:{X~}", [nil, [[1], [2], [3], [], [5]]], "XXXXX"

  def_format_test :test_38, "~#:{~A~}", [[[1], [2], [3], [4], [5]], :foo, :bar], "123"

  def_format_test :test_39, "~:{~A~:}", [[[1, :X], [2, :Y], [3], [4, :A, :B]]], "1234"

  def test_40
    expected = ["", "1", "12", "123", "1234", "1234", "1234", "1234", "1234",
      "1234", "1234"]
    0.upto 10 do |i|
      assert_equal(expected.shift,
                   "~v:{~A~:}".format(i, [[1, :X], [2, :Y], [3], [4, :A, :B]]))
    end
  end

  def_format_test :test_41, "~:{ABC~:}", [[[]]], "ABC"

  def_format_test :test_42, "~v:{ABC~:}", [nil, [[]]], "ABC"

  # Tests of ~@{ ... ~}

  def_format_test :test_43, "~@{~\n~}", [], ""

  def_format_test :test_44, "~@{~}", [""], ""

  def_format_test :test_45, "~@{ ~}", [], ""

  def_format_test :test_46, "~@{X ~A Y Z~}", [nil], "X nil Y Z"

  def_format_test :test_47, "~@{~A~}", [1, 2, 3, 4], "1234"

  def_format_test :test_48, "~@{~{~A~}~}", [[1, 2, 3], [4, 5], [6, 7, 8]], "12345678"

  def_format_test :test_49, "~@{~1{~A~}~}", [[1, 2, 3], [4, 5], [6, 7, 8]], "146"

  def_format_test :test_50, "~1@{FOO~}", [], ""

  def_format_test :test_51, "~v@{~A~}", [nil, 1, 4, 7], "147"

  def_format_test :test_52, '~#@{~A~}', [1, 2, 3], "123"

  def test_53
    expected = ["", "1", "12", "123", "1234", "12345", "123456", "1234567",
      "12345678", "123456789", "12345678910"]
    x = []
    0.upto 10 do |i|
      assert_equal(expected.shift, "~v@{~A~}".format(i, *x))
      x << i + 1
    end
  end

  def_format_test :test_54, "~@{X~:}", [], "X"

  # ~:@{

  def_format_test :test_55, "~:@{~\n~}", [[]], ""

  def_format_test :test_56, "~:@{~A~}", [[1, 2], [3], [4, 5, 6]], "134"

  def_format_test :test_57, "~:@{[~A ~A]~}", [[1, 2, 4], [3, 7], [4, 5, 6]], "[1 2][3 7][4 5]"

  def_format_test :test_58, "~:@{~}", ["[~A ~A]", [1, 2, 4], [3, 7], [4, 5, 6]], "[1 2][3 7][4 5]"

  def_format_test :test_59, "~:@{~A~:}", [[1, :A], [2, :B], [3], [4, :C, :D]], "1234"

  def_format_test :test_60, "~0:@{~A~:}", [[1, :A], [2, :B], [3], [4, :C, :D]], ""

  def_format_test :test_61, '~#:@{A~:}', [[], [], []], "AAA"

  def_format_test :test_62, "~v:@{~A~}", [nil, [1], [2], [3]], "123"

  def test_63
    expected = ["", "1", "12", "123", "1234", "12345", "123456", "1234567",
      "12345678", "123456789", "12345678910"]
    x = []
    0.upto 10 do |i|
      assert_equal(expected.shift, "~V:@{~A~}".format(i, *x))
      x << [i + 1]
    end
  end

  # Error tests
  
  def_format_error_test :test_64, "~{~A~}", :A

  def_format_error_test :test_65, "~{~A~}", 1

  def_format_error_test :test_66, "~{~A~}", "foo"

  def_format_error_test :test_67, "~{~A~}", {}

  def_format_error_test :test_68, "~:{~A~}", [1]

  def_format_error_test :test_69, "~:{~A~}", :x

  def_format_error_test :test_70, "~:{~A~}", ["X"]

  def_format_error_test :test_71, "~:@{~A~}", :x

  def_format_error_test :test_72, "~:@{~A~}", 0

  def_format_error_test :test_73, "~:@{~A~}", "abc"
end
