require 'spec_helper'
require 'dummy/app/models/dummy'

describe SimpleGallery::ViewHelpers, type: :helper do

  let(:template) { ActionView::Base.new }

  describe '#render_gallery_for' do
    let(:expected) { '<ul><li><a href="/assets/0-full.png" rel="simple_gallery"><img alt="0 thumbnail" src="/assets/0-thumbnail.png" /></a></li><li><a href="/assets/1-full.png" rel="simple_gallery"><img alt="1 thumbnail" src="/assets/1-thumbnail.png" /></a></li></ul>' }
    
    context 'no options' do
      let(:images) { Array.new(2) { |i| DummyImage.new(i.to_s) } }
      let(:result) { template.render_gallery_for images }

      it 'creates unordered list of previews that are links to full-size images' do
        result.should == expected
      end
    end

    context 'with options' do
      context 'attribute_full_size and attribute_thumbnail options' do
        let(:images) { Array.new(2) { |i| DummyPhoto.new(i.to_s) } }
        let(:result) { template.render_gallery_for images, attribute_full_size: 'photo', attribute_thumbnail: 'photo(:thumbnail)' }
        it 'uses specified attribute name' do
          result.should == expected
        end
      end
    end
  end
end