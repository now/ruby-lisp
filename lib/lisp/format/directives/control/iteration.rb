# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Control::Iteration < Lisp::Format::Directives::Directive
  directive [Fixnum::MIN], BothMods, ?{

  def initialize(params, modifiers, pos, scanner)
    super
    @directives = scanner.between(self, ?})
    @run_atleast_once = @directives.last.colon?
    @directives.pop
    @scanner_class = scanner.class
  end

  def execute(state, n)
    return if n.zero?
    directives = @directives.length.zero? ?
      @scanner_class.new(state.args.get(:to_str)).rest :
      @directives
    send(colon? ? :execute_sets : :execute_args, state, n, directives)
  end

private

  def execute_sets(state, n, directives)
    if at?
      n = state.args.left if n == Fixnum::MIN
      sets = Array.new([state.args.left, n].min){ state.args.get(:to_ary) }
    else
      sets = state.args.get(:to_ary)
      sets = sets[0...n] unless n == Fixnum::MIN
      sets = sets.map do |set|
        unless set.respond_to? :to_ary
          raise error('argument doesn’t respond to :to_ary')
        end
        set.to_ary
      end
    end
    catch :up_up_and_out do
      state.with_sets(sets) do |set|
        catch(:up_and_out){ state.dup_with_args(set).execute(directives) }
      end
    end
  end

  def execute_args(state, n, directives)
    state = state.dup_with_args(state.args.get(:to_ary)) unless at?
    n = state.args.left if n == Fixnum::MIN
    catch :up_and_out do
      if state.args.left.zero? and @run_atleast_once
        state.execute(directives)
      else
        until state.args.left.zero? or n.zero?
          state.execute(directives)
          n -= 1
        end
      end
    end
  end
end
