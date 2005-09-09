# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



module Lisp
  module Format
    require 'lisp/format/evilmodifications'
    require 'lisp/format/error'
    require 'lisp/format/scanner'
    require 'lisp/format/state'
  end

  def self.format(output, format, *args)
    directives = Format::Scanner.new(format).rest
    catch(:up_and_out){ Format::State.new(args, output).execute(directives) }
  rescue => e
    # TODO: perhaps have an InternalFormatError and then an external
    # FormatError?
    if e.respond_to? :pos and e.respond_to? :args
      raise e.class.new(e.pos,
                        "~?~%    ~A~%    ~v@T^".format(e.message, e.args,
                                                       format, e.pos - 1))
    else
      raise
    end
  end
end

class IO
  def format(format, *args)
    Lisp.format(self, format, *args)
  end
end

module Kernel
  def format(format, *args)
    Lisp.format($stdout, format, *args)
  end
end

class String
  def format(*args)
    output = StringIO.new
    Lisp.format(output, self, *args)
    output.rewind
    output.read
  end

  # TODO: is this nice?
  def /(args)
    args.respond_to?(:to_ary) ? self.format(*args.to_ary) : self.format(args)
  end
end
