# Scanpay Ruby Client

You can sign up for a Scanpay account at [scanpay.dk/opret](https://scanpay.dk/opret).

## Installation

This gem is published at [rubygems](https://rubygems.org/gems/scanpay):

```bash
gem install scanpay
```

## Getting Started

To create a [payment link](https://docs.scanpay.dk/payment-link) all you need to do is:

```ruby
require 'scanpay'
client = Scanpay::Client.new(' API KEY ')

order = {
    'items'    => [
        {
            'name'     => 'Pink Floyd: The Dark Side Of The Moon',
            'quantity' => 2,
            'price'    => '99.99 DKK'
        }
    ]
}
puts "Generated payment url: #{client.newURL(order)}"
```