module Wompi
  module RApi
    class PaymentMethod < Request

      attr_accessor :type, :id, :created_at, :brand, :name, :last_four, :bin, :exp_year, :exp_month, :holder, :expires_at, :phone_number, :status

      def initialize(login)
        super(login, "pub_key")
      end

      def set_data
        @id = @response["data"]["id"]
        @created_at = @response["data"]["created_at"]
        @brand = @response["data"]["brand"]
        @name = @response["data"]["name"]
        @last_four = @response["data"]["last_four"]
        @bin = @response["data"]["bin"]
        @exp_year = @response["data"]["exp_year"]
        @exp_month = @response["data"]["exp_month"]
        @holder = @response["data"]["card_holder"]
        @expires_at = @response["data"]["expires_at"]
        @phone_number = @response["data"]["phone_number"]
        @status = @response["data"]["status"]
      end

      def as_dummy_card(status)
        @type = "CARD"
        @params = {
          number: status == "APPROVED" ? "4242424242424242" : "4111111111111111",
          cvc: "123",
          exp_month: "01",
          exp_year:  "#{(Date.today + 1.year).year.to_s.last(2)}",
          card_holder: "Han Solo Berger"
        }
      end


      def as_card(number, cvc, exp_month, exp_year, holder)
        @type = "CARD"
        @params = {
          number: "#{number}",
          cvc: "#{cvc}",
          exp_month: "#{exp_month}",
          exp_year: "#{exp_year}",
          card_holder: "#{holder}"
        }
      end

      def as_card_with_known_id(id)
        @type = "CARD"
        @id = id
      end

      def as_dummy_nequi(status)
        @type = "NEQUI"
        @params = {
          phone_number: status == "APPROVED" ? "3991111111" : "3992222222"
        }
      end

      def as_nequi(phone)
        @type = "NEQUI"
        @params = {
          phone_number: "#{phone}"
        }
      end

      def check_nequi
        @http_verb = 'Get'
        @url = "v1/tokens/nequi/#{@id}"

        if @response["data"]
          @status = @response["data"]["status"]
        end
        self
      end

      def get_nequi(id=nil)
        @id = id unless id.nil?
        @http_verb = 'Get'
        @url += "v1/tokens/nequi/#{@id}"

        http

        if success?
          set_data
          self
        end
      end

      def create
        @http_verb = 'Post'
        if @type == "CARD"
          @url += "v1/tokens/cards"
        else
          @url += "v1/tokens/nequi"
        end

        http

        if success?
          if @type == "CARD"
            if @response["status"] == "CREATED"
              set_data
              self
            else
              nil
            end
          else
            if ["APPROVED", "PENDING"].include? @response["status"]
              set_data
              self
            else
              nil
            end
          end
        end
      end

    end
  end
end
