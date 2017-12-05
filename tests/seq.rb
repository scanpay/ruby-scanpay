# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require_relative '../lib/scanpay'

$apikey = '1153:YHZIUGQw6NkCIYa3mG6CWcgShnl13xuI7ODFUYuMy0j790Q6ThwBEjxfWFXwJZ0W';
scanpay = Scanpay::Client.new($apikey)
options = { 'hostname' => 'api.test.scanpay.dk' }

seqobj = scanpay.seq(0, options)

puts "After applying the changes your system will be at seq=#{seqobj['seq'].to_s}"
puts "Listing transaction changes(#{seqobj['changes'].length}) since old seq:"
seqobj['changes'].each do |trn|
  if trn['error']
    puts "    Encountered error: #{trn['error']}"
    next
  end

  puts "  Tranaction id: #{trn['id'].to_s}"
  puts "  Order id:      #{trn['orderid']}"
  puts "  Authorized:    #{trn['totals']['authorized'].to_s}"
  puts "  Captured:      #{trn['totals']['captured'].to_s}"
  puts "  Refunded:      #{trn['totals']['refunded']}\n\n"
end
