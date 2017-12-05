# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require_relative '../lib/scanpay'
require 'webrick'

$apikey = 'api key';
scanpay = Scanpay::Client.new($apikey)

server = WEBrick::HTTPServer.new :Port => 8080
server.mount_proc '/' do |req, res|
    ping = scanpay.handlePing(req.body(), req.header['x-signature'][0])
    puts 'Succesfully received ping: shopid=' + ping['shopid'].to_s + ', seq=' + ping['seq'].to_s
end

trap 'INT' do server.shutdown end
server.start
