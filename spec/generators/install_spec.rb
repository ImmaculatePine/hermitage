require 'spec_helper'
require 'genspec'

describe 'hermitage:install' do
  it 'generates configuration file at config/initializer' do
    subject.should generate('config/initializers/hermitage.rb')
  end
end