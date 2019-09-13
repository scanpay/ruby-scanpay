# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require_relative '../lib/scanpay'
require 'base64'

$apikey = '1153:YHZIUGQw6NkCIYa3mG6CWcgShnl13xuI7ODFUYuMy0j790Q6ThwBEjxfWFXwJZ0W';
scanpay = Scanpay::Client.new($apikey)

options = {
    'hostname' => 'api.test.scanpay.dk',
    'headers' => {
        'Authorization' => 'Basic ' + Base64.strict_encode64($apikey),
        'X-Cardholder-IP' => '192.168.1.1',
    },
    'debug' => true,
}

order = {
    'orderid'    => 'a766409',
    'language'   => 'da',
    'successurl' => 'https://insertyoursuccesspage.dk',
    'subscriber' => {
        'ref' => 'sub123',
    },
    'billing'  => {
        'name'    => 'John Doe',
        'company' => 'The Shop A/S',
        'email'   => 'john@doe.com',
        'phone'   => '+4512345678',
        'address' => ['Langgade 23, 2. th'],
        'city'    => 'Havneby',
        'zip'     => '1234',
        'state'   => '',
        'country' => 'DK',
        'vatin'   => '35413308',
        'gln'     => '7495563456235',
    },
    'shipping' => {
        'name'    => 'Jan Dåh',
        'company' => 'The Choppa A/S',
        'email'   => 'jan@doh.com',
        'phone'   => '+4587654321',
        'address' => ['Langgade 23, 1. th', 'C/O The Choppa'],
        'city'    => 'Haveby',
        'zip'     => '1235',
        'state'   => '',
        'country' => 'DK',
    },
}

puts "Generated subscription url: #{scanpay.newURL(order, options)}"
