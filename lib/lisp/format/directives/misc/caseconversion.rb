# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

require 'lisp/format/io/filteringoutput'

class Lisp::Format::Directives::Misc::CaseConversion < Lisp::Format::Directives::Directive
  directive [], BothMods, ?(

  def initialize(params, modifiers, pos, scanner)
    super
    @directives = scanner.between(self, ?))
    @directives.pop
  end

  def execute(state)
    f = modcase(Downcase, new_word_capitalizer, new_capitalizer, Upcase)
    state.with_output_to(IO::FilteringOutput.new(&f)) do
      state.execute(@directives)
    end
  end

private

  def new_capitalizer
    capitalize = true
    proc do |str|
      if capitalize
        str.downcase.sub(/\w+/){ |w| capitalize = false; w.capitalize }
      else
        str.downcase
      end
    end
  end

  def new_word_capitalizer
    capitalize = true
    proc do |str|
      if capitalize
        capitalize = str =~ /\s$/ or str !~ /\w+/
        str.gsub(/\w+/){ |w| w.capitalize }
      else
        if m = /\s/.match(str)
          capitalize = m.post_match.length.zero? or
            m.post_match =~ /\s$/ or
            m.post_match !~ /\w+/
          m.pre_match.downcase +
            m[0].downcase +
            m.post_match.gsub(/\w+/){ |w| w.capitalize }
        else
          str.downcase
        end
      end
    end
  end

  Upcase = proc { |str| str.upcase }
  Downcase = proc { |str| str.downcase }
end
