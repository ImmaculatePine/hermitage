# TODO: It seems that I'm doing something wrong here... Ok, see later when there will be more tests.
require 'spec_helper'

# In those tests dummy application is used
describe 'render gallery', type: :feature do

  it 'adds simple_gallery javascript file' do
    visit '/assets/simple_gallery.js'
    page.status_code.should be 200
  end

  describe 'visitor opens gallery page' do

    before(:each) { visit images_path }

    it 'renders unordered list of links that contains images' do
      page.should have_selector('ul li a img')
    end
  end
end