# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require 'base64'
require 'json'
require 'openssl'
require 'httpclient' # Thread-Safe. Consider https://github.com/httprb/http

module Scanpay
  class Error < StandardError; end

  class Client
    @https
    @headers
    @apikey

    def initialize(apikey)
      @https = HTTPClient.new
      @https.ssl_config.set_default_paths
      @https.connect_timeout = 20 # seconds
      @apikey = apikey
      @headers = {
        'authorization' => 'basic ' + Base64.strict_encode64(apikey),
        'x-sdk' => 'Ruby-1.0.0/' + RUBY_VERSION,
        'content-type'  => 'application/json',
      }
    end

    def timesafe_equals(a, b)
      return false if a.bytesize != b.bytesize
      neq = 0
      a.bytes.each_index { |i|
        neq |= a.bytes[i] ^ b.bytes[i];
      }
      return neq === 0
    end

    def request(path, data, opts={})
      hostname = opts['hostname'] || 'api.scanpay.dk'
      headers = @headers.clone

      # Let merchant override HTTP headers
      if opts.has_key? 'headers'
        opts['headers'].each do |key, value|
          headers[key.downcase] = value
        end
      end
      res = (data === nil) ? @https.get('https://' + hostname + path, nil, headers) :
            @https.post('https://' + hostname + path, data.to_json, headers)

      return JSON.parse(res.body) if res.code == 200
      raise Error, res.reason
    end

    # newURL: Create a new payment link
    def newURL(data, opts={})
      o = request('/v1/new', data, opts)
      return o['url'] if o['url'].is_a? String
      raise Error, 'invalid response from server'
    end

    # seq: Get array of changes since the reqested sequence number
    def seq(num, opts={})
      if !num.is_a? Integer
        raise ArgumentError, 'first argument is not an integer'
      end
      o = request('/v1/seq/' + num.to_s, nil, opts)
      return o if (o['changes'].kind_of? Array) && (o['seq'].is_a? Integer)
      raise Error, 'invalid response from server'
    end

    # handlePing: Convert body to JSON and validate signature
    def handlePing(body='', signature='')
      digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @apikey, body)
      is_valid = timesafe_equals(Base64.strict_encode64(digest), signature)
      raise Error, 'invalid signature' unless is_valid

      o = JSON.parse(body)
      return o if (o['shopid'].is_a? Integer) && (o['seq'].is_a? Integer)
      raise Error, 'invalid ping'
    end

    private :request
  end
end
