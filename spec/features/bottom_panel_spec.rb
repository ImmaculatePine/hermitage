require 'spec_helper'
require 'features_helper'

describe 'bottom_panel', type: :feature, js: true do
  before(:each) do 
    Hermitage.configure :default do title 'description' end
    visit images_path
    page.first('a[rel="hermitage"]').click
    page.should have_css('img.current')
  end

  # I don't want any influence of this config to another tests
  after(:each) { reset_configs }

  it 'has bottom panel' do
    page.should have_css('#hermitage .bottom-panel')
  end

  it 'has description of image' do
    page.should have_css('#hermitage .bottom-panel .text')
    jquery_text('#hermitage .bottom-panel .text').should == 'description of 0'
  end

  it 'affects upon image size and position' do
    top('.current').should == 221 # if window height is 768px
  end

end