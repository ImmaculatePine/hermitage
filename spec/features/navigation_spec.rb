require 'spec_helper'

describe 'navigation', type: :feature, js: true do

  # Workaround for clicking exactly on the specified position of the element
  def click_at(selector, offset_x, offset_y)
    x = evaluate_script("$('#{selector}').position().left + $('#{selector}').outerWidth() * #{offset_x}")
    y = evaluate_script("$('#{selector}').position().top + $('#{selector}').outerHeight() * #{offset_y}")
    page.driver.click(x, y)
  end

  def click_at_left(selector)
    click_at(selector, 0.25, 0.5)
  end

  def click_at_right(selector)
    click_at(selector, 0.75, 0.5)
  end


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
