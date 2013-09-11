require 'spec_helper'

describe Hermitage::Configurator do
  after(:each) { reset_configs }

  it 'can create new config' do
    Hermitage::Configurator.new(:new_config)
    Hermitage.configs.keys.should == [:default, :new_config]
  end

  it 'can change existing config' do
    Hermitage::Configurator.new(:default) do
      title 'description'
    end

    Hermitage.configs[:default][:title].should == 'description'
  end

  it 'responds to methods corresponing to options' do
    configurator = Hermitage::Configurator.new(:new_config)
    Hermitage::Defaults.constants.each do |c|
      configurator.should respond_to(c.downcase.to_sym)
    end
  end
end