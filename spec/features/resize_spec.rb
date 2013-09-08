require 'spec_helper'
require 'features_helper'

describe 'resize', type: :feature, js: true do
  before(:each) do 
    visit images_path
    page.first('a[rel="hermitage"]').click
    page.should have_css('img.current')
  end

  shared_examples 'resize' do
    before(:each) do
      page.driver.resize(window_width, window_height)
      sleep(1) # Wait for animation complete
    end

    it 'adjusts image' do
      width('.current').should == expected_width
      height('.current').should == expected_height
      top('.current').should == expected_top
      left('.current').should == expected_left
    end

    it 'adjusts navigation buttons' do
      css('#navigation-left', 'line-height').should == expected_line_height
      css('#navigation-right', 'line-height').should == expected_line_height
    end    
  end

  describe 'make window smaller' do
    let(:window_width) { 300 }
    let(:window_height) { 300 }
    let(:expected_width) { 200 }
    let(:expected_height) { 200 }
    let(:expected_top) { 50 }
    let(:expected_left) { 50 }
    let(:expected_line_height) { '300px' }
    it_behaves_like 'resize'

    describe 'then make window larger' do
      let(:window_width) { 500 }
      let(:window_height) { 500 }
      let(:expected_width) { 256 }
      let(:expected_height) { 256 }
      let(:expected_top) { 122 }
      let(:expected_left) { 122 }
      let(:expected_line_height) { '500px' }
      it_behaves_like 'resize'
    end
  end
end