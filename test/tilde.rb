# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_TildeDirective < Test::Unit::TestCase
  def_format_test :test_1, "~~", [], "~"

  def_range_test2 :test_2, 0..100, "~", "~~~D~~"

  def_format_test :test_3, "~v~", [0], ""

  def_range_test :test_4, 0..100, "~", "~V~"

  def_range_args_test :test_5, 0..100, "~", "~#~"
end
