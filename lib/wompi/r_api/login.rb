module Wompi
  module RApi
    class Login < Request
      attr_accessor :acceptance_token, :permalink

      def initialize
        super
      end

      def get_acceptance_token
        @http_verb = 'Get'
        @url += "v1/merchants/#{RApi.pub_key}"

        http
        if success?
          @acceptance_token = @response["data"]["presigned_acceptance"]["acceptance_token"]
          @permalink = @response["data"]["presigned_acceptance"]["permalink"]
          self
        end
      end
    end
  end
end
