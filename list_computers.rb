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
    JamfComputer.new(self.class.get("/computers/id/#{id}", @options))
  end
end

class JamfComputer
  def initialize(json)
    @json = json
  end

  def name
    @json["computer"]["general"]["name"]
  end
  
  def site
    @json["computer"]["general"]["site"]["name"]
  end
end

COMPUTER_IDS = []

response = JamfApi.new.list_computers
response["computers"]["computer"].each { |computer| COMPUTER_IDS.append(computer["id"]) }

COMPUTER_IDS.each do |id|
  computer = JamfApi.new.get_computer_by_id(id)
  puts "#{computer.name},#{computer.site}"
end
