require 'spec_helper'

describe 'render gallery', type: :feature, js: true do

  before(:each) { visit images_path }

  it 'renders unordered list of links that contain images' do
    page.should have_selector('ul li a[rel=simple_gallery] img')
  end

  it 'has invisible layer for simple_gallery' do
    page.should have_css('div#simple_gallery', visible: false)
  end

  it 'fills images array' do
    evaluate_script("images").should == ['/assets/0-full.png', '/assets/1-full.png', '/assets/2-full.png']
  end

end