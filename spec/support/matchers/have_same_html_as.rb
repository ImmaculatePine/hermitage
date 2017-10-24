require 'rspec/expectations'
require 'nokogiri'
require 'lorax'

RSpec::Matchers.define :have_same_html_as do |expected|
  match do |actual|
    actual_html = Nokogiri::HTML(actual)
    expected_html = Nokogiri::HTML(expected)
    actual_signature = Lorax::Signature.new(actual_html.root).signature
    expected_signature = Lorax::Signature.new(expected_html.root).signature
    actual_signature == expected_signature
  end
end
