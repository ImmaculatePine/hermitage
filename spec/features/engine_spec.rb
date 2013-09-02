require 'spec_helper'

describe 'engine', type: :feature do
  it 'adds hermitage javascript file to project' do
    visit '/assets/hermitage.js'
    page.status_code.should be 200
  end
end