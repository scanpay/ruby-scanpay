# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require_relative '../lib/scanpay'

$apikey = '1153:YHZIUGQw6NkCIYa3mG6CWcgShnl13xuI7ODFUYuMy0j790Q6ThwBEjxfWFXwJZ0W';
scanpay = Scanpay::Client.new($apikey)
options = { 'hostname' => 'api.test.scanpay.dk' }

myseq = 55
puts "Before applying changes your system is at seq=#{myseq.to_s}"
loop do
  seqobj = scanpay.seq(myseq, options)
  seqobj['changes'].each do |change|
    if change['error']
      puts "  Encountered error at #{change['id']}: #{change['error']}"
      next
    end
    puts change['type'].capitalize
    case change['type']
    when 'transaction', 'charge'
      puts "  Transaction id: #{change['id']}"
      puts "  Order id:       #{change['orderid']}"
      if change['type'] == 'charge'
        puts "  Subscriber id:  #{change['subscriber']['id']}"
        puts "  Subscriber ref: #{change['subscriber']['ref']}"
      end
      puts "  Authorized:     #{change['totals']['authorized'].to_s}"
      puts "  Captured:       #{change['totals']['captured'].to_s}"
      puts "  Refunded:       #{change['totals']['refunded']}"
      puts "  Payid time:     #{Time.at(change['time']['created'])}"
      puts "  Auth time:      #{Time.at(change['time']['authorized'])}"
      change['acts'].each_with_index do |act, i|
        puts "  Act[#{i}]:"
        puts "    Name:  #{act['act']}"
        puts "    Time:  #{Time.at(act['time'])}"
        puts "    Total: #{act['total']}"
      end
    when 'subscriber'
      puts "  Subscriber id:  #{change['id'].to_s}"
      puts "  Order id:       #{change['orderid']}"
      puts "  Subscriber ref: #{change['ref']}"
      puts "  Order id:       #{change['orderid']}"
      puts "  Payid time:     #{Time.at(change['time']['created'])}"
      puts "  Auth time:      #{Time.at(change['time']['authorized'])}"
      change['acts'].each_with_index do |act, i|
        puts "  Act[#{i}]:"
        puts "    Name:  #{act['act']}"
        puts "    Time:  #{Time.at(act['time'])}"
      end
    end
  end
  myseq = seqobj['seq']
  break if seqobj['changes'].length == 0
end
puts "After applying the changes your system is at seq=#{myseq.to_s}"
