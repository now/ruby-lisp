# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'forwardable'

class Lisp::Format::Parameters::List
  include Enumerable
  extend Forwardable

  def initialize(params = [])
    @params = params
  end

  def values(state)
    @params.inject([]){ |vs, p| vs << p.value(state) }
  end

  def complete(defaults)
    (@params.length + 1).upto(defaults.length){ |i| @params << defaults[i - 1] }
    self
  end

  def_delegators :@params, :each, :length, :<<, :[]
end
