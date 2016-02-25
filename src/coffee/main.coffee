require '../stylus/main'
domready = require 'domready'
BinaryOp = require './_binary_op'
IfTest = require './_if_test'

domready ->
  binaryOp = new BinaryOp 'rAndEOp'
  ifTest = new IfTest 'ifTest'
