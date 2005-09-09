# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Control::ConditionalExpression < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN], EitherMod, ?[

  def initialize(params, modifiers, pos, scanner)
    super
    if (colon? or at?) and @params[0].value(nil) != Fixnum::MIN
      raise perror(0, 'no parameters allowed together with ‘:’ or ‘@’ modifiers')
    end
    @default = -1
    @clauses = []
    clause = []
    scanner.with(self) do |directive|
      case directive
      when Lisp::Format::Directives[?]]
        @clauses << clause
        break
      when Lisp::Format::Directives[?;]
        if @default != -1
          raise error('a ~~:; clause may not be followed by more clauses')
        end
        @clauses << clause
        clause = []
        if directive.colon?
          @default = @clauses.size
        end
      else
        clause << directive
      end
    end
    if colon? and @clauses.size != 2
      raise error('must specify exactly two clauses with ‘:’ modifier')
    end
    if at? and @clauses.size != 1
      raise error('only one clause allowed with ‘@’ modifier')
    end
  end

  def execute(state, n)
    if colon?
      c = state.args.get ? 1 : 0
    elsif at?
      return unless state.args.get
      state.args.unget
      c = 0
    else
      if n == Fixnum::MIN
        arg = state.args.get
        n = arg.respond_to?(:to_int) ? arg.to_int : @clauses.size
      end
      if n >= 0 and n < @clauses.size
        c = n
      elsif @default != -1
        c = @default
      else
        return
      end
    end
    state.execute(@clauses[c])
  end
end
