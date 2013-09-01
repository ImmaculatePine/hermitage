require 'spec_helper'

describe 'viewer', type: :feature, js: true do

  before(:each) do
    visit images_path
    page.first('a[rel=simple_gallery]').click
  end

  it 'makes simple_gallery layer visible' do
    page.should have_css('div#simple_gallery')
  end

  it 'has shadow overlay' do
    page.should have_css('div#simple_gallery div#overlay') 
  end

  it 'has full size image' do
    page.should have_css("div#simple_gallery img[src='/assets/0-full.png']") 
  end

  describe 'visitor clicks on shadow in the viewer' do
    # Workaround for clicking at the shadow div
    before(:each) { evaluate_script "$('#overlay').click()" }

    it 'hides simple_gallery layer and removes everything from it' do
      page.should_not have_css('div#simple_gallery')
      page.find('div#simple_gallery', visible: false).all('*').length.should == 0
    end
  end

end