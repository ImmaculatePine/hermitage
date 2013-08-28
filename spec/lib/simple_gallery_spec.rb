require 'spec_helper'

describe SimpleGallery do
  it 'should has a version' do
    SimpleGallery::VERSION.should_not be_nil
  end
end