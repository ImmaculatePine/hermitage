require 'spec_helper'

describe SimpleGallery::Defaults do
  describe '#to_hash' do
    it "returns hash with symbolized constants' names as keys" do
      SimpleGallery::Defaults.to_hash().should == {
        attribute_full_size: 'file.url',
        attribute_thumbnail: 'file.url(:thumbnail)'
      }
    end
  end
end