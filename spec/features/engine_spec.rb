require 'spec_helper'

describe 'engine', type: :feature do
  it 'adds simple_gallery javascript file to project' do
    visit '/assets/simple_gallery.js'
    page.status_code.should be 200
  end
end