require 'spec_helper'

describe SimpleGallery::Defaults do
  describe '#to_hash' do
    it "returns hash with symbolized constants' names as keys" do
      SimpleGallery::Defaults.to_hash().should == {
        attribute_full_size: 'file.url',
        attribute_thumbnail: 'file.url(:thumbnail)',
        list_tag: :ul,
        item_tag: :li,
        list_class: 'thumbnails',
        item_class: 'span4',
        link_class: 'thumbnail',
        image_class: nil
      }
    end
  end
end