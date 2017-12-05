# Scanpay Ruby Client

Ruby client library for the Scanpay API. You can always e-mail us at [help@scanpay.dk](mailto:help@scanpay.dk) or chat with us on `irc.scanpay.dk:6697` or `#scanpay` at Freenode ([webchat](https://webchat.freenode.net?randomnick=1&channels=scanpay&prompt=1))

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

## Methods

Please note that some methods accept an optional per-request `options` hash. You can read more about this [here](#options).

### newURL(Object, options)

Create a [payment link](https://docs.scanpay.dk/payment-link#request-fields) by passing the order details through `newURL`. Strictly speaking, only the following data is required, but we strongly encourage you to use the entire spec ([example](tests/newURL.rb)).

```ruby
order = {
    'items' => [{ 'total' => '199.99 DKK' }]
];
puts "Payment url: #{scanpay.newURL(order, options)}"
```

### handlePing(String, String)

Securely and efficiently validate [pings](https://docs.scanpay.dk/synchronization). This method accepts two arguments from the received ping request, the HTTP message body and the `X-Signature` HTTP header. The return value is a JSON hash ([example](tests/handlePing.rb)).

```ruby
json = scanpay.handlePing(body, signature)
```

### seq(Integer, options)

Make a [sequence request](https://docs.scanpay.dk/synchronization#seq-request) to get a hash with a number of changes since the supplied sequence number ([example](tests/seq.rb)).

```ruby
localSeq = 921;
seqobj = scanpay.seq(localSeq, options)
```

## Options

All methods, except `handlePing`, accept an optional per-request `options` hash. You can use this to:

* Set the API key for this request ([example](tests/newURL.rb#L11))
* Set HTTP headers, e.g. the highly recommended `X-Cardholder-IP` ([example](tests/newURL.rb#L10-L13))
* Change the hostname to use our test environment `api.test.scanpay.dk` ([example](tests/newURL.rb#L9))
* Enable debugging mode ([example](tests/newURL.rb#L14))

## License

Everything in this repository is licensed under the [MIT license](LICENSE).
