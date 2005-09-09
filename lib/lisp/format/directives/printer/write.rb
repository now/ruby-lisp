# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Printer::Write < Lisp::Format::Directives::Directive
  directive [], BothMods, ?W

  def execute(state)
    if colon?
      require 'pp'
      out = StringIO.new
      pp(state.args.get, out)
      out.rewind
      state.print out.read
    else
      state.print state.args.get.inspect
    end
  end
end
