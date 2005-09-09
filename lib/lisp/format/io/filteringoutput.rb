# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/io/output'

class Lisp::Format::IO::FilteringOutput < Lisp::Format::IO::Output
  def initialize(&filter)
    @filter = filter
  end

  def print(str)
    @next.print @filter.call(str)
  end

  def putc(c)
    @next.putc @filter.call(c.chr)
  end
end
