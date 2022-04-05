# frozen_string_literal: true

RSpec.describe Jekyll::WebMonetization::Tag do
  let(:payment_pointer) { "$pay.money/to_me" }

  let(:context)   { make_context(:page => page, :site => site) }
  let(:output)    { Liquid::Template.parse("{% web_monetization %}").render!(context, {}) }

  describe "with no payment pointer set for the site" do
    let(:site) { make_site }

    describe "with a page" do
      describe "with no payment_pointer front matter" do
        let(:page) { make_page }

        it "doesn't outputs a monetization meta tag" do
          expect(output).not_to include("monetization")
        end
      end

      describe "with payment_pointer in the front matter" do
        let(:page) { make_page("payment_pointer" => "page_pointer") }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='page_pointer'>")
        end
      end

      describe "with an array of payment_pointers in the front matter" do
        let(:payment_pointers) { ["$pay.money/to_me", "$example.payment/phil"] }
        let(:page) { make_page("payment_pointer" => payment_pointers) }

        it "outputs a meta tag with the payment pointer" do
          expect(output).not_to include("<meta name='monetization' content='page_pointer'>")
        end
        it "outputs javascript to randomly choose pointer evenly" do
          expect(output).to include("<script>")
          expect(output).to include('pickPointer({"$pay.money/to_me":1,"$example.payment/phil":1}, 2)')
        end
      end

      describe "with a singleton array of payment_pointers in the front matter" do
        let(:payment_pointers) { ["page_pointer"] }
        let(:page) { make_page("payment_pointer" => payment_pointers) }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='page_pointer'>")
        end
      end

      describe "with a hash of payment pointers in the front matter" do
        let(:payment_pointers) { { "$pay.money/to_me" => 10, "$example.payment/phil" => 20 } }
        let(:page) { make_page("payment_pointer" => payment_pointers) }

        it "outputs a meta tag with the payment pointer" do
          expect(output).not_to include("<meta name='monetization' content='page_pointer'>")
        end
        it "outputs javascript to randomly choose pointer evenly" do
          expect(output).to include("<script>")
          expect(output).to include('pickPointer({"$pay.money/to_me":10,"$example.payment/phil":20}, 30)')
        end
      end
    end

    describe "with a post" do
      describe "with no payment_pointer front matter" do
        let(:page) { make_post }

        it "doesn't outputs a monetization meta tag" do
          expect(output).not_to include("monetization")
        end
      end

      describe "with payment_pointer in the front matter" do
        let(:page) { make_post("payment_pointer" => "post_pointer") }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='post_pointer'>")
        end
      end


      describe "with an array of payment_pointers in the front matter" do
        let(:payment_pointers) { ["$pay.money/to_me", "$example.payment/phil"] }
        let(:page) { make_post("payment_pointer" => payment_pointers) }

        it "outputs a meta tag with the payment pointer" do
          expect(output).not_to include("<meta name='monetization' content='page_pointer'>")
        end
        it "outputs javascript to randomly choose pointer evenly" do
          expect(output).to include("<script>")
          expect(output).to include('pickPointer({"$pay.money/to_me":1,"$example.payment/phil":1}, 2)')
        end
      end

      describe "with a hash of payment pointers in the front matter" do
        let(:payment_pointers) { { "$pay.money/to_me" => 10, "$example.payment/phil" => 20 } }
        let(:page) { make_post("payment_pointer" => payment_pointers) }

        it "outputs a meta tag with the payment pointer" do
          expect(output).not_to include("<meta name='monetization' content='page_pointer'>")
        end
        it "outputs javascript to randomly choose pointer evenly" do
          expect(output).to include("<script>")
          expect(output).to include('pickPointer({"$pay.money/to_me":10,"$example.payment/phil":20}, 30)')
        end
      end
    end
  end

  describe "with a site-wide payment pointer" do
    let(:site) { make_site("payment_pointer" => payment_pointer) }

    describe "with a page" do
      describe "with no payment_pointer front matter" do
        let(:page) { make_page }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='#{payment_pointer}'>")
        end
      end

      describe "with payment_pointer in the front matter" do
        let(:page) { make_page("payment_pointer" => "page_pointer") }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='page_pointer'>")
        end
      end
    end

    describe "with a post" do
      describe "with no payment_pointer front matter" do
        let(:page) { make_post }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='#{payment_pointer}'>")
        end
      end

      describe "with payment_pointer in the front matter" do
        let(:page) { make_post("payment_pointer" => "post_pointer") }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to include("<meta name='monetization' content='post_pointer'>")
        end
      end
    end
  end

  describe "with an array of site payment pointers" do
    let(:payment_pointers) { ["$pay.money/to_me", "$example.payment/phil"] }
    let(:site) { make_site("payment_pointer" => payment_pointers) }

    describe "with a page" do
      let(:page) { make_page }

      it "doesn't output a meta tag" do
        expect(output).not_to include("<meta name='monetization'")
      end

      it "outputs javascript to randomly choose pointer evenly" do
        expect(output).to include("<script>")
        expect(output).to include('pickPointer({"$pay.money/to_me":1,"$example.payment/phil":1}, 2)')
      end
    end

    describe "with a post" do
      let(:page) { make_post }

      it "doesn't output a meta tag" do
        expect(output).not_to include("<meta name='monetization'")
      end

      it "outputs javascript to randomly choose pointer evenly" do
        expect(output).to include("<script>")
        expect(output).to include('pickPointer({"$pay.money/to_me":1,"$example.payment/phil":1}, 2)')
      end
    end
  end

  describe "with an object of site payment pointers and weights" do
    let(:payment_pointers) { { "$pay.money/to_me" => 10, "$example.payment/phil" => 20 } }
    let(:site) { make_site("payment_pointer" => payment_pointers) }

    describe "with a page" do
      let(:page) { make_page }

      it "doesn't output a meta tag" do
        expect(output).not_to include("<meta name='monetization'")
      end

      it "outputs javascript to randomly choose pointer evenly" do
        expect(output).to include("<script>")
        expect(output).to include('pickPointer({"$pay.money/to_me":10,"$example.payment/phil":20}, 30)')
      end
    end

    describe "with a post" do
      let(:page) { make_post }

      it "doesn't output a meta tag" do
        expect(output).not_to include("<meta name='monetization'")
      end

      it "outputs javascript to randomly choose pointer evenly" do
        expect(output).to include("<script>")
        expect(output).to include('pickPointer({"$pay.money/to_me":10,"$example.payment/phil":20}, 30)')
      end
    end
  end
end
