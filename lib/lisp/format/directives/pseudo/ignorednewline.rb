# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Pseudo::IgnoredNewline < Lisp::Format::Directives::Directive
  directive [], EitherMod, ?\n

  def initialize(params, modifiers, pos, scanner)
    super
    scanner.while{ |c| c.chr =~ /\s/ } unless colon?
    scanner.ungetc ?\n if at?
  end

  def execute(state)
  end
end
