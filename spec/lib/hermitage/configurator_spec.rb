require 'spec_helper'

describe Hermitage::Configurator do
  after(:each) { reset_configs }

  describe '.new' do
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
  end

  describe '#respond_to?' do
    it 'responds to methods corresponing to options' do
      configurator = Hermitage::Configurator.new(:new_config)
      Hermitage::Defaults.constants.each do |c|
        configurator.should respond_to(c.downcase.to_sym)
      end
    end
  end

  describe '.options_for' do
    it 'merges default config with objects config and with options hash' do
      Hermitage.configure :images do
        title 'image_title'
        list_class 'image-list'
      end
      Image = Class.new
      objects = [Image.new]
      result = Hermitage::Configurator.options_for(objects, { title: 'title' })
      result.should == Hermitage::Defaults.to_hash.merge({ list_class: 'image-list', title: 'title' })
    end
  end
end