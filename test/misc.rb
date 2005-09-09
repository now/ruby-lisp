# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>




if $0 == __FILE__
  require 'test/unit'

  $i = 0

  class TC_FormatTest < Test::Unit::TestCase
    def self.add_test(format, args, expected)
      define_method(sprintf("test_%04i", $i).intern) do
        run_test(format, args, expected)
      end
      $i += 1
    end

    def self.add_tests(tests)
      tests.each do |format, args, expected|
        add_test(format, args, expected)
      end
    end

    add_test "foo", [], "foo"

    add_tests [
      ["~C", [?A], "A"],
      ["~C", [?\s], " "],
      ["~:C", [?A], "A"],
      ["~:C", [?\s], "Space"],
      ["~:C", [?\C-\s], "Nul"],
      # TODO: this needs updating once :@ is supported
      ["~:@C", [?\C-\s], "Nul"]
    ]

    add_tests [
      ["The answer is ~D.", [5], "The answer is 5."],
      ["The answer is ~3D.", [5], "The answer is   5."],
      ["The answer is ~3,'0D.", [5], "The answer is 005."],
      ["The answer is ~:D.", [47 ** 5], "The answer is 229,345,007."],
      ["The answer is ~@D.", [5], "The answer is +5."],
      ["~,,'.,4:d", [100000000], "1.0000.0000"]
    ]

    PI = 3.14159265

    add_tests [
      ["~$", [PI], "3.14"],
      ["~5$", [PI], "3.14159"],
      ["~v$", [3, PI], "3.142"],
      ['~#$', [PI], "3.1"]
    ]

    add_tests [
      ["~,5f", [PI], "3.14159"]
    ]

    add_tests [
      ["Look at the ~A!", ["elephant"], "Look at the elephant!"]
    ]

    add_tests [
      ["~R", [3], "three"]
    ]

    add_tests [
      ["~:[are~;is~]", [3 == 1], "are"],
      ["~:[are~;is~]", [3 == 3], "is"]
    ]

    add_tests [
      ["~D tr~:@P/~D win~:P", [7, 1], "7 tries/1 win"],
      ["~D tr~:@P/~D win~:P", [1, 0], "1 try/0 wins"],
      ["~D tr~:@P/~D win~:P", [1, 3], "1 try/3 wins"],
    ]

    add_tests [
      ["~D item~:P found.", [3], "3 items found."],
      ["~R dog~:[s are~; is~] here.", [3, 3 == 1], "three dogs are here."],
      ["Here ~[are~;is~:;are~] ~:*~R pupp~:@P.", [3], "Here are three puppies."]
    ]

    add_tests [
      ["~6,2F|~:*~6,2,1,'*F|~:*~6,2,,'?F|~:*~6F|~:*~,2F|~:*~F", [3.14159], "  3.14| 31.42|  3.14|3.1416|3.14|3.14159"],
      ["~6,2F|~:*~6,2,1,'*F|~:*~6,2,,'?F|~:*~6F|~:*~,2F|~:*~F", [-3.14159], " -3.14|-31.42| -3.14|-3.142|-3.14|-3.14159"],
      ["~6,2F|~:*~6,2,1,'*F|~:*~6,2,,'?F|~:*~6F|~:*~,2F|~:*~F", [100.0], "100.00|******|100.00| 100.0|100.00|100.0"],
      ["~6,2F|~:*~6,2,1,'*F|~:*~6,2,,'?F|~:*~6F|~:*~,2F|~:*~F", [1234.0], "1234.00|******|??????|1234.0|1234.00|1234.0"],
      ["~6,2F|~:*~6,2,1,'*F|~:*~6,2,,'?F|~:*~6F|~:*~,2F|~:*~F", [0.006], "  0.01|  0.06|  0.01| 0.006|0.01|0.006"]
    ]

    add_tests [
      ["~9,2,1,,'*E|~10,3,2,2,'?,,'$E|~
        ~9,3,2,-2'%@E|~9,2E", [3.14159] * 4, "  3.14e+0| 31.42$-01|+.003e+03|  3.14e+0"],
      ["~9,2,1,,'*E|~10,3,2,2,'?,,'$E|~
        ~9,3,2,-2'%@E|~9,2E", [-3.14159] * 4, " -3.14e+0|-31.42$-01|-.003e+03| -3.14e+0"],
      ["~9,2,1,,'*E|~10,3,2,2,'?,,'$E|~
        ~9,3,2,-2'%@E|~9,2E", [1100.0] * 4, "  1.10e+3| 11.00$+02|+.001e+06|  1.10e+3"],
      ["~9,2,1,,'*E|~10,3,2,2,'?,,'$E|~
        ~9,3,2,-2'%@E|~9,2E", [1.1E13] * 4, "*********| 11.00$+12|+.001e+16| 1.10e+13"],
      ["~9,2,1,,'*E|~10,3,2,2,'?,,'$E|~
        ~9,3,2,-2'%@E|~9,2E", [1.1E120] * 4, "*********|??????????|%%%%%%%%%|1.10e+120"],
    ]

    add_tests [
      ["~@[ print level = ~D~]~@[ print length = ~D~]", [nil, 5], " print length = 5"]
    ]

    add_tests [
      ["The winners are:~{ ~S~}.", [[:fred, :harry, :jill]], "The winners are: :fred :harry :jill."],
      ["Pairs:~{ <~S,~S>~}.", [[:a, 1, :b, 2, :c, 3]], "Pairs: <:a,1> <:b,2> <:c,3>."],
      ["Pairs:~:{ <~S,~S>~}.", [[[:a, 1], [:b, 2], [:c, 3]]], "Pairs: <:a,1> <:b,2> <:c,3>."],
      ["Pairs:~@{ <~S,~S>~}.", [:a, 1, :b, 2, :c, 3], "Pairs: <:a,1> <:b,2> <:c,3>."],
      ["Pairs:~:@{ <~S,~S>~}.", [[:a, 1], [:b, 2], [:c, 3]], "Pairs: <:a,1> <:b,2> <:c,3>."],
    ]


    add_tests [
      ["Items:~#[ none~; ~S~; ~S and ~S~
                   ~:;~@{~#[~; and~] ~S~^,~}~].", [], "Items: none."],
      ["Items:~#[ none~; ~S~; ~S and ~S~
                   ~:;~@{~#[~; and~] ~S~^,~}~].", [:foo], "Items: :foo."],
      ["Items:~#[ none~; ~S~; ~S and ~S~
                   ~:;~@{~#[~; and~] ~S~^,~}~].", [:foo, :bar], "Items: :foo and :bar."],
      ["Items:~#[ none~; ~S~; ~S and ~S~
                   ~:;~@{~#[~; and~] ~S~^,~}~].", [:foo, :bar, :baz], "Items: :foo, :bar, and :baz."],
      ["Items:~#[ none~; ~S~; ~S and ~S~
                   ~:;~@{~#[~; and~] ~S~^,~}~].", [:foo, :bar, :baz, :quux], "Items: :foo, :bar, :baz, and :quux."]
    ]

    add_tests [
      ["~:{/~A~^ ...~}", [[['hot', 'dog'], ['hamburger'], ['ice', 'cream'], ['french', 'fries']]],
        "/hot .../hamburger/ice .../french ..."],
      ["~:{/~A~:^ ...~}", [[['hot', 'dog'], ['hamburger'], ['ice', 'cream'], ['french', 'fries']]],
        "/hot .../hamburger .../ice .../french"],
      ["~:{/~A~#:^ ...~}", [[['hot', 'dog'], ['hamburger'], ['ice', 'cream'], ['french', 'fries']]],
        "/hot .../hamburger"]
    ]

    add_tests [
      ["~? ~D", ["<~A ~D>", ["Foo", 5], 7], "<Foo 5> 7"],
      ["~? ~D", ["<~A ~D>", ["Foo", 5, 14], 7], "<Foo 5> 7"],
      ["~@? ~D", ["<~A ~D>", "Foo", 5, 7], "<Foo 5> 7"],
      ["~@? ~D", ["<~A ~D>", "Foo", 5, 14, 7], "<Foo 5> 14"]
    ]

    add_tests [
      ["~@R ~(~@R~)", [14, 14], "XIV xiv"],
      ["~@(~R~) error~:P detected.", [0], "Zero errors detected."],
      ["~@(~R~) error~:P detected.", [1], "One error detected."],
      ["~@(~R~) error~:P detected.", [23], "Twenty-three errors detected."],
      ["~@(how is ~:(BOB SMITH~)?~)", [], "How is bob smith?"],
    ]

    add_tests [
      ["Done.~^ ~D warning~:P.~^ ~D error~:P.", [], "Done."],
      ["Done.~^ ~D warning~:P.~^ ~D error~:P.", [3], "Done. 3 warnings."],
      ["Done.~^ ~D warning~:P.~^ ~D error~:P.", [1, 5], "Done. 1 warning. 5 errors."],
      ["~@(~@[~R~]~^ ~A!~)", [23], "Twenty-three"],
      ["~@(~@[~R~]~^ ~A!~)", [nil, "losers"], " Losers!"],
      ["~@(~@[~R~]~^ ~A!~)", [23, "losers"], "Twenty-three losers!"]
#      ["~:{ ~@?~:^ ...~} ", [[["a"], ["b"]]], "a...b"]
    ]

  private

    def run_test(format, args, expected)
      parser = Lisp::Format::Parser.new(Lisp::Format::Lexer.new(format))
      output = StringIO.new
      state = Lisp::Format::State.new(args, output)
      catch :up_and_out do
        state.execute(parser.parse)
      end
      output.rewind
      assert_equal expected, output.read
    end
  end
end
