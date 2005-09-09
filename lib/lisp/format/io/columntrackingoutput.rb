# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/io/output'
require 'lisp/format/io/columntracker'

class Lisp::Format::IO::ColumnTrackingOutput < Lisp::Format::IO::Output
  include Lisp::Format::IO::ColumnTracker

  def target; @next; end
end
