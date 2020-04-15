#!/usr/bin/ruby
require 'bundler/inline'
require 'pp'
require 'nokogiri'

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
      "content-type" => "application/xml"
    }
  end

  def update_purchasing(serial, date, price)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.computer {
        xml.general {
          xml.purchasing {
            xml.purchase_price date
            xml.po_date price
          }
        }
      }
    end
    puts builder.to_xml
    @options[:body] = "#{builder.to_xml}"
    response = self.class.put("/computers/serialnumber/#{serial}", @options)
    response
  end
end

puts JamfApi.new.update_purchasing("C02X475UJG5H", "2018-09-04", "1952.25")
