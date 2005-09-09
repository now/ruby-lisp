# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_CDirective < Test::Unit::TestCase
  def test_1
    StandardChars.each{ |c| assert_equal(c.chr, "~C".format(c)) }
  end

  def test_2
    StandardChars.each do |c|
      assert_equal(c.chr, "~:C".format(c)) unless c.chr !~ /[[:graph:]]/ or c == ?\s
    end
  end

  def_format_test :test_3, "~:C", [?\s], "Space"

  def test_4
    StandardChars.each{ |c| assert_equal(c, eval("~@C".format(c))) }
  end

#  def test_5
#    StandardChars.each{ |c| assert_equal("~:C".format(c), "~:@C".format(c)) }
#  end
end
