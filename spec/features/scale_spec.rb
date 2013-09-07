require 'spec_helper'
require 'features_helper'

describe 'scale', type: :feature, js: true do

  before(:each) do
    visit images_path
    page.driver.resize(window_width, window_height) 
    page.first('a[rel=hermitage]').click
    page.should have_css('img.current')
  end

  context 'exceed the bounds of window by width' do
    let(:window_width) { 300 }
    let(:window_height) { 1000 }

    it 'scales the image' do
      width('.current').should == 200
      height('.current').should == 200
    end
  end

  context 'exceed the bounds of window by height' do
    let(:window_width) { 1000 }
    let(:window_height) { 200 }

    it 'scales the image' do
      width('.current').should == 200
      height('.current').should == 200
    end
  end

  context 'exceed the bounds of window by both dimensions' do
    let(:window_width) { 250 }
    let(:window_height) { 300 }

    it 'scales the image to the minimum scale coefficient' do
      width('.current').should == 150
      height('.current').should == 150
    end
  end

  context 'window is smaller than minimum allowed size' do

    shared_examples 'minimum allowed size' do
      it 'scales the image to the minimal allowed size' do
        width('.current').should == 100
        height('.current').should == 100
      end
    end

    context 'by width' do
      let(:window_width) { 150 }
      let(:window_height) { 1000 }
      it_behaves_like 'minimum allowed size'
    end

    context 'by height' do
      let(:window_width) { 1000 }
      let(:window_height) { 90 }
      it_behaves_like 'minimum allowed size'
    end

    context 'by both dimensions' do
      let(:window_width) { 150 }
      let(:window_height) { 90 }
      it_behaves_like 'minimum allowed size'
    end
  end

end