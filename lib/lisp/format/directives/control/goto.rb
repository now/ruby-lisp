# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Control::ArgJump < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN], EitherMod, ?*

  def execute(state, n)
    n = at? ? 0 : 1 if n == Fixnum::MIN
    state.args.move(colon? ? -n : n, !at?)
  end
end
