# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_IgnoredNewlineDirective < Test::Unit::TestCase
  def_format_test :test_1, "~\n   X", [], "X"

  def_format_test :test_2, "A~:\n X", [], "A X"

  def_format_test :test_3, "A~@\n X", [], "A\nX"
end
