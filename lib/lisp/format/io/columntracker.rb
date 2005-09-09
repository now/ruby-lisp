# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::IO
  module ColumnTracker
    TabWidth = 8

    # TODO: track wide characters (we need Ruby support for this first)
    def print(str)
      @column ||= 0
      ri = str.rindex(?\n)
      @column = 0 if ri
      (ri or 0).upto(str.length - 1) do |i|
        @column += str[i] == ?\t ? (TabWidth - (@column % TabWidth)) : 1
      end
      target.print str
    end

    def putc(c)
      @column ||= 0
      @column = case c
                when ?\n: 0
                when ?\t: @column + (TabWidth - (@column % TabWidth))
                else      @column + 1
                end
      target.putc c
    end

    def column
      @column ||= 0
    end
  end
end
