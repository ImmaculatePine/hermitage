require 'spec_helper'
require 'features_helper'

describe 'viewer_customization', type: :feature, js: true do

  let(:before_click) { nil }

  before(:each) do
    visit images_path
    evaluate_script(js)
    before_click.call() if before_click
    page.first('a[rel=hermitage]').click
    page.should have_css('div#hermitage img.current')
    # There will be sleep(1) in tests where we should wait until fade in animation is ended
  end

  context 'zIndex' do
    let(:js) { 'hermitage.zIndex = 5'}
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

  context 'navigationButton.enabled' do
    let(:js) { 'hermitage.navigationButton.enabled = false' }
    it { should_not have_css('#navigation-left') }
    it { should_not have_css('#navigation-right') }
  end

  context 'navigationButton.fontSize' do
    let(:js) { 'hermitage.navigationButton.fontSize = 10'}
    it { css('#navigation-left', 'font-size').should == '10px' }
    it { css('#navigation-right', 'font-size').should == '10px' }
  end

  context 'navigationButton.fontFamily' do
    let(:js) { 'hermitage.navigationButton.fontFamily = "monospace"'}
    it { css('#navigation-left', 'font-family').should == 'monospace' }
    it { css('#navigation-right', 'font-family').should == 'monospace' }
  end

  context 'navigationButton.color' do
    let(:js) { 'hermitage.navigationButton.color = "#000"'}
    it { css('#navigation-left', 'color').should == 'rgb(0, 0, 0)' }
    it { css('#navigation-right', 'color').should == 'rgb(0, 0, 0)' }
  end

  context 'navigationButton.backgroundColor' do
    let(:js) { 'hermitage.navigationButton.backgroundColor = "#000"'}
    it { css('#navigation-left', 'background-color').should == 'rgb(0, 0, 0)' }
    it { css('#navigation-right', 'background-color').should == 'rgb(0, 0, 0)' }
  end

  context 'navigationButton.borderColor' do
    let(:js) { 'hermitage.navigationButton.borderColor = "#000"'}

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

  context 'navigationButton.width' do
    let(:js) { 'hermitage.navigationButton.width = 100' }
    it { css('#navigation-left', 'width').should == '100px' }
    it { css('#navigation-right', 'width').should == '100px' }
  end

  context 'navigationButton.borderRadius' do
    let(:js) { 'hermitage.navigationButton.borderRadius = 5' }

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
  
  context 'navigationButton.margin' do
    let(:js) { 'hermitage.navigationButton.margin = 30' }
    before(:each) { sleep(1) }
    it { css('#navigation-left', 'left').should == "#{left('.current') - 30 - width('#navigation-left')}px" }
    it { css('#navigation-right', 'left').should == "#{left('.current') + width('.current') + 30}px" }
  end

  context 'closeButton.enabled' do
    let(:js) { 'hermitage.closeButton.enabled = false' }
    it { should_not have_css('#close-button') }
  end
  
  context 'closeButton.text' do
    let(:js) { 'hermitage.closeButton.text = "Close"' }
    it { text('#close-button').should == 'Close' }
  end

  context 'closeButton.color' do
    let(:js) { 'hermitage.closeButton.color = "#777"' }
    it { css('#close-button', 'color').should == 'rgb(119, 119, 119)' }
  end

  context 'closeButton.fontSize' do
    let(:js) { 'hermitage.closeButton.fontSize = 10' }
    it { css('#close-button', 'font-size').should == '10px' }
  end

  context 'closeButton.fontFamily' do
    let(:js) { 'hermitage.closeButton.fontFamily = "monospace"'}
    it { css('#close-button', 'font-family').should == 'monospace' }
  end

  context 'windowPadding.x' do
    let(:js) { 'hermitage.windowPadding.x = 100'}
    let(:before_click) { Proc.new{ page.driver.resize(500, 1000) } }

    it 'scales the image' do
      width('.current').should == 176
      height('.current').should == 176
    end
  end

  context 'windowPadding.y' do
    let(:js) { 'hermitage.windowPadding.y = 100'}
    let(:before_click) { Proc.new{ page.driver.resize(1000, 400) } }

    it 'scales the image' do
      width('.current').should == 200
      height('.current').should == 200
    end
  end

  shared_examples 'image scaled to the minimum allowed size' do
    it 'scales the image to the minimum allowed size' do
      width('.current').should == 200
      height('.current').should == 200
    end
  end

  context 'minimumSize.width' do
    let(:js) { 'hermitage.minimumSize.width = 200'}
    let(:before_click) { Proc.new{ page.driver.resize(300, 1000) } }
    it_behaves_like 'image scaled to the minimum allowed size'
  end

  context 'minimumSize.width' do
    let(:js) { 'hermitage.minimumSize.height = 200'}
    let(:before_click) { Proc.new{ page.driver.resize(1000, 250) } }
    it_behaves_like 'image scaled to the minimum allowed size'
  end

end