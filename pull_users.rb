#!/usr/bin/ruby

require 'bundler/inline'
require 'pp'
require '../base_api'
require './jamf_api'

gemfile do
  source 'https://rubygems.org'
  gem 'httparty'
  gem 'dotenv'
end

Dotenv.load(".env")

response = JamfApi.new.get_accounts
response["accounts"]["users"]["user"].each { |user| puts user["name"] }
