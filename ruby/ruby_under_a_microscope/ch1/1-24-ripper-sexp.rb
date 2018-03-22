require 'ripper'
require 'pp'

code = <<STR
2 + 2 * 3
STR

puts code
pp Ripper.sexp(code)