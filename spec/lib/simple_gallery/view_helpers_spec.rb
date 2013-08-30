require 'spec_helper'
require 'dummy/app/models/dummy'

describe SimpleGallery::ViewHelpers, type: :helper do

  let(:template) { ActionView::Base.new }

  describe '#render_gallery' do
    let(:expected) { '<ul><li><a href="0-full.png" rel="simple-gallery"><img alt="0 thumb" src="/images/0-thumb.png" /></a></li><li><a href="1-full.png" rel="simple-gallery"><img alt="1 thumb" src="/images/1-thumb.png" /></a></li></ul>' }
    
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