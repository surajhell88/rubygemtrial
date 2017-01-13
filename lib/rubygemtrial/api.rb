require "faraday"
require "oj"
# https://api.myjson.com/bins/c4vbn

module Rubygemtrial
  class API
    attr_reader :token, :conn, :silent_output

    URL = 'https://api.myjson.com'
    API_ROOT  = '/api/v1'

    def initialize()
      @conn = Faraday.new(url: URL) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(url, options = {})
      request :get, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end
    
    private

    def request(method, url, options = {})
      begin
        connection = options[:client] || @conn
        connection.send(method) do |req|
          req.url url
          build_request(req, options)
        end
      rescue Faraday::ConnectionFailed
        puts "Connection error. Please try again."
      end
    end

    def build_request(request, options)
      build_headers(request, options[:headers])
      build_params(request, options[:params])
      build_body(request, options[:body])
    end

    def build_headers(request, headers)
      if headers
        headers.each do |header, value|
          request.headers[header] = value
        end
      end
    end

    def build_params(request, params)
      if params
        params.each do |param, value|
          request.params[param] = value
        end
      end
    end

    def build_body(request, body)
      if body
        request.body = Oj.dump(body, mode: :compat)
      end
    end
  end
end
