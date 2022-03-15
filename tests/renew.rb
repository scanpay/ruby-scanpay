# Docs: https://docs.scanpay.dk
# help@scanpay.dk
# irc.libera.chat:6697 #scanpay

require_relative '../lib/scanpay'
require 'base64'

$apikey = '1153:YHZIUGQw6NkCIYa3mG6CWcgShnl13xuI7ODFUYuMy0j790Q6ThwBEjxfWFXwJZ0W';
scanpay = Scanpay::Client.new($apikey)
subscriberid = 5

options = {
    'hostname' => 'api.test.scanpay.dk',
    'headers' => {
        'Authorization' => 'Basic ' + Base64.strict_encode64($apikey),
        'X-Cardholder-IP' => '192.168.1.1',
    },
    'debug' => true,
}

data = {
    'successurl'    => 'https://docs.test.scanpay.dk',
    'language'   => 'da',
    'lifetime' => '1h',
}

puts "Generated subscription renewal url: #{scanpay.renew(subscriberid, data, options)}"
