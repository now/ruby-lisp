# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

# TODO: perhaps inheriting from String is unnecessary?
class Lisp::Format::Directives::Pseudo::Literal < String
  def initialize(str)
    super
    @params = Lisp::Format::Parameters::List.new
  end

  def execute(state)
    state.print self
  end

  attr_reader :params
end
