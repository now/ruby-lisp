# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_RecursiveProcessingDirective < Test::Unit::TestCase
  def_format_test :test_01, "~?", ["", []], ""

  def_format_test :test_02, "~?", ["~A", [1]], "1"

  def_format_test :test_03, "~?", ["", [1]], ""

  def_format_test :test_04, "~? ~A", ["", [1], 2], " 2"

  def_format_test :test_05, "a~?z", ["b~?y", ["c~?x", ["~A", [1]]]], "abc1xyz"

  # Tests for at modifier.

  def_format_test :test_06, "~@?", [""], ""

  def_format_test :test_07, "~@?", ["~A", 1], "1"

  def_format_test :test_08, "~@? ~A", ["<~A>", 1, 2], "<1> 2"

  def_format_test :test_09, "a~@?z", ["b~@?y", "c~@?x", "~A", 1], "abc1xyz"

  def_format_test :test_10, "~{~A~@?~A~}", [[1, "~4*", 2, 3, 4, 5, 6]], "16"
end
