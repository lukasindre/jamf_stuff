#!/usr/bin/ruby
require 'bundler/inline'
require 'pp'

gemfile do 
  source 'https://rubygems.org'
  gem 'httparty'
  gem 'dotenv'
end

Dotenv.load(".env")

class JamfApi
  include HTTParty
  base_uri "https://upstart.jamfcloud.com/JSSResource"

  def initialize
    @options = {}
    @options[:headers] = {
      accept: "application/xml",
      authorization: "Basic #{ENV["JAMF_BASE64"]}"
    }
  end

  def list_computers
    response = self.class.get("/computers", @options)
    response
  end

  def get_computer_by_id(id)
    response = self.class.get("/computers/id/#{id}", @options)
    response
  end
end

COMPUTER_IDS = []

response = JamfApi.new.list_computers
response["computers"]["computer"].each { |computer| COMPUTER_IDS.append(computer["id"]) }
puts COMPUTER_IDS[0]
PP.pp(JamfApi.new.get_computer_by_id(COMPUTER_IDS[0]))
# COMPUTER_IDS.each do |id|
#   PP.pp(JamfApi.new.get_computer_by_id(id))
# end
