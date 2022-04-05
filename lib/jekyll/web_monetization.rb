# frozen_string_literal: true

require "jekyll"
require "jekyll/web_monetization/version"
require "jekyll/web_monetization/tag"


module Jekyll
  module WebMonetization
  end
end

Liquid::Template.register_tag('web_monetization', Jekyll::WebMonetization::Tag)
