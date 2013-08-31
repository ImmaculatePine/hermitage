# TODO: It seems that I'm doing something wrong here... Ok, see later when there will be more tests.
require 'spec_helper'

# In those tests dummy application is used
describe 'render gallery', type: :feature do

  it 'adds simple_gallery javascript file' do
    visit '/assets/simple_gallery.js'
    page.status_code.should be 200
  end

  describe 'visitor opens gallery page', js: true do

    before(:each) { visit images_path }

    it 'renders unordered list of links that contains images' do
      page.should have_selector('ul li a[rel=simple_gallery] img')
    end

    it 'has invisible layer for simple_gallery' do
      page.should have_css('div#simple_gallery', visible: false)
    end

    describe 'visitor clicks on image' do
      before(:each) { page.first('a[rel=simple_gallery]').click }

      it 'makes simple_gallery layer visible' do
        page.should have_css('div#simple_gallery') 
      end

      it 'has shadow overlay' do
        page.find('div#simple_gallery').should have_css('div#overlay') 
      end

      it 'has full size image' do
        page.find('div#simple_gallery').should have_css("img[src='/assets/0-full.png']") 
      end

      describe 'visitor clicks on shadow when gallery is opened' do
        # Workaround for clicking at the shadow div
        before(:each) { evaluate_script "$('#overlay').click()" }

        # I combined 2 test because we should wait when #simple_gallery will be invisible first.
        # Only after that we should check if it has no children.
        it 'hides simple_gallery layer and removes everything from it' do
          page.should_not have_css('div#simple_gallery')
          page.find('div#simple_gallery', visible: false).all('*').length.should == 0
        end
      end
    end

  end

end