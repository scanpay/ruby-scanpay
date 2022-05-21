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

Create a Scanpay client to start using this library:
```ruby
scanpay = Scanpay::Client.new(' APIKEY ')
```
### Payment Link

#### newURL(Object, options)

Create a link to our hosted payment window ([docs](https://docs.scanpay.dk/payment-link) \| [example](tests/newURL.rb)).

```ruby
order = {
    'items' => [{ 'total' => '199.99 DKK' }]
];
puts "Payment url: #{scanpay.newURL(order, options)}"
```
### Synchronization
To know when transactions, charges, subscribers and subscriber renewal succeeds, you need to use the synchronization API. It consists of pings which notify you of changes, and the seq request which allows you to pull changes.
#### handlePing(String, String)
Handle and validate synchronization pings. The method accepts two arguments, the body of the received ping and the `X-Signature` HTTP header. The method returns a hash ([docs](https://docs.scanpay.dk/synchronization#ping-service) \| [example](tests/handlePing.rb)).

```ruby
json = scanpay.handlePing(body, signature)
```

#### seq(Integer, options)

Make a sequence request to pull changes after a specified sequence number ([docs](https://docs.scanpay.dk/synchronization#sequence-request) \| [example](tests/seq.rb)).

```ruby
localSeq = 921;
seqobj = scanpay.seq(localSeq, options)
```

### Transactions

#### capture(Integer, Object, options)
Use Capture to capture a transaction. ([docs](https://docs.scanpay.dk/transactions) \| [example](tests/capture.rb)).
```ruby
transactionId = 5;
data = {
    'total' => '123 DKK',
    'index' => 0,
];
scanpay.capture(transactionId, data, options)
```

#### refund(Integer, Object, options)
Use Refund to refund a captured transaction ([docs](https://docs.scanpay.dk/transactions) \| [example](tests/refund.rb)).
```ruby
transactionId = 5;
data = {
    'total' => '123 DKK',
    'index' => 0,
];
scanpay.refund(transactionId, data, options)
```

#### void(Integer, Object, options)
Use Void to void the amount authorized by the transaction ([docs](https://docs.scanpay.dk/transactions) \| [example](tests/void.rb)).
```ruby
transactionId = 5;
data = {
    'index' => 0,
];
scanpay.void(transactionId, data, options)
```

### Subscriber
Create a subscriber by using newURL with a Subscriber parameter ([docs](https://docs.scanpay.dk/subscriptions/) \| [example](tests/newURL-subscriber.rb)).
```ruby
order = {
    'subscriber' => { 'ref' => 'sub123' },
];
puts "Payment url: #{scanpay.newURL(order, options)}"
```
#### charge(Integer, Object, options)
Use charge to charge a subscriber. The subscriber id is obtained with seq ([docs](https://docs.scanpay.dk/subscriptions/charge-subscriber) \| [example](tests/charge.rb)).
```ruby
subscriberId = 11;
data = {
    'items' => [{ 'total' => '199.99 DKK' }],
];
scanpay.charge(subscriberId, data, options)
```
#### renew(Integer, Object, options)
Use renew to renew a subscriber, i.e. to attach a new card, if it has expired [docs](https://docs.scanpay.dk/subscriptions/renew-subscriber) \| [example](tests/renew.rb)).
```ruby
subscriberId = 11;
data = {
    'successurl' => 'https://scanpay.dk',
];
scanpay.renew(subscriberId, data, options)
```

## Options

All methods, except `handlePing`, accept an optional per-request `options` hash. You can use this to:

* Set the API key for this request ([example](tests/newURL.rb#L11))
* Set HTTP headers, e.g. the highly recommended `X-Cardholder-IP` ([example](tests/newURL.rb#L10-L13))
* Change the hostname to use our test environment `api.test.scanpay.dk` ([example](tests/newURL.rb#L9))
* Enable debugging mode ([example](tests/newURL.rb#L14))

## License

Everything in this repository is licensed under the [MIT license](LICENSE).
