require 'spec_helper'

describe SimpleGallery::Railtie do
  it 'adds #render_gallery method to ActionView::Base class' do
    ActionView::Base.new.respond_to?(:render_gallery).should be_true
  end
end