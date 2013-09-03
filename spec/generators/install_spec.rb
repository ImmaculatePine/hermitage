require 'spec_helper'
require 'genspec'

describe 'hermitage:install' do
  
  within_source_root do
    FileUtils.mkdir_p 'app/assets/javascripts'
    FileUtils.touch 'app/assets/javascripts/application.js'
  end

  it 'generates configuration file at config/initializer' do
    subject.should generate('config/initializers/hermitage.rb')
  end

  it "should inject a require into application.js file" do
    subject.should inject_into_file('app/assets/javascripts/application.js', "\n//= require hermitage", after: %r{^//= require +['"]?jquery['"]?$})
  end
end
  