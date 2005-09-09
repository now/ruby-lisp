# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'stringio'

# TODO: require 'lisp/format/io'?
require 'lisp/format/io/output'
require 'lisp/format/io/columntracker'

class Lisp::Format::IO::BufferingOutput < Lisp::Format::IO::Output
  include Lisp::Format::IO::ColumnTracker

  def initialize
    @buffer = StringIO.new
  end

  def contents
    @buffer.rewind
    @buffer.read
  end

  def target; @buffer; end
end
