require 'spec_helper'

describe 'render gallery', type: :feature, js: true do

  before(:each) { visit images_path }

  it 'renders unordered list of links that contain images' do
    page.should have_selector('ul li a[rel=hermitage] img')
  end

  it 'has invisible layer for hermitage' do
    page.should have_css('div#hermitage', visible: false)
  end

  it 'fills images array' do
    images = evaluate_script('hermitage.images')
    expected = Array.new(3) do |i|
      {
        'source' => "/assets/#{i}-full.png",
        'loaded' => false
      }
    end
    images.should == expected
  end

end