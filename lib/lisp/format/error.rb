# contents: Class used when raising errors inside the formatting code.
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>


class Lisp::Format::Error < ArgumentError
  def initialize(pos, message, *args)
    super message
    @pos, @args = pos, args
  end

  attr_accessor :pos
  attr_reader :args
end
