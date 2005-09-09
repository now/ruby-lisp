# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>

module Lisp::Format::Directives::Basic
  # TODO: decide if this should go into every file below.
  # It makes this file cleaner, while forcing us to repeat this line five times
  # (once for every file below).  
  require 'lisp/format/directives/basic/directive'

  require 'lisp/format/directives/basic/character'
  require 'lisp/format/directives/basic/freshline'
  require 'lisp/format/directives/basic/newline'
  require 'lisp/format/directives/basic/page'
  require 'lisp/format/directives/basic/tilde'
end
