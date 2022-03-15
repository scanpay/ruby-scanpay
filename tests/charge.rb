# Docs: https://docs.scanpay.dk
# help@scanpay.dk
# irc.libera.chat:6697 #scanpay

require_relative '../lib/scanpay'

apikey = '1153:YHZIUGQw6NkCIYa3mG6CWcgShnl13xuI7ODFUYuMy0j790Q6ThwBEjxfWFXwJZ0W';
client = Scanpay::Client.new(apikey)
subscriberid = 5;
options = {
    'hostname' => 'api.test.scanpay.dk',
    'headers' => {
        'Idempotency-Key' => client.generateIdempotencyKey(),
    },
    'debug' => true,
}

data = {
    'orderid' => '999',
    'items'   => [
        {
            'name'     => 'Ultra Bike 7000',
            'total'    => '1337.01 DKK',
            'quantity' => 2,
            'sku'      => 'ff123',
        },
        {
          'name'      => '巨人宏偉的帽子',
          'total'     => '420 DKK',
          'quantity'  => 2,
          'sku'       => '124',
        },
    ]
}
res = nil
for i in 0..2 do
  puts "Attempting charge with idempotency key #{options['headers']['Idempotency-Key']}"
  begin
    res = client.charge(subscriberid, data, options)
    break
  rescue Scanpay::IdempotentResponseException => e
    puts "Idempotent exception: #{e.message}"
    # Regenerate idempotency key
    puts 'Regenerating idempotency key' if i < 2
    options['headers']['Idempotency-Key'] = client.generateIdempotencyKey()
  rescue => e
    puts "Exception (not idempotent): #{e.message}"
  end
  sleep(1 + i);
end
if res == nil
  raise 'Attempted charging 3 times and failed'
end
puts 'Charge succeded:'
puts "id = #{res['id']}"
puts "authorized = #{res['totals']['authorized']}"

