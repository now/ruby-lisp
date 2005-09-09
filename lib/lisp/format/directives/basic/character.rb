# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

class Lisp::Format::Directives::Basic::Character < Lisp::Format::Directives::Directive
  directive [], BothMods, ?C

  def execute(state)
    c = state.args.get(:to_int) & 0xff
    send(modcase(:simple, :spelled, :readable, :keyboard), state, c)
  end

private

  def simple(state, c)
    state.putc c
  end

  def spelled(state, c)
    if SpecialCharacters.include? c
      state.print SpecialCharacters[c][0]
    else
      state.putc c
    end
  end

  def readable(state, c)
    state.print c.inspect
  end

  def keyboard(state, c)
    spelled(state, c)
    if SpecialCharacters.include? c and SpecialCharacters[c].length > 1
      state.print " (%s)" % SpecialCharacters[c][1]
    end
  end

  SpecialCharacters = {
    0x00 => ["Nul", "^@"],
    0x01 => ["Soh", "^A"],
    0x02 => ["Stx", "^B"],
    0x03 => ["Etx", "^C"],
    0x04 => ["Eot", "^D"],
    0x05 => ["Enq", "^E"],
    0x06 => ["Ack", "^F"],
    0x07 => ["Bel", "^G"],
    0x08 => ["Backspace", "^H"],
    0x09 => ["Tab", "^I"],
    0x0A => ["Newline", "^J"],
    0x0B => ["Vt", "^K"],
    0x0C => ["Page", "^L"],
    0x0D => ["Return", "^M"],
    0x0E => ["So", "^N"],
    0x0F => ["Si", "^O"],
    0x10 => ["Dle", "^P"],
    0x11 => ["Dc1", "^Q"],
    0x12 => ["Dc2", "^R"],
    0x13 => ["Dc3", "^S"],
    0x14 => ["Dc4", "^T"],
    0x15 => ["Nak", "^U"],
    0x16 => ["Syn", "^V"],
    0x17 => ["Etb", "^W"],
    0x18 => ["Can", "^X"],
    0x19 => ["Em", "^Y"],
    0x1A => ["Sub", "^Z"],
    0x1B => ["Esc", "^["],
    0x1C => ["Fs", "^\\"],
    0x1D => ["Gs", "^]"],
    0x1E => ["Rs", "^^"],
    0x1F => ["Us", "^_"],
    0x20 => ["Space", "Sp"],
    0x7f => ["Rubout", "Del"],
    0x80 => ["C80"],
    0x81 => ["C81"],
    0x82 => ["Break-Permitted"],
    0x83 => ["No-Break-Permitted"],
    0x84 => ["C84"],
    0x85 => ["Next-Line"],
    0x86 => ["Start-Selected-Area"],
    0x87 => ["End-Selected-Area"],
    0x88 => ["Character-Tabulation-Set"],
    0x89 => ["Character-Tabulation-With-Justification"],
    0x8A => ["Line-Tabulation-Set"],
    0x8B => ["Partial-Line-Forward"],
    0x8C => ["Partial-Line-Backward"],
    0x8D => ["Reverse-Linefeed"],
    0x8E => ["Single-Shift-Two"],
    0x8F => ["Single-Shift-Three"],
    0x90 => ["Device-Control-String"],
    0x91 => ["Private-Use-One"],
    0x92 => ["Private-Use-Two"],
    0x93 => ["Set-Transmit-State"],
    0x94 => ["Cancel-Character"],
    0x95 => ["Message-Waiting"],
    0x96 => ["Start-Guarded-Area"],
    0x97 => ["End-Guarded-Area"],
    0x98 => ["Start-String"],
    0x99 => ["C99"],
    0x9A => ["Single-Character-Introducer"],
    0x9B => ["Control-Sequence-Introducer"],
    0x9C => ["String-Terminator"],
    0x9D => ["Operating-System-Command"],
    0x9E => ["Privacy-Message"],
    0x9F => ["Application-Program-Command"]
  }
end
