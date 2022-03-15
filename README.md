# Scanpay ruby client

The official Ruby client library for the Scanpay API ([docs](https://docs.scanpay.dk)). You can always e-mail us at [help@scanpay.dk](mailto:help@scanpay.dk), or chat with us on IRC at libera.chat #scanpay

## Installation

You need Ruby version >= 2.0 with [httpclient](https://github.com/nahi/httpclient). The code is published at [rubygems](https://rubygems.org/gems/scanpay) and you can install it with:

```bash
gem install scanpay
```
And include it in your project:

```ruby
require 'scanpay'
client = Scanpay::Client.new('API key')
```

### Manual installation

Download the [latest release](https://github.com/scanpaydk/ruby-scanpay/releases) and include in into your project:

```ruby
require_relative 'lib/scanpay'
scanpay = Scanpay::Client.new('API key')
```

## Usage

The API documentation is available [here](https://docs.scanpay.dk/). Most methods accept an optional per-request object with [options](#options), here referred to as `options`.

#### newURL(Object, options)

Create a link to our hosted payment window ([docs](https://docs.scanpay.dk/payment-link) \| [example](tests/newURL.rb)).

```ruby
order = {
    'items' => [{ 'total' => '199.99 DKK' }]
];
puts "Payment url: #{scanpay.newURL(order, options)}"
```

#### seq(Integer, options)

Make a sequence request to get a hash with changes after a specified sequence number ([docs](https://docs.scanpay.dk/synchronization#sequence-request) \| [example](tests/seq.rb)).

```ruby
localSeq = 921;
seqobj = scanpay.seq(localSeq, options)
```

#### handlePing(String, String)

Handle and validate synchronization pings. The method accepts two arguments, the body of the received ping and the `X-Signature` HTTP header. The method returns a hash ([docs](https://docs.scanpay.dk/synchronization#ping-service) \| [example](tests/handlePing.rb)).

```ruby
json = scanpay.handlePing(body, signature)
```

## Options

All methods, except `handlePing`, accept an optional per-request `options` hash. You can use this to:

* Set the API key for this request ([example](tests/newURL.rb#L11))
* Set HTTP headers, e.g. the highly recommended `X-Cardholder-IP` ([example](tests/newURL.rb#L10-L13))
* Change the hostname to use our test environment `api.test.scanpay.dk` ([example](tests/newURL.rb#L9))
* Enable debugging mode ([example](tests/newURL.rb#L14))

## License

Everything in this repository is licensed under the [MIT license](LICENSE).
