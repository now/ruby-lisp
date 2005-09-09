# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Control::Indirection < Lisp::Format::Directives::Directive
  directive [], AtMod, ??

  def initialize(params, modifiers, pos, scanner)
    super
    @scanner_class = scanner.class
  end

  def execute(state)
    directives = @scanner_class.new(state.args.get(:to_str)).rest
    state = state.dup_with_args(state.args.get(:to_ary)) unless at?
    catch(:up_and_out){ state.execute(directives) }
  end
end
