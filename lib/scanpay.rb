require 'net/http'
require 'base64'
require 'json'
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
      @httpclient.ssl_config.set_default_paths
      @apikey = apikey
    end

    def consttime_streq(a, b)
      return false if a.bytesize != b.bytesize
      neq = 0
      a.bytes.each_index { |i|
        neq |= a.bytes[i] ^ b.bytes[i];
      }
      neq === 0
    end

    def request(uri, data, opts)
      header = {
        'Authorization' => 'Basic ' + Base64.strict_encode64(@apikey),
        'X-Scanpay-SDK' => 'Ruby-1.0.0',
        'Content-Type'  => 'application/json',
      }
      res = nil
      if data === nil
        res = @httpclient.get('https://api.scanpay.dk/v1' + uri, nil, header)
      else
        res = @httpclient.post('https://api.scanpay.dk/v1' + uri, data.to_json, header)
      end
      raise Error, res.body.lines.first.chomp unless res.code === 200
      resobj = JSON.parse(res.body)
      resobj
    end

    def newURL(data)
      resobj = request('/new', data, nil)
      if !resobj.has_key? 'url'
        raise Error, 'Missing url field from response'
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
      raise Error, 'missing fields from response' unless [resobj['shopid'], resobj['seq']].all? { |i| i.is_a?(Integer) }
      resobj
    end
    private :request, :consttime_streq
  end
end
