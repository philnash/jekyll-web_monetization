# frozen_string_literal: true
require "json"

module Jekyll
  module WebMonetization
    class Tag < Liquid::Tag
      def render(context)
        site_payment_pointer = context.registers[:site].config["payment_pointer"]
        page_payment_pointer = context.registers[:page]["payment_pointer"] || site_payment_pointer

        if page_payment_pointer.is_a?(Array)
          if page_payment_pointer.length == 1
            pointer_to_html(page_payment_pointer[0])
          else
            pointers_with_weights = array_to_object(page_payment_pointer)
            return javascript(pointers_with_weights)
          end
        elsif page_payment_pointer.is_a?(Hash)
          return javascript(page_payment_pointer)
        elsif page_payment_pointer.is_a?(String)
          pointer_to_html(page_payment_pointer)
        end
      end

      private

      def pointer_to_html(pointer)
        return "<meta name='monetization' content='#{pointer}'>"
      end

      def array_to_object(pointers)
        pointers.reduce({}) { |acc, pointer| acc[pointer] = 1; acc }
      end

      def javascript(pointers_with_weights)
        sum = pointers_with_weights.reduce(0) { |acc, (pointer, weight)| acc + weight }
        pointers = JSON.generate(pointers_with_weights)
        script = <<~JAVASCRIPT
          <script>
            (function() {
              function pickPointer(pointers, sum) {
                let choice = Math.random() * sum;
                for (const pointer in pointers) {
                  const weight = pointers[pointer];
                  if ((choice -= weight) <= 0) {
                    return pointer;
                  }
                }
              }

              window.addEventListener("load", function() {
                const tag = document.createElement("meta");
                tag.name = "monetization";
                tag.content = pickPointer(#{pointers}, #{sum});
                document.head.appendChild(tag);
              });
            })();
          </script>
        JAVASCRIPT
      end
    end
  end
end
