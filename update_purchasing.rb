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
      authorization: "Basic #{ENV["JAMF_BASE64"]}",
    }
  end

  def update_purchasing(serial, date, price)
    @options[:body] = {
      purchasing: {
        purchase_price: price,
        po_date: date
        }
    }
    puts @options
    response = self.class.put("/computers/serialnumber/#{serial}", @options)
    response
  end
end

PP.pp(JamfApi.new.update_purchasing("C02X475UJG5H", "2018-09-04", "1952.25"))
