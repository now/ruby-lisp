# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_FixedFormatFloatingPointDirective < Test::Unit::TestCase
  def_format_test :test_01, "~f", [0.0], "0.0"

  def test_02
    1000.times do
      x = 10.0 ** ((rand() * 10) - 3)
      assert_equal(x.to_s, "~f".format(x)) if x.between?(1/1000, 10000000)
    end
  end

  def test_03
    1000.times do
      x = -(10.0 ** ((rand() * 10) - 3))
      assert_equal(x.to_s, "~f".format(x)) if x.between?(-1/1000, -10000000)
    end
  end

  def_format_test :test_04, "~3f", [1], "1.0"

  def_format_test :test_04a, "~3f", [1.0], "1.0"

  def_format_test :test_05, "~2f", [1], "1."

  def_format_test :test_05a, "~2f", [1.0], "1."

  def_format_test :test_06, "~1f", [1], "1"

  def_format_test :test_06a, "~1f", [1.0], "1"

  def_format_test :test_07, "~4f", [1], " 1.0"

  def_format_test :test_07a, "~4f", [1.0], " 1.0"

  def_format_test :test_08, "~4@f", [1], "+1.0"

  def_format_test :test_08a, "~4@f", [1.0], "+1.0"

  def_format_test :test_09, "~3@f", [1], "+1."

  def_format_test :test_09a, "~3@f", [1.0], "+1."

  def_format_test :test_10, "~2@f", [1], "+1"

  def_format_test :test_10a, "~2@f", [1.0], "+1"

  def_format_test :test_11, "~4@f", [-1], "-1.0"

  def_format_test :test_11a, "~4@f", [-1.0], "-1.0"

  def_format_test :test_12, "~3f", [0.5], "0.5"

  def_format_test :test_13, "~4f", [0.5], " 0.5"

  def_format_test :test_14, "~4,2F", [0.5], "0.50"

  def_format_test :test_15, "~3,2F", [0.5], ".50"

  def_format_test :test_16, "~2,1f", [0.5], ".5"

  def_format_test :test_17, "~4,2@F", [0.5], "+.50"

  def_format_test :test_18, "~2,2F", [0.5], ".50"

  def_format_test :test_19, "~,2F", [0.5], "0.50"

  def_format_test :test_20, "~,2F", [-0.5], "-0.50"

  def_format_test :test_21, "~4,2,-1F", [5.0], "0.50"

  def_format_test :test_22, "~4,2,0F", [0.5], "0.50"

  def_format_test :test_23, "~4,2,1f", [0.05], "0.50"

  # Overflow
  
  def_format_test :test_24, "~5,1,,'*F", [1000.0], "*****"

  def_format_test :test_25, "~5,1,,'*F", [100.0], "100.0"

  def_format_test :test_26, "~4,0,,'*F", [100.0], "100."

  def_format_test :test_27, "~1,1,,F", [100.0], "100.0"

  # Padchar

  def_format_test :test_28, "~10,1,,f", [100.0], "     100.0"

  def_format_test :test_29, "~10,1,,,'*f", [100.0], "*****100.0"

  # v Parameters

  def test_30
    100.times do
      x = rand() * 100
      assert_equal("~f".format(x), "~vf".format(nil, x))
    end
  end

  def test_31
    100.times do
      x = rand() * 100
      assert_equal("~f".format(x), "~,vf".format(nil, x))
    end
  end

  def test_32
    100.times do
      x = rand() * 100
      assert_equal("~f".format(x), "~,,vf".format(nil, x))
    end
  end

  def test_33
    100.times do
      x = rand() * 100
      assert_equal("~f".format(x), "~,,,vf".format(nil, x))
    end
  end

  def test_34
    100.times do
      x = rand() * 100
      assert_equal("~f".format(x), "~,,,,vf".format(nil, x))
    end
  end

  # Randomized tests

  def test_35
    (1 - (1 << 13)).upto(1 << 13) do |i|
      assert_equal(i, "~f".format(i.to_f).to_f.floor) unless i.zero?
    end
  end

  def test_36
    2000.times do
      i = rand((1 << 25) - 1) - -1 - (1 << 24)
      assert_equal(i, "~f".format(i.to_f).to_f.floor) unless i.zero?
    end
  end

  def test_37
    (1 - (1 << 13)).upto(1 << 13) do |i|
      next if i.zero?
      5.times do
        assert_equal(i, "~v,vf".format(rand(8), rand(4), i.to_f).to_f.floor)
      end
    end
  end

  def test_38
    2000.times do
      i = rand((1 << 25) - 1) - -1 - (1 << 24)
      w = coin && rand(30)
      d = rand(6)
      assert_equal(i, "~v,vf".format(w, d, i.to_f).to_f.floor)
    end
  end

  def test_39
    2000.times do
      k = coin && rand(6)
      x = rand() * ((32 * ((1 << 13) - 1)) / (k ? 10 ** k : 1))
      w = coin && rand(30)
      d = coin && rand(10)
      overflowchar = coin && StandardChars[rand(StandardChars.length)].chr
      padchar = coin && StandardChars[rand(StandardChars.length)].chr
      fmt = "~" +
        (w ? "~d,".format(w) : ",") +
        (d ? "~d,".format(d) : ",") +
        (k ? "~d,".format(k) : ",") +
        (overflowchar ? "'~c,".format(overflowchar[0]) : ",") +
        (padchar ? "'~cF".format(padchar[0]) : "F")
      s1 = fmt.format(x)
      s2 = "~v,v,v,v,vf".format(w, d, k, overflowchar, padchar, x)
      assert_equal(s1, s2)
    end
  end

  def_format_test :test_40, "~,,,,',f", [0.0], "0.0"

  def test_41
    0.upto 255 do |c|
      x = 2312.9817
      assert_equal("~~,,,,'~cf".format(c).format(x), "~,,,,vf".format(c.chr, x))
    end
  end
end
