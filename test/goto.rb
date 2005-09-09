# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_GotoDirective < Test::Unit::TestCase
  def_format_test :test_01, "~A~*~A", [1, 2, 3], "13"

  def_format_test :test_02, "~A~0*~A", [1, 2, 3], "12"

  def_format_test :test_03, "~A~v*~A", [1, 0, 2], "12"

  def_format_test :test_04, "~A~v*~A", [1, 1, 2, 3], "13"

  def_format_test :test_05, "~A~v*~A", [1, nil, 2, 3], "13"

  def_format_test :test_06, "~A~1{~A~*~A~}~A", [0, [1, 2, 3], 4], "0134"

  def_format_test :test_07, "~A~1{~A~0*~A~}~A", [0, [1, 2, 3], 4], "0124"

  def_format_test :test_08, "~A~{~A~*~A~}~A", [0, [1, 2, 3, 4, 5, 6], 7], "013467"

  def_format_test :test_09, "~A~{~A~A~A~A~v*~^~A~A~A~A~}~A", [0, [1, 2, 3, 4, nil, 6, 7, 8, 9, 'A'], 5], "01234789A5"

  def_format_test :test_10, "~A~:*~A", [1, 2, 3], "11"

  def_format_test :test_11, "~A~A~:*~A", [1, 2, 3], "122"

  def_format_test :test_12, "~A~A~0:*~A", [1, 2, 3], "123"

  def_format_test :test_13, "~A~A~2:*~A", [1, 2, 3], "121"

  def_format_test :test_14, "~A~A~v:*~A", [1, 2, 0, 3], "123"

  def_format_test :test_15, "~A~A~v:*~A", [6, 7, 2, 3], "677"

  def_format_test :test_16, "~A~A~v:*~A", [6, 7, nil, 3], "67nil"

  def_format_test :test_17, "~A~1{~A~:*~A~}~A", [0, [1, 2, 3], 4], "0114"

  def_format_test :test_18, "~A~1{~A~A~A~:*~A~}~A", [0, [1, 2, 3, 4], 5], "012335"

  def_format_test :test_19, "~A~1{~A~A~A~2:*~A~A~}~A", [0, [1, 2, 3, 4], 5], "0123235"

  def_format_test :test_20, "~A~{~A~A~A~3:*~A~A~A~A~}~A", [0, [1, 2, 3, 4], 5], "012312345"

  def_format_test :test_21, "~A~{~A~A~A~A~4:*~^~A~A~A~A~}~A", [0, [1, 2, 3, 4], 5], "0123412345"

  def_format_test :test_22, "~A~{~A~A~A~A~v:*~^~A~}~A", [0, [1, 2, 3, 4, nil], 5], "01234nil5"

  def_format_test :test_23, "~A~A~@*~A~A", [1, 2, 3, 4], "1212"

  def_format_test :test_24, "~A~A~1@*~A~A", [1, 2, 3, 4], "1223"

  def_format_test :test_25, "~A~A~2@*~A~A", [1, 2, 3, 4], "1234"

  def_format_test :test_26, "~A~A~3@*~A~A", [1, 2, 3, 4, 5], "1245"

  def_format_test :test_27, "~A~A~v@*~A~A", [1, 2, nil, 3, 4], "1212"

  def_format_test :test_28, "~A~A~v@*~A~A", [1, 2, 1, 3, 4], "1221"

  def_format_test :test_29, "~A~A~v@*~A~A", [6, 7, 2, 3, 4], "6723"

  def_format_test :test_30, "~A~{~A~A~@*~A~A~}~A", [0, [1, 2], 9], "012129"

  def_format_test :test_31, "~A~{~A~A~0@*~A~A~}~A", [0, [1, 2], 9], "012129"

  def_format_test :test_32, "~A~1{~A~A~v@*~A~A~}~A", [0, [1, 2, nil], 9], "012129"

  def_format_test :test_33, "~A~{~A~A~1@*~A~}~A", [0, [1, 2], 9], "01229"
end
