module Wompi
  module RApi
    class << self
      require "base64"
      attr_accessor :pub_key, :prv_key, :sandbox, :webhook

      def configure(&block)
        block.call(self)
      end
      
      def get_base_url
        if @sandbox == true
          "https://sandbox.wompi.co/"
        else
          "https://production.wompi.co/"
        end
      end
    end
  end
end
