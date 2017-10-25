# frozen_string_literal: true

require 'spec_helper'

describe 'preload_neighbours', type: :feature, js: true do
  def click_at_image(index)
    page.first("a[href='/images/#{index}-full.png']").click
    sleep(1) # We want wait some time while animations and images are preloading
  end

  def images
    evaluate_script('hermitage.images')
  end

  shared_examples 'preloader' do
    it 'preloads proper images' do
      loaded = images.collect { |image| image['loaded'] }
      loaded.should == expected
    end
  end

  before(:each) { visit images_path }

  context 'preload enabled' do
    context 'loop enabled' do
      let(:expected) { Array.new(3, true) }

      context '1st image' do
        before(:each) { click_at_image(0) }
        it_behaves_like 'preloader'
      end

      context 'middle image' do
        before(:each) { click_at_image(1) }
        it_behaves_like 'preloader'
      end

      context 'last image' do
        before(:each) { click_at_image(2) }
        it_behaves_like 'preloader'
      end
    end

    context 'loop disabled' do
      before(:each) { evaluate_script('hermitage.looped = false') }

      context '1st image' do
        before(:each) { click_at_image(0) }
        let(:expected) { [true, true, false] }
        it_behaves_like 'preloader'
      end

      context 'middle image' do
        before(:each) { click_at_image(1) }
        let(:expected) { [true, true, true] }
        it_behaves_like 'preloader'
      end

      context 'last image' do
        before(:each) { click_at_image(2) }
        let(:expected) { [false, true, true] }
        it_behaves_like 'preloader'
      end
    end
  end

  context 'preload disabled' do
    before(:each) do
      evaluate_script('hermitage.preloadNeighbours = false')
      click_at_image(1)
    end

    let(:expected) { [false, true, false] }
    it_behaves_like 'preloader'
  end
end
