module Wompi
  module RApi
    class Request

      require 'uri'
      require 'net/https'
      require 'json'

      attr_accessor :url, :_url, :params, :headers, :login, :with_authentication_key

      attr_reader :response, :http_verb, :error

      def initialize(login=nil, with_authentication_key=false)
        @login = login
        @with_authentication_key = with_authentication_key
        @url = RApi.get_base_url
      end

      def success?
        @error.nil? && !@response.nil?
      end

      def fail?
        !@error.nil?
      end

      private

      def url
        @url ||= _url
      end

      def reset_url
        @url = url
      end

      def http

        uri = URI.parse(@url)

        https = Net::HTTP.new(uri.host,uri.port)

        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE

        net_class = Object.const_get("Net::HTTP::#{http_verb}")
        @headers = {"Content-Type" => "application/json"}

        if @with_authentication_key == "pub_key"
          @headers["Authorization"] = "Bearer #{RApi.pub_key}"
        end
        if @with_authentication_key == "prv_key"
          @headers["Authorization"] = "Bearer #{RApi.prv_key}"
        end
        request = net_class.new(uri, initheader = @headers)

        if http_verb == "Post"

          request.body = @params.to_json
        end

        request = https.request(request)

        if request.is_a?(Net::HTTPSuccess)
          begin
            @response = JSON.parse(request.body)
          rescue
            @response = request.body
          end
          @error = nil
        else
          @response = nil
          @error = JSON.parse(request.body)
        end
      end
    end
  end
end
