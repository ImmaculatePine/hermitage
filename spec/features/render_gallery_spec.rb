# TODO: It seems that I'm doing something wrong here... Ok, see later when there will be more tests.
require 'spec_helper'

# In those tests dummy application is used
describe 'render gallery', type: :feature do

  describe 'visitor opens gallery page' do

    before(:each) { visit images_path }

    it 'renders unordered list of links that contains images' do
      page.should have_selector('ul li a img')
    end
  end
end