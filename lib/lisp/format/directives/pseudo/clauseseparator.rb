# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Pseudo::ClauseSeparator < Lisp::Format::Directives::Directive
  directive [0, 72], EitherMod, ?;

  def initialize(params, modifiers, pos, scanner)
    super
    unless scanner.processing? Lisp::Format::Directives[?[] or
           scanner.processing? Lisp::Format::Directives[?<]
      raise error('~~; directive not contained within a conditional (~~[…~~]) ~
                  or a justification (~~<…~~>)')
    end
    if at? and scanner.processing? Lisp::Format::Directives[?[]
      raise error('‘@’ modifier not allowed for ~~; directive within a ~
                  conditional (~~[…~~])')
    end
    # TODO: test so that the params may only be given to JustificationOrBlock
  end

  def n(state)
    @params[0].value(state)
  end

  def line_length(state)
    @params[1].value(state)
  end
end
