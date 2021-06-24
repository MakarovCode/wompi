
module Wompi
  module RApi
    class Transaction < Request

      attr_accessor :id, :amount_in_cents, :currency, :customer_email, :payment_method, :reference, :payment_source, :status

      def initialize(login)
        super(login, "prv_key")
      end

      def set_data
        @id = @response["data"]["id"]
        @status = @response["data"]["status"]
      end

      def prepare(amount_in_cents, currency, customer_email, payment_source, installments, reference)
        @params = {
          amount_in_cents: amount_in_cents,
          currency: currency,
          customer_email: customer_email,
          payment_method: {
            installments: installments
          },
          reference: "#{reference}",
          payment_source_id: payment_source.id,
          acceptance_token: @login.acceptance_token
        }
      end

      def get(id=nil)
        @id = id unless id.nil?
        @http_verb = 'Get'
        @url += "v1/transactions/#{@id}"

        http

        if success?
          set_data
          self
        end
      end

      def search(reference)
        @http_verb = 'Get'
        @url += "v1/transactions?reference=#{reference}"

        http

        if success?
          @response["data"]
        else
          []
        end
      end

      def void(id=nil)
        @id = id unless id.nil?
        @http_verb = 'Post'
        @url += "v1/transactions/#{@id}/void"

        http

        if success?
          set_data
          self
        end
      end

      def create
        @http_verb = 'Post'
        @url += "v1/transactions"
        @params[:extra] = {
          async_payment_url: Rapi.webhook
        }

        http

        if success?
          @id = @response["data"]["id"]
          self
        end
      end

    end
  end
end
