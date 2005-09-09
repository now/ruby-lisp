# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



module Kernel
  def returning(value)
    yield value
    value
  end
end

class String
  alias old_ljust ljust
  def ljust(w, padstr = ' ')
    w < 0 ? self : old_ljust(w, padstr)
  end

  alias old_rjust rjust
  def rjust(w, padstr = ' ')
    w < 0 ? self : old_rjust(w, padstr)
  end
end

def Object.add_attr_accessor(*syms)
  (class << self; self; end).class_eval{ attr_accessor(*syms) }
end

class Fixnum
  MAX = 2 ** ([42].pack('i').size * 8 - 2) - 1
  MIN = -MAX - 1
end
