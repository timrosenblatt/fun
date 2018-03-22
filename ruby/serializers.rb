#!/usr/bin/env ruby -w

require 'bundler/setup'

require 'cbor'
require 'msgpack'




def inspect_cbor(value)
  puts "#{value} - #{value.to_cbor.inspect}"

  puts MessagePack.unpack(msg)
end

def inspect_msgpack(value)
  puts "#{value} - #{value.to_msgpack.inspect}"

  CBOR.decode(s)
end

inspect_cbor 'hello out there from tv land'

inspect_msgpack 'hello out there from tv land'


inspect_cbor [1, 2, 33.5, 4]
inspect_msgpack [1, 2, 33.5, 4]


inspect_cbor ({ hi: 'there', dog: 'woof' })
inspect_msgpack ({ hi: 'there', dog: 'woof' })