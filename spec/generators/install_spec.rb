require 'spec_helper'
require 'genspec'

describe 'simple_gallery:install' do 
  it 'generates configuration file at config/initializer' do 
    subject.should generate('config/initializers/simple_gallery.rb') 
  end
end