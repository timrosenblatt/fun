# require 'ruby-pcap'
#
# file = File.read('pcap.4-2018/net.cap')
#
# # first step is to strip the magic number, since we know it's 4 bytes
# stripped_file = file[4..-1]
#
#
#
# file[0..10].each do |byte|
#   puts byte.unpack('H*')
# end
#
#
# def hex_inspect(data)
#   data[0..10].each do |byte|
#     puts byte.unpack('H*')
#   end
# end
#
# stripped_file[0..10].each do |byte|
#   puts byte.unpack('H*')
# end
#
#
# header = stripped_file[0..63]
#
# snapshot_length = header[17..20]
#
# # puts snapshot_length.length
#
#
# hex_inspect(snapshot_length)
#
# # because it's little endian, we have to reverse it
# snapshot_length.reverse!
#
# # puts snapshot_length
#
#
# hex_inspect(snapshot_length)
#
# puts snapshot_length.to_i
#
#

require 'rubygems'

# https://github.com/pcaprub/pcaprub/blob/master/USAGE.rdoc
require 'pcaprub'
require 'pry'

capture = ::Pcap.open_offline('pcap.4-2018/net.cap')

# capture.each do |packet|
#
#
#   puts packet.length
#
# end

ETHER_TYPE_IPV4 = [8, 0]

def hex_inspect(data)
  data.map { |byte| byte.to_s(16).rjust(2, '0') }.join ' '
end

def bin_inspect(byte)
  byte.ord.to_s(2).rjust(8, '0')
end

def format_mac(mac_bytes)
  mac_bytes.map do |byte|
    byte.to_s(16).rjust(2, '0')
  end.join(':').upcase
end

def left4(byte)
  byte.ord >> 4
end

def right4(byte)
  byte.ord & 240 # is 1111000 this should get me the left 4 bits
end

capture_data = ''
packet_number = 0

capture.each_packet do |packet|
  # At this point, the PCAP header has been stripped off, and the data
  # from each captured packet represents an ethernet frame.

  # puts packet.class
  puts Time.at(packet.time)
  puts "micro => #{packet.microsec}"
  puts "Packet Length => #{packet.length}"
  # p packet.data

  puts "packet #{packet_number}"
  packet_number += 1

  destination_mac = packet.data[0, 6].bytes
  sender_mac = packet.data[6, 6].bytes
  ether_type = packet.data[12, 2].bytes

  puts "destination mac address is #{format_mac destination_mac}"
  puts "sender mac address is #{format_mac sender_mac}"
  puts "the ether type is #{hex_inspect ether_type}"
  ethernet_payload = packet.data[14...-4]

  puts "the contents are: #{hex_inspect ethernet_payload.bytes}"
  puts "\n"

  if ether_type == ETHER_TYPE_IPV4
    # At this point we've opened the ethernet frame and we know that
    # the frame is of the IP v4 format
    # https://www.tutorialspoint.com/ipv4/ipv4_packet_structure.htm

    # Now to open the ethernet frame payload and get the IP packet
    # The first four bits are the Version, second 4 are IHL
    version = left4(ethernet_payload[0,1])
    ihl = right4(ethernet_payload[0,1])

    puts bin_inspect(ethernet_payload[0,1])
    puts bin_inspect(version)
    puts bin_inspect(ihl)


  else
    puts 'no'
  end



end
