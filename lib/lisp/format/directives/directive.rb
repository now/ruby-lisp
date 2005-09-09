# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'forwardable'
require 'injector'

require 'lisp/format/parameters'
require 'lisp/format/modifiers'

class Lisp::Format::Directives::Directive
  extend Forwardable
  extend Injector

  needs 'lisp/format/error'

  add_attr_accessor :params, :modifiers, :symbol

  NoMods = Lisp::Format::Modifiers[false, false]
  ColonMod = Lisp::Format::Modifiers[true, false]
  AtMod = Lisp::Format::Modifiers[false, true]
  EitherMod = Lisp::Format::Modifiers[true, true, false]
  BothMods = Lisp::Format::Modifiers[true, true, true]

  def self.directive(defaults, modifiers, symbol)
    self.params = Lisp::Format::Parameters.from(defaults)
    self.modifiers = modifiers
    self.symbol = symbol
    Lisp::Format::Directives[symbol] = self
  end

  def initialize(params, modifiers, pos, _)
    @pos, self.params, self.modifiers = pos, params, modifiers
  end

  attr_reader :pos, :params

protected

  def modcase(none, colon, at, both = nil)
    both? ? both : (colon? ? colon : (at? ? at : none))
  end

  def_delegators :@modifiers, :colon?, :at?, :both?

private

  def params=(params)
    myparams = self.class.params
    #raise error("too many parameters to ~~~C directive; ~
    #            expected ~[none~:;~:*no more than ~D~]", self.class.symbol,
    #            myparams.length) if params.length > myparams.length
    if params.length > myparams.length
      raise error('too many parameters to ~~~C directive; ~
                  expected ~[none~:;~:*no more than ~D~]',
                  self.class.symbol, myparams.length)
    end
    params.each_with_index do |param, i|
      if param.is_a? Lisp::Format::Parameters::Default
        param.value = myparams[i].value(nil)
      elsif not param.is_a? myparams[i].class
        raise perror(i, "argument ~D to ~~~C directive isn’t a ~A",
                     i, self.class.symbol, myparams[i].class)
      end
    end
    @params = params.complete(myparams)
  end

  def modifiers=(modifiers)
    if (invalid = modifiers - self.class.modifiers).colon? or invalid.at?
      raise error('can’t specify~@[~* ‘:’~:[~:*~;~:* nor~]~]~
                  ~@[ ~*‘@’~] modifier~P to ~~~C directive', invalid.colon?,
                  invalid.at?, (invalid.colon? and invalid.at?) ? 2 : 1,
                  self.class.symbol)
    elsif modifiers ^ self.class.modifiers
      raise error('can’t specify both ‘:’ and ‘@’ modifiers to ~~~C directive',
                  self.class.symbol)
    end
    @modifiers = modifiers
  end

  def delegate(symbol, values, modifiers, state)
    directive = Lisp::Format::Directives[symbol]
    params = Lisp::Format::Parameters.from(values, @pos).complete(directive.params)
    state.execute([directive.new(params, modifiers, pos, nil)])
  end

  def delegate_to_d(w, state)
    state.args.unget
    delegate(?D, w >= 0 ? [w] : [], NoMods, state)
  end

  def error(format, *args)
    Error.new(@pos, format, *args)
  end

  def perror(param, format, *args)
    Error.new(@params[param].pos, format, *args)
  end
end
