require 'net/http'
require 'base64'
require 'json'
require 'digest'
require 'openssl'
require 'httpclient'

module Scanpay

  class Error < Exception
  end

  class Client
    @httpclient
    @apikey

    def initialize(apikey)
      @httpclient = HTTPClient.new
      @httpclient.ssl_config.add_trust_ca('/Users/cblach/Desktop/truststore/*.test.scanpay.dk.pem')      
      @apikey = apikey
    end
    
    def consttime_streq(a, b)
      return false if a.bytesize != b.bytesize
      neq = 0
      a.bytes.each_index { |i|
        neq |= a.bytes[i] ^ b.bytes[i];
      }
      neq == 0
    end

    def request(uri, data, opts)
      header = {
        'Authorization' => 'Basic ' + Base64.strict_encode64(@apikey),
        'X-Scanpay-SDK' => 'Ruby-1.0.0',
        'Content-Type'  => 'application/json',
      }
      res = nil
      if data == nil
        res = @httpclient.get('https://api.test.scanpay.dk/v1' + uri, nil, header)
      else
        res = @httpclient.post('https://api.test.scanpay.dk/v1' + uri, data.to_json, header)
      end
      raise Error, 'Invalid API-key' if res.code == 403
      raise Error, 'Unexpected http response code: ' + res.code.to_s unless res.code == 200
      resobj = JSON.parse(res.body)
      raise Error, 'Received error from Scanpay: ' + resobj['error'] if resobj['error'] != nil
      resobj
    end

    def newURL(data)
      resobj = request('/new', data, nil)
      if !resobj.has_key? 'url'
        raise Error, 'Missing url field'
      end
      resobj['url']
    end

    def seq(seqnum)
      request('/seq/' + seqnum.to_s, nil, nil)
    end

    def handlePing(body, signature)
      myrawsig = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @apikey, body || '')
      mysig = Base64.strict_encode64(myrawsig)
      raise Error, 'invalid signature' unless consttime_streq(mysig, signature || '')
      resobj = JSON.parse(body)
      raise Error, 'missing fields' unless [resobj['shopid'], resobj['seq']].all? { |i| i.is_a?(Integer) }
      resobj
    end
    private :request, :consttime_streq
  end
end
