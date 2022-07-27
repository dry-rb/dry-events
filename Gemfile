# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

gem "dry-core", github: "dry-rb/dry-core", branch: "main"

group :test do
  gem "rack"
end

group :tools do
  gem "pry"
  gem "pry-byebug", platform: :mri
end
