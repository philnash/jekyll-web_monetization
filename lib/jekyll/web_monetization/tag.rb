# frozen_string_literal: true

module Jekyll
  module WebMonetization
    class Tag < Liquid::Tag
      def render(context)
        site_payment_pointer = context.registers[:site].config["payment_pointer"]
        page_payment_pointer = context.registers[:page]["payment_pointer"] || site_payment_pointer
        if page_payment_pointer
          "<meta name='monetization' content='#{page_payment_pointer}'>"
        end
      end
    end
  end
end