require 'spec_helper'
require 'features_helper'

describe 'viewer_customization', type: :feature, js: true do

  before(:each) do
    visit images_path
    evaluate_script(js)
    page.first('a[rel=hermitage]').click
    page.should have_css('div#hermitage img.current')
    # There will be sleep(1) in tests where we should wait until fade in animation is ended
  end

  context 'z_index' do
    let(:js) { 'hermitage.z_index = 5'}
    it { css('#hermitage', 'z-index').should == '5' }
  end

  context 'darkening.opacity' do
    let(:js) { 'hermitage.darkening.opacity = 0.5'}
    before(:each) { sleep(1) }
    it { css('#overlay', 'opacity').should == '0.5' }
  end

  context 'darkening.color' do
    let(:js) { 'hermitage.darkening.color = "#FAFAFA"' }
    it { css('#overlay', 'background-color').should == 'rgb(250, 250, 250)' }
  end

  context 'navigation_button.enabled' do
    let(:js) { 'hermitage.navigation_button.enabled = false' }
    it { should_not have_css('#navigation-left') }
    it { should_not have_css('#navigation-right') }
  end

  context 'navigation_button.color' do
    let(:js) { 'hermitage.navigation_button.color = "#000"'}

    shared_examples 'navigation button' do
      it 'sets border color' do
        css(selector, 'border-top-color').should == 'rgb(0, 0, 0)'
        css(selector, 'border-right-color').should == 'rgb(0, 0, 0)'
        css(selector, 'border-bottom-color').should == 'rgb(0, 0, 0)'
        css(selector, 'border-left-color').should == 'rgb(0, 0, 0)'
      end  
    end
    
    context 'left' do
      let(:selector) { '#navigation-left' }
      it_behaves_like 'navigation button'
    end

    context 'right' do
      let(:selector) { '#navigation-right' }
      it_behaves_like 'navigation button'
    end
  end

  context 'navigation_button.width' do
    let(:js) { 'hermitage.navigation_button.width = 100' }
    it { css('#navigation-left', 'width').should == '100px' }
    it { css('#navigation-right', 'width').should == '100px' }
  end

  context 'navigation_button.border_radius' do
    let(:js) { 'hermitage.navigation_button.border_radius = 5' }

    it 'sets border radiuses for left button' do
      css('#navigation-left', 'border-top-left-radius').should == '5px'
      css('#navigation-left', 'border-bottom-left-radius').should == '5px'
      css('#navigation-left', 'border-top-right-radius').should == '0px'
      css('#navigation-left', 'border-bottom-right-radius').should == '0px'
    end
    
    it 'sets border radiuses for right button' do
      css('#navigation-right', 'border-top-left-radius').should == '0px'
      css('#navigation-right', 'border-bottom-left-radius').should == '0px'
      css('#navigation-right', 'border-top-right-radius').should == '5px'
      css('#navigation-right', 'border-bottom-right-radius').should == '5px'
    end
  end
  
  context 'navigation_button.margin' do
    let(:js) { 'hermitage.navigation_button.margin = 30' }
    before(:each) { sleep(1) }
    it { css('#navigation-left', 'left').should == "#{left('.current') - 30 - width('#navigation-left')}px" }
    it { css('#navigation-right', 'left').should == "#{left('.current') + width('.current') + 30}px" }
  end

  context 'close_button.enabled' do
    let(:js) { 'hermitage.close_button.enabled = false' }
    it { should_not have_css('#close_button') }
  end
  
  context 'close_button.text' do
    let(:js) { 'hermitage.close_button.text = "Close"' }
    it { text('#close_button').should == 'Close' }
  end

  context 'close_button.color' do
    let(:js) { 'hermitage.close_button.color = "#777"' }
    it { css('#close_button', 'color').should == 'rgb(119, 119, 119)' }
  end

  context 'close_button.font_size' do
    let(:js) { 'hermitage.close_button.font_size = "10"' }
    it { css('#close_button', 'font-size').should == '10px' }
  end

end