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

  it 'has original image' do
    page.should have_css("div#hermitage img[src='/assets/0-full.png']") 
  end

  it 'has left navigation button' do
    page.should have_css("div#hermitage div#navigation-left")
  end

  it 'has right navigation button' do
    page.should have_css("div#hermitage div#navigation-right")
  end

  it 'has close button' do
    page.should have_css('div#hermitage div#close-button')
  end

  shared_examples 'close button' do
    it 'hides hermitage layer and removes everything from it' do
      page.should_not have_css('div#hermitage')
      page.find('div#hermitage', visible: false).all('*').length.should == 0
    end
  end

  describe 'click on the close button' do
    before(:each) { page.find('#close-button').click }
    it_behaves_like 'close button'
  end

  describe 'click on shadow in the viewer' do
    # Workaround for clicking at the shadow div
    before(:each) { evaluate_script "$('#overlay').click()" }
    it_behaves_like 'close button'
  end

end