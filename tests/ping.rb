require 'webrick'
require '../lib/scanpay'

client = Scanpay::Client.new(' API KEY ')

server = WEBrick::HTTPServer.new :Port => 8080
server.mount_proc '/' do |req, res|
    ping = client.handlePing(req.body(), req.header['x-signature'][0])
    puts 'Succesfully received ping: shopid=' + ping['shopid'].to_s + ', seq=' + ping['seq'].to_s
end

trap 'INT' do server.shutdown end
server.start
