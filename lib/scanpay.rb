# help@scanpay.dk || irc.scanpay.dk:6697 || scanpay.dk/slack
require 'base64'
require 'json'
require 'openssl'
require 'securerandom'
require 'httpclient' # Thread-Safe. Consider https://github.com/httprb/http

module Scanpay
  class IdempotentResponseException < StandardError
  end

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
        'x-sdk' => 'Ruby-1.1.0/' + RUBY_VERSION,
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

    def generateIdempotencyKey()
      return SecureRandom.base64(32).delete('=')
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
      if headers['idempotency-key']
        idem = res.header['idempotency-status'][0]
        case idem
        when 'OK'
          # Do nothing
        when 'ERROR'
          raise "server failed to provide idempotency: #{res.reason}"
        when ''
          raise "missing response idempotency status: #{res.reason}"
        else
          raise "unknown idempotency status '#{idem}': #{res.reason}"
        end
      end
      raise IdempotentResponseException, res.reason if res.code != 200
      begin
        return JSON.parse(res.body)
      rescue JSON::ParserError => e
        raise IdempotentResponseException, "invalid json response: #{e.message}"
      end
    end

    # newURL: Create a new payment link
    def newURL(data, opts={})
      o = request('/v1/new', data, opts)
      return o['url'] if o['url'].is_a? String
      raise 'invalid response from server'
    end

    # seq: Get array of changes since the reqested sequence number
    def seq(num, opts={})
      if !num.is_a? Integer
        raise ArgumentError, 'first argument is not an integer'
      end
      o = request('/v1/seq/' + num.to_s, nil, opts)
      return o if (o['changes'].kind_of? Array) && (o['seq'].is_a? Integer)
      raise 'invalid response from server'
    end

    # handlePing: Convert body to JSON and validate signature
    def handlePing(body='', signature='')
      digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @apikey, body)
      is_valid = timesafe_equals(Base64.strict_encode64(digest), signature)
      raise 'invalid signature' unless is_valid

      o = JSON.parse(body)
      return o if (o['shopid'].is_a? Integer) && (o['seq'].is_a? Integer)
      raise 'invalid ping'
    end

    def charge(subid, data, opts={})
      if !subid.is_a? Integer
        raise ArgumentError, 'first argument is not an integer'
      end
      return request("/v1/subscribers/#{subid}/charge", data, opts);
    end

    def renew(subid, data, opts={})
      if !subid.is_a? Integer
        raise ArgumentError, 'first argument is not an integer'
      end
      o = request("/v1/subscribers/#{subid}/renew", data, opts);
      return o['url'] if o['url'].is_a? String
      raise 'invalid response from server'
    end

    private :request
  end
end
