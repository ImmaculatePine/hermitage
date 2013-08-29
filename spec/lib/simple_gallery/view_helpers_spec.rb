require 'spec_helper'

describe SimpleGallery::ViewHelpers, type: :helper do

  # Dummy class for testing
  # TODO: Think about moving it somewhere else
  class Image
    def initialize(name)
      @name = name
    end
    
    def image(options = nil)
      options == nil ? "#{@name}-full.png" : "#{@name}-#{options}.png"
    end
  end

  let(:template) { ActionView::Base.new }

  describe '#render_gallery' do
    let(:images) { Array.new(2) { |i| Image.new(i.to_s) } }
    let(:result) { template.render_gallery(images) }
    
    it 'creates unordered list of previews that are links to full-size images' do
      result.should == '<ul><li><a href="0-full.png"><img alt="0 thumb" src="/images/0-thumb.png" /></a></li><li><a href="1-full.png"><img alt="1 thumb" src="/images/1-thumb.png" /></a></li></ul>'
    end
  end
end