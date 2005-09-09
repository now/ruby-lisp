# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::IO
  class Output
    extend Forwardable

    def_delegator :@next, :column

    attr_accessor :next
  end
end
