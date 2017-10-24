require 'spec_helper'

describe Hermitage::Defaults do
  describe '#to_hash' do
    it "returns hash with symbolized constants' names as keys" do
      Hermitage::Defaults.to_hash().should == {
        original: 'file.url',
        thumbnail: 'file.url(:thumbnail)',
        title: nil,
        list_tag: :ul,
        item_tag: :li,
        list_class: 'thumbnails',
        item_class: 'span4',
        link_class: 'thumbnail',
        image_class: nil,
        each_slice: nil,
        with_checkboxes: false,
        with_photo_title: false,
        with_folder_links: false,
        checkbox_name: :photo_check,
        checkbox_value_attribute: :id,
        folder_association_name: :folder,
        folder_link_class: :heading
      }
    end
  end
end