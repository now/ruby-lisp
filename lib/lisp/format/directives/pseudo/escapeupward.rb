# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Pseudo::EscapeUpward < Lisp::Format::Directives::Directive
  directive [nil, nil, nil], ColonMod, ?^

  def initialize(params, modifiers, pos, scanner)
    super
    if colon? and (not (iter = scanner.processing? Iteration) or not iter.colon?)
      raise error('can’t use a ~~:^ outside a ~~:{…~~} construct')
    end
  end

  def execute(state, l, m, r)
    throw colon? ? :up_up_and_out : :up_and_out if should_escape(state, l, m, r)
  end

private

  def should_escape(state, l, m, r)
    l ? (m ? (r ? m.between?(l, r) : l == m) : l == 0) :
      (colon? ? state.parent.sets.left.zero? : state.args.left.zero?)
  end
end
