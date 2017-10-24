require 'spec_helper'
require 'dummy/app/models/dummy'

describe Hermitage::ViewHelpers, type: :helper do
  # Reset Hermitage configs because they should not be shared among specs
  after(:each) { reset_configs }
  
  let(:template) { ActionView::Base.new }

  describe '#render_gallery_for' do
    let(:images) { Array.new(2) { |i| DummyImage.new(i.to_s) } }
    
    context 'no options' do
      let(:expected) { fixture_for('view_helpers/render_gallery_for/default.html') }
      subject { template.render_gallery_for images }
      it { should have_same_html_as expected }
    end

    context 'with options' do
      context 'original and thumbnail' do
        let(:images) { Array.new(2) { |i| DummyPhoto.new(i.to_s) } }
        let(:expected) { fixture_for('view_helpers/render_gallery_for/default.html') }

        context 'by string' do
          subject { template.render_gallery_for images, original: 'photo', thumbnail: 'photo(:thumbnail)' }
          it { should have_same_html_as expected }
        end

        context 'by proc' do
          subject { template.render_gallery_for images, original: -> item { item.photo }, thumbnail: -> item { item.photo(:thumbnail) } }
          it { should have_same_html_as expected }
        end
      end

      context 'title' do
        let(:expected) { fixture_for('view_helpers/render_gallery_for/with_title.html') }

        context 'by string' do
          subject { template.render_gallery_for images, title: 'description' }
          it { should have_same_html_as expected }
        end

        context 'by proc' do
          subject { template.render_gallery_for images, title: -> item { item.description } }
          it { should have_same_html_as expected }
        end
      end

      context 'list_tag and item_tag' do
        subject { template.render_gallery_for images, list_tag: :div, item_tag: :div }
        let(:expected) { fixture_for('view_helpers/render_gallery_for/custom_tags.html') }
        it { should have_same_html_as expected }
      end

      context 'list_class, item_class, link_class and image_class' do
        subject { template.render_gallery_for images, list_class: nil, item_class: nil, link_class: 'thumb link', image_class: 'thumb' }
        let(:expected) { fixture_for('view_helpers/render_gallery_for/custom_classes.html') }
        it { should have_same_html_as expected }
      end

      context 'each_slice' do
        subject { template.render_gallery_for images, each_slice: 1 }
        let(:expected) { fixture_for('view_helpers/render_gallery_for/each_slice.html') }
        it { should have_same_html_as expected }
      end
    end

    context 'with config' do
      before(:each) do
        Hermitage.configure :dummy_images do
          list_class 'images-thumbnails'
        end
      end

      context 'with default config' do
        let(:expected) { fixture_for('view_helpers/render_gallery_for/with_config/default.html') }
        subject { template.render_gallery_for images }
        it { should have_same_html_as expected }
      end

      context 'with overwritten defaults' do
        before(:each) do
          Hermitage.configure :default do
            list_class 'default-thumbnails'
            item_class 'span3'
          end
        end

        subject { template.render_gallery_for images }
        let(:expected) { fixture_for('view_helpers/render_gallery_for/with_config/with_overwritten_defaults.html') }
        it { should have_same_html_as expected }

        context 'and with options' do
          subject { template.render_gallery_for images, list_class: 'custom-thumbnails' }
          let(:expected) { fixture_for('view_helpers/render_gallery_for/with_config/with_overwritten_defaults_and_options.html') }
          it { should have_same_html_as expected }
        end
      end
    end
  end
end
