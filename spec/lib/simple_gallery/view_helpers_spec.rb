require 'spec_helper'

describe SimpleGallery::ViewHelpers, type: :helper do

  # Dummy classes for testing
  # TODO: Think about moving it somewhere else
  class DummyBase
    def initialize(name)
      @name = name
    end

    protected
    
    # This method MAGICALLY returns name of image according to given options
    def magic(options = nil)
      options == nil ? "#{@name}-full.png" : "#{@name}-#{options}.png"
    end
  end

  class DummyImage < DummyBase
    def image(options = nil)
      magic(options)
    end
  end

  class DummyFile < DummyBase
    def file(options = nil)
      magic(options)
    end
  end

  let(:template) { ActionView::Base.new }

  describe '#render_gallery' do
    let(:expected) { '<ul><li><a href="0-full.png"><img alt="0 thumb" src="/images/0-thumb.png" /></a></li><li><a href="1-full.png"><img alt="1 thumb" src="/images/1-thumb.png" /></a></li></ul>' }
    
    context 'no options' do
      let(:images) { Array.new(2) { |i| DummyImage.new(i.to_s) } }
      let(:result) { template.render_gallery(images) }

      it 'creates unordered list of previews that are links to full-size images' do
        result.should == expected
      end
    end

    context 'with options' do
      context 'attribute' do
        let(:images) { Array.new(2) { |i| DummyFile.new(i.to_s) } }
        let(:result) { template.render_gallery(images, attribute: :file) }
        it 'uses specified attribute name' do
          result.should == expected
        end
      end
    end
  end
end