# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_LogicalBlockDirective < Test::Unit::TestCase
  def_format_test :test_01, "~<prefix~;~A~;suffix~>", [[1, 2, 3]], "prefix1suffix"

  def_format_test :test_02, "~@<prefix~;~A~;suffix~>", [1, 2, 3], "prefix1suffix"

  def_format_test :test_03, "~<prefix~@;~@{~A~%~}~;suffix~:>", [[1, 2, 3]], "prefix1\nprefix2\nprefix3\nsuffix"
end
