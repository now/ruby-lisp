# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Modifiers::Modifier
  def self.modifier(colon, at, both = false)
    (class << self; self; end).class_eval do
      define_method(:colon?){ colon }
      define_method(:at?){ at }
      define_method(:both?){ both }
      define_method(:-) do |rhs|
        Lisp::Format::Modifiers[colon? & !rhs.colon?, at? & !rhs.at?]
      end
      define_method(:|) do |rhs|
        Lisp::Format::Modifiers[colon? | rhs.colon?, at? | rhs.at?]
      end
      define_method(:&) do |rhs|
        Lisp::Format::Modifiers[colon? & rhs.colon?, at? & rhs.at?]
      end
      define_method(:^){ |rhs| both? & rhs.either? }
      define_method(:either?){ colon? & at? & !both? }
      protected :either?
    end
    private_class_method :new, :allocate
    Lisp::Format::Modifiers[colon, at, both] = self
  end
end
