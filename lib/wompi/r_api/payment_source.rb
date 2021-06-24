module Wompi
  module RApi
    class PaymentSource < Request

      attr_accessor :id, :customer_email, :status

      def initialize(login)
        super(login, "prv_key")
      end

      def create(payment_method, customer_email)
        @http_verb = 'Post'
        @url += "v1/payment_sources"
        @params = {
          type: payment_method.type,
          token: payment_method.id,
          customer_email: customer_email,
          acceptance_token: @login.acceptance_token
        }

        http

        if success?
          if @response["data"]
            @id = @response["data"]["id"]
            @status = @response["data"]["status"]
            self
          else
            nil
          end
        end
      end

    end
  end
end
