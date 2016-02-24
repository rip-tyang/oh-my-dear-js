require '../stylus/main'
domready = require 'domready'
BinaryOp = require './_binary_op'

domready ->
  binaryOp = new BinaryOp 'rAndEOp'
