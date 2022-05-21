# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require_relative '../lib/scanpay'

apikey = '1153:YHZIUGQw6NkCIYa3mG6CWcgShnl13xuI7ODFUYuMy0j790Q6ThwBEjxfWFXwJZ0W';
client = Scanpay::Client.new(apikey)
trnid = 5;
options = {
    'hostname' => 'api.test.scanpay.dk',
    'debug' => true,
}

data = {
    'total' => '100 DKK',
    'index' => 0,
}

res = client.refund(trnid, data, options)
puts "#{res}"
