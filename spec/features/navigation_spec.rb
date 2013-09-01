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

  before(:each) do
     visit images_path
     page.first('a[href="/assets/1-full.png"]').click
  end

  describe 'by clicking on image' do
    # Wait for loading of current image
    before(:each) { page.should have_css('img.current') }

    describe 'at the right side' do
      before(:each) { click_at_right('img.current') }

      it 'shows next image and shows the first image after end of the gallery' do
        # Wait until 2-full.png image will be shown
        page.should have_no_css('img[src="/assets/1-full.png"]')
        page.should have_css('img[src="/assets/2-full.png"]')
        page.all('img.current').length.should == 1

        # Then click on it
        click_at_right('img.current')

        # Now there is only 0-full.png image on the screen
        page.should have_no_css('img[src="/assets/2-full.png"]')
        page.should have_css('img[src="/assets/0-full.png"]')
        page.all('img.current').length.should == 1
      end
    end

    describe 'at the left side' do
      before(:each) { click_at_left('img.current') }

      it 'shows previous image and shows the last image after first' do
        # Wait until 0-full.png image will be shown
        page.should have_no_css('img[src="/assets/1-full.png"]')
        page.should have_css('img[src="/assets/0-full.png"]')
        page.all('img.current').length.should == 1

        # Then click on it
        click_at_left('img.current')

        # Now there is only 2-full.png image on the screen
        page.should have_no_css('img[src="/assets/0-full.png"]')
        page.should have_css('img[src="/assets/2-full.png"]')
        page.all('img.current').length.should == 1
      end
    end

  end
  
end
