#!/usr/bin/env ruby -w

def expect(a, b)
  unless a == b
    raise 'OH NO'
  end
end

puts 'The goal here is to write a serializer that will convert an array ' \
     'of strings into a single string.'


# Writing this as an HTML-inspired serializer, where there's an
# escape character, and will validate the use of the escape character
# in legitimate usage (ie: no failed decode). The key thing here is that
# the escape character needs its own representation in the serialized output
# in case the input string contained a legitimate usage of the escape character

class HTMLCereal
  def self.encode(input)
    input.map do |item|
      encode_item(item)
    end.join('&rec;')
  end

  def self.encode_item(input)
    input.gsub('&', '&amp;')
  end

  def self.decode(input)
    pointer = 0
    max = input.length
    result = []
    characters = input.chars
    current_record = ''
    lookahead_scope = 4 # this is the largest size of a legitimate post ampersand code, including the semicolon

    begin
      current = characters[pointer]

      if current == '&' # lookahead time!
        lookahead_buffer = ''
        lookahead_pointer = 1

        begin
          # puts "beginning the loop with lookahead buffer #{lookahead_buffer}"
          lookahead_character = characters[pointer + lookahead_pointer]

          if lookahead_character == ';' # special character termination
            if lookahead_buffer == 'amp'
              # puts "adding ampersand to #{current_record}"
              current_record += '&'
              pointer += lookahead_pointer
            elsif lookahead_buffer == 'rec'
              # puts "adding #{current_record} to final result"
              # puts "result is #{result}"
              result << current_record
              current_record = ''
              pointer += lookahead_pointer
            end
          else
            # puts "updating buffer #{lookahead_buffer} with #{lookahead_character}"
            lookahead_buffer += lookahead_character
          end

          lookahead_pointer += 1
        end while lookahead_pointer <= lookahead_scope
      else
        # puts "updating #{current_record} with #{current}"
        current_record += current
      end

      pointer += 1
    end while pointer < max

    result << current_record

    result
  end
end

puts "\n\n"


original = ["bill & ted", "bill &amp; ted", "bill &rec; ted"]
puts "original is #{original}"
enc = HTMLCereal.encode original

puts "The encoded version is:"
puts enc
puts "\n\n"

dec = HTMLCereal.decode enc

puts "The decoded version is:"
puts dec.inspect

expect(original, dec)

puts "win!"

# Another possibly simpler-to-implement version would be converting
# each character to an array of CSV bytes and then just use an ASCII
# character as the separator. That means that I can just use String#bytes
# to implement, and it doesn't require a lookahead implmenetation, just
# decoding back to UTF8
