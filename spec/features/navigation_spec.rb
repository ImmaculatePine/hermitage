require 'spec_helper'
require 'features_helper'

describe 'navigation', type: :feature, js: true do

  shared_examples 'navigation to next' do
    before(:each) { click_action.call() }

    it 'shows next image and shows the first image after end of the gallery' do
      # Wait until 2-full.png image will be shown
      page.should have_no_css('img[src="/assets/1-full.png"]')
      page.should have_css('img[src="/assets/2-full.png"]')
      page.all('img.current').length.should == 1

      # Then click
      click_action.call()

      # Now there is only 0-full.png image on the screen
      page.should have_no_css('img[src="/assets/2-full.png"]')
      page.should have_css('img[src="/assets/0-full.png"]')
      page.all('img.current').length.should == 1
    end
  end

  shared_examples 'navigation to previous' do
    before(:each) { click_action.call() }

    it 'shows previous image and shows the last image after first' do
      # Wait until 0-full.png image will be shown
      page.should have_no_css('img[src="/assets/1-full.png"]')
      page.should have_css('img[src="/assets/0-full.png"]')
      page.all('img.current').length.should == 1

      # Then click
      click_action.call()

      # Now there is only 2-full.png image on the screen
      page.should have_no_css('img[src="/assets/0-full.png"]')
      page.should have_css('img[src="/assets/2-full.png"]')
      page.all('img.current').length.should == 1
    end
  end

  context 'with loop' do
    before(:each) do
      visit images_path
      page.first('a[href="/assets/1-full.png"]').click
      page.should have_css('img.current') # Wait for loading before testing
    end

    describe 'by clicking on image' do
      describe 'at the right side' do
        let(:click_action) { Proc.new { click_at_right('img.current') } }
        it_behaves_like 'navigation to next'
      end

      describe 'at the left side' do
        let(:click_action) { Proc.new { click_at_left('img.current') } }
        it_behaves_like 'navigation to previous'
      end
    end

    describe 'by clicking on navigation button' do
      describe 'right' do
        let(:click_action) { Proc.new { page.find('#navigation-right').click() } }
        it_behaves_like 'navigation to next'
      end

      describe 'left' do
        let(:click_action) { Proc.new { page.find('#navigation-left').click() } }
        it_behaves_like 'navigation to previous'
      end
    end
  end

  context 'without loop' do
    before(:each) do
      visit images_path
      evaluate_script('hermitage.looped = false')
      page.first("a[href='/assets/#{image}-full.png']").click
      page.should have_css('img.current')
    end

    describe 'first image' do
      let(:image) { "0" }
      it { page.should_not have_css('#navigation-left') }
      it { page.should have_css('#navigation-right') }
    end

    describe 'middle image' do
      let(:image) { "1" }
      it { page.should have_css('#navigation-left') }
      it { page.should have_css('#navigation-right') }
    end

    describe 'last image' do
      let(:image) { "2" }
      it { page.should have_css('#navigation-left') }
      it { page.should_not have_css('#navigation-right') }
    end
  end

end
