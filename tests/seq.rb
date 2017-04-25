require_relative '../lib/scanpay'

client = Scanpay::Client.new(' API KEY ')
seqobj = client.seq(3)

puts "After applying the changes your system will be at seq=#{seqobj['seq'].to_s}"
puts "Listing transaction changes(#{seqobj['changes'].length}) since old seq:"
seqobj['changes'].each do |trn|
  puts "  Tranaction id: #{trn['id'].to_s}"
  if trn['error']
    puts "    Encountered error: #{trn['error']}"
    next
  end
  puts "  Order id:      #{trn['orderid']}"
  puts "  Authorized:    #{trn['totals']['authorized'].to_s}"
  puts "  Captured:      #{trn['totals']['captured'].to_s}"
  puts "  Refunded:      #{trn['totals']['refunded']}\n\n"
end
