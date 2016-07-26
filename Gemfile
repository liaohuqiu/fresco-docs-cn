# frozen_string_literal: true
# A sample Gemfile
source "https://rubygems.org"

# gem "rails"
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages']