require 'spec_helper'

describe Hermitage::Railtie do
  it 'adds #render_gallery_for method to ActionView::Base class' do
    ActionView::Base.new.respond_to?(:render_gallery_for).should be_true
  end
end