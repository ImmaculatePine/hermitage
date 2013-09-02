require 'spec_helper'

describe 'viewer', type: :feature, js: true do

  before(:each) do
    visit images_path
    page.first('a[rel=hermitage]').click
  end

  it 'makes hermitage layer visible' do
    page.should have_css('div#hermitage')
  end

  it 'has shadow overlay' do
    page.should have_css('div#hermitage div#overlay') 
  end

  it 'has full size image' do
    page.should have_css("div#hermitage img[src='/assets/0-full.png']") 
  end

  it 'has left navigation button' do
    page.should have_css("div#hermitage div#navigation-left")
  end

  it 'has right navigation button' do
    page.should have_css("div#hermitage div#navigation-right")
  end

  describe 'visitor clicks on shadow in the viewer' do
    # Workaround for clicking at the shadow div
    before(:each) { evaluate_script "$('#overlay').click()" }

    it 'hides hermitage layer and removes everything from it' do
      page.should_not have_css('div#hermitage')
      page.find('div#hermitage', visible: false).all('*').length.should == 0
    end
  end

end