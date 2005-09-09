# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Misc::Plural < Lisp::Format::Directives::Directive
  directive [], BothMods, ?P

  def execute(state)
    state.args.unget if colon?
    arg = state.args.get
    if at?
      state.print((arg.eql? 1) ? 'y' : 'ies')
    else
      state.putc ?s unless arg.eql? 1
    end
  end
end
