# frozen_string_literal: true

require_relative 'lib/jekyll/web_monetization/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-web_monetization"
  spec.version       = Jekyll::WebMonetization::VERSION
  spec.authors       = ["Phil Nash"]
  spec.email         = ["philnash@gmail.com"]

  spec.summary       = %q{A Jekyll plugin to add Web Monetization API payment pointers to your site}
  spec.description   = %q{A Jekyll plugin to add Web Monetization API payment pointers to your site}
  spec.homepage      = "https://github.com/philnash/jekyll-web_monetization"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/philnash/jekyll-web_monetization"
  spec.metadata["changelog_uri"] = "https://github.com/philnash/jekyll-web_monetization/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
