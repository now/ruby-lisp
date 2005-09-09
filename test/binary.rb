# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'aux'

class TC_BinaryDirective < Test::Unit::TestCase
  def test_01
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      s = "~B".format(i)
      j = s.to_i(2)
      assert_equal(i, j)
      assert_no_match(/\./, s)
      assert_no_match(/\+/, s)
      assert_no_match(/[^-01]/, s)
    end
  end

  def test_02
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      s = "~@B".format(i)
      j = s.to_i(2)
      assert_equal(i, j)
      assert_no_match(/\./, s)
      assert_match(/^[+-]/, s)
      assert_no_match(/[^-+01]/, s)
    end
  end

  def test_03
    1000.times do
      x = 1 << (2 + rand(80))
      mincol = rand(30)
      i = rand(x * 2) - x
      s1 = "~B".format(i)
      s2 = "~~~DB".format(mincol).format(i)
      assert_not_nil(s2[s1])
      if mincol > s1.length and mincol != s2.length
        assert_equal(s2.length - s1.length, s2 =~ /[^[:space:]]/)
      end
    end
  end

  def test_04
    1000.times do
      x = 1 << (2 + rand(80))
      mincol = rand(30)
      i = rand(x * 2) - x
      s1 = "~@B".format(i)
      s2 = "~~~D@B".format(mincol).format(i)
      assert_not_nil(s2[s1])
      assert_equal(s1[0], ?+) if i >= 0
      if mincol > s1.length and mincol != s2.length
        assert_equal(s2.length - s1.length, s2 =~ /[^[:space:]]/)
      end
    end
  end

  def test_05
    1000.times do
      x = 1 << (2 + rand(80))
      mincol = rand(30)
      padchar = StandardChars[rand(StandardChars.length)]
      i = rand(x * 2) - x
      s1 = "~B".format(i)
      s2 = "~~~D,'~Cb".format(mincol, padchar).format(i)
      assert_not_nil(s2[s1])
      if mincol > s1.length and mincol != s2.length
        assert_not_match(/[^#{padchar}]/, s2[0, s2.length - s1.length])
      end
    end
  end

  # Tests of colon modifier.

  def test_06
    -7.upto(7){ |i| assert_equal("~b".format(i), "~:b".format(i)) }
  end

  def test_07
    commachar = ?,
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      s1 = "~b".format(i)
      s2 = "~:b".format(i)
      assert_equal(s1, s2.delete(commachar.chr))
      assert_not_equal(commachar, s2[0])
      assert_not_equal(commachar, s2[1]) if i < 0
      ((i < 0) ? 2 : 1).upto(s2.length - 1) do |i|
        if (s2.length - i) % 4 == 0
          assert_equal(commachar, s2[i])
        else
          assert("01".include?(s2[i]))
        end
      end
    end
  end

  def test_08
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      commachar = StandardChars[rand(StandardChars.length)]
      s1 = "~b".format(i)
      s2 = "~,,v:b".format(commachar.chr, i)
      assert_equal(s1[0], s2[0])
      assert_equal(s1[1], s2[1]) if i < 0
      j = (i < 0) ? 1 : 0
      ((i < 0) ? 2 : 1).upto(s2.length - 1) do |i|
        if (s2.length - i) % 4 == 0
          assert_equal(commachar, s2[i])
        else
          assert_equal(s1[j += 1], s2[i])
        end
      end
    end
  end

  def test_09
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      commachar = StandardChars[rand(StandardChars.length)]
      s1 = "~b".format(i)
      s2 = "~~,,'~c:b".format(commachar).format(i)
      assert_equal(s1[0], s2[0])
      assert_equal(s1[1], s2[1]) if i < 0
      j = (i < 0) ? 1 : 0
      ((i < 0) ? 2 : 1).upto(s2.length - 1) do |i|
        if (s2.length - i) % 4 == 0
          assert_equal(commachar, s2[i])
        else
          assert_equal(s1[j += 1], s2[i])
        end
      end
    end
  end

  def test_10
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      commachar = StandardChars[rand(StandardChars.length)]
      commaint = rand(20) + 1
      s1 = "~b".format(i)
      s2 = "~,,v,v:b".format(commachar.chr, commaint, i)
      assert_equal(s1[0], s2[0])
      assert_equal(s1[1], s2[1]) if i < 0
      commaint_succ = commaint.succ
      j = (i < 0) ? 1 : 0
      ((i < 0) ? 2 : 1).upto(s2.length - 1) do |i|
        if (s2.length - i) % commaint_succ == 0
          assert_equal(commachar, s2[i])
        else
          assert_equal(s1[j += 1], s2[i])
        end
      end
    end
  end

  def test_11
    1000.times do
      x = 1 << (2 + rand(80))
      i = rand(x * 2) - x
      commachar = StandardChars[rand(StandardChars.length)]
      commaint = rand(20) + 1
      s1 = "~@b".format(i)
      s2 = "~,,v,v:@b".format(commachar.chr, commaint, i)
      assert_equal(s1[0], s2[0])
      assert_equal(s1[1], s2[1]) if i < 0
      commaint_succ = commaint.succ
      j = 1
      2.upto(s2.length - 1) do |i|
        if (s2.length - i) % commaint_succ == 0
          assert_equal(commachar, s2[i])
        else
          assert_equal(s1[j += 1], s2[i])
        end
      end
    end
  end

  # NIL argument tests.
  
  def_format_test :test_12, "~vb", [nil, 0b110100], "110100"

  def_format_test :test_13, "~6,vb", [nil, 0b100], "   100"

  def_format_test :test_14, "~,,v:b", [nil, 0b10011], "10,011"

  def_format_test :test_15, "~,,'*,v:b", [nil, 0b10011], "10*011"

  # Tests for non-integral values.

  def test_16
    MiniUniverse.each do |e|
      assert_equal("~b".format(e), "~A".format(e)) unless e.respond_to? :to_int
    end
  end

  def test_17
    MiniUniverse.each do |e|
      assert_equal("~:b".format(e), "~A".format(e)) unless e.respond_to? :to_int
    end
  end

  def test_18
    MiniUniverse.each do |e|
      assert_equal("~@b".format(e), "~A".format(e)) unless e.respond_to? :to_int
    end
  end

  def test_18
    MiniUniverse.each do |e|
      assert_equal("~:@b".format(e), "~A".format(e)) unless e.respond_to? :to_int
    end
  end

#;;; Must add tests for non-integers when the parameters
#;;; are specified, but it's not clear what the meaning is.
#;;; Does mincol apply to the ~A equivalent?  What about padchar?
#;;; Are comma-char and comma-interval always ignored?

  # Argument tests.
  
  def test_19
    expected = ["11001", "11001", "11001", "11001", "11001", " 11001",
      "  11001", "   11001", "    11001", "     11001", "      11001"]
    0.upto(10) do |i|
      assert_equal(expected[i], '~#b'.format(0b11001, *Array.new(i)))
    end
  end

  def test_20
    expected = ["1,1,0,0,1,0,0,0,1,0", "11,00,10,00,10", "1,100,100,010",
      "11,0010,0010", "11001,00010", "1100,100010", "110,0100010",
      "11,00100010", "1,100100010", "1100100010", "1100100010"]
    0.upto(10) do |i|
      assert_equal(expected[i], '~,,,#:b'.format(0b1100100010, *Array.new(i)))
    end
  end

  def test_21
    expected = ["+1,1,0,0,1,0,0,0,1,0", "+11,00,10,00,10", "+1,100,100,010",
      "+11,0010,0010", "+11001,00010", "+1100,100010", "+110,0100010",
      "+11,00100010", "+1,100100010", "+1100100010", "+1100100010"]
    0.upto(10) do |i|
      assert_equal(expected[i], '~,,,#@:B'.format(0b1100100010, *Array.new(i)))
    end
  end

  def_format_test :test_22, "~+10b", [0b1101], "      1101"

  def_format_test :test_23, "~+10@B", [0b1101], "     +1101"

  def_format_test :test_24, "~-1b", [0b1101], "1101"

  def_format_test :test_25, "~-1000000000000000000b", [0b1101], "1101"

  def_format_test :test_26, "~vb", [(Fixnum::MIN - 1), 0b1101], "1101"

  # Randomized test.
  
  def coin
    rand(2) == 1
  end

  def test_27
    2000.times do |i|
      mincol = coin && rand(50)
      padchar = coin && StandardChars[rand(StandardChars.length)].chr
      commachar = coin && StandardChars[rand(StandardChars.length)].chr
      commaint = coin && rand(10) + 1
      k = 1 << (2 + rand(30))
      x = rand(k + k) - k
      fmt =
        (mincol ? "~~~d,".format(mincol) : "~,") +
        (padchar ? "'~c,".format(padchar[0]) : ",") +
        (commachar ? "'~c,".format(commachar[0]) : ",") +
        (commaint ? "~db".format(commaint) : "b")
      s1 = fmt.format(x)
      s2 = "~v,v,v,vb".format(mincol, padchar, commachar, commaint, x)
      assert_equal(s2, s1)
    end
  end
end
