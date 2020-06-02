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
          expect(output).not_to match("monetization")
        end
      end
  
      describe "with payment_pointer in the front matter" do
        let(:page) { make_page("payment_pointer" => "page_pointer") }
  
        it "outputs a meta tag with the payment pointer" do
          expect(output).to match("<meta name='monetization' content='page_pointer'>")
        end
      end
    end

    describe "with a post" do
      describe "with no payment_pointer front matter" do
        let(:page) { make_post }
  
        it "doesn't outputs a monetization meta tag" do
          expect(output).not_to match("monetization")
        end
      end
  
      describe "with payment_pointer in the front matter" do
        let(:page) { make_post("payment_pointer" => "post_pointer") }
  
        it "outputs a meta tag with the payment pointer" do
          expect(output).to match("<meta name='monetization' content='post_pointer'>")
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
          expect(output).to match("<meta name='monetization' content='#{payment_pointer}'>")
        end
      end

      describe "with payment_pointer in the front matter" do
        let(:page) { make_page("payment_pointer" => "page_pointer") }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to match("<meta name='monetization' content='page_pointer'>")
        end
      end
    end
    
    describe "with a post" do
      describe "with no payment_pointer front matter" do
        let(:page) { make_post }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to match("<meta name='monetization' content='#{payment_pointer}'>")
        end
      end

      describe "with payment_pointer in the front matter" do
        let(:page) { make_post("payment_pointer" => "post_pointer") }

        it "outputs a meta tag with the payment pointer" do
          expect(output).to match("<meta name='monetization' content='post_pointer'>")
        end
      end
    end
  end
end