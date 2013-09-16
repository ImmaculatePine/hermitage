require 'spec_helper'
require 'dummy/app/models/dummy'

describe Hermitage::RailsRenderCore do

  let(:objects) { Array.new(3, DummyImage.new('path')) }
  let(:options) { {} }
  subject { Hermitage::RailsRenderCore.new(objects, options) }

  describe '#slice_objects' do
    let(:result) { subject.send(:slice_objects) }

    context 'no :each_slice option' do 
      it 'wraps objects in array' do
        result.should == [objects]
      end
    end

    context 'specified :each_slice option' do 
      let(:options) { { each_slice: 2 } }
      it 'slices objects into separate arrays' do
        result.should == [[objects[0], objects[1]], [objects[2]]]
      end
    end
  end

  describe '#render_link_for' do
    let(:object) { objects[0] }
    let(:result) { subject.send(:render_link_for, object) }
    it 'renders <a> tag with <img> tag inside' do
      result.should == "<a class=\"thumbnail\" href=\"#{object.file.url}\" rel=\"hermitage\"><img alt=\"Path thumbnail\" src=\"#{object.file.url(:thumbnail)}\" /></a>"
    end
  end

  describe '#value_for' do
    let(:object) { objects[0] }
    let(:result) { subject.send(:value_for, object, :original) }

    shared_examples 'value_for' do
      it 'returns path to original image' do
        result.should == '/assets/path-full.png'
      end
    end

    context ':original option is a String' do
      it_behaves_like 'value_for'
    end

    context ':original option is a Proc' do
      let(:options) { { original: -> item { item.file.url } } }
      it_behaves_like 'value_for'
    end
  end

end