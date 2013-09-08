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

  context 'darkening.opacity' do
    let(:js) { 'hermitage.darkening.opacity = 0.5'}
    before(:each) { sleep(1) }
    it { css('#overlay', 'opacity').should == '0.5' }
  end

  context 'darkening.styles' do
    let(:js) { 'hermitage.darkening.styles = { backgroundColor: "#FAFAFA" }' }
    it { css('#overlay', 'background-color').should == 'rgb(250, 250, 250)' }
  end

  context 'navigationButtons.enabled' do
    let(:js) { 'hermitage.navigationButtons.enabled = false' }
    it { should_not have_css('#navigation-left') }
    it { should_not have_css('#navigation-right') }
  end

  context 'navigationButtons.styles' do
    let(:js) { 'hermitage.navigationButtons.styles = { backgroundColor: "#000", width: "100px" }'}
    it { css('#navigation-left', 'background-color').should == 'rgb(0, 0, 0)' }
    it { css('#navigation-left', 'width').should == '100px' }
    it { css('#navigation-right', 'background-color').should == 'rgb(0, 0, 0)' }
    it { css('#navigation-right', 'width').should == '100px' }
  end

  context 'navigationButtons.next.styles' do
    let(:js) { 'hermitage.navigationButtons.next.styles = { width: "100px" }'}
    it { css('#navigation-left', 'width').should == '50px' }
    it { css('#navigation-right', 'width').should == '100px' }
  end

  context 'navigationButtons.previous.styles' do
    let(:js) { 'hermitage.navigationButtons.previous.styles = { width: "100px" }'}
    it { css('#navigation-left', 'width').should == '100px' }
    it { css('#navigation-right', 'width').should == '50px' }
  end

  context 'navigationButtons.next.text' do
    let(:js) { 'hermitage.navigationButtons.next.text = ">"'}
    it { jquery_text('#navigation-right').should == '>' }
  end

  context 'navigationButtons.previous.text' do
    let(:js) { 'hermitage.navigationButtons.previous.text = "<"'}
    it { jquery_text('#navigation-left').should == '<' }
  end

  context 'closeButton.enabled' do
    let(:js) { 'hermitage.closeButton.enabled = false' }
    it { should_not have_css('#close-button') }
  end
  
  context 'closeButton.text' do
    let(:js) { 'hermitage.closeButton.text = "Close"' }
    it { jquery_text('#close-button').should == 'Close' }
  end

  context 'closeButton.styles' do
    let(:js) { 'hermitage.closeButton.styles = { color: "#777" }' }
    it { css('#close-button', 'color').should == 'rgb(119, 119, 119)' }
  end

  context 'image.styles' do
    let(:js) { 'hermitage.image.styles = { border: "5px solid #000" }' }
    it 'sets all borders width to 5px'  do
      css('.current', 'border-top-width').should == '5px'
      css('.current', 'border-right-width').should == '5px'
      css('.current', 'border-bottom-width').should == '5px'
      css('.current', 'border-left-width').should == '5px'
    end
  end

  context 'bottomPanel.styles' do
    let(:js) { 'hermitage.bottomPanel.styles = { backgroundColor: "#777" }' }
    it { css('#hermitage .bottom-panel', 'background-color').should == 'rgb(119, 119, 119)' }
  end

  context 'bottomPanel.text.styles' do
    let(:js) { 'hermitage.bottomPanel.text.styles = { textAlign: "left" }' }
    it { css('#hermitage .bottom-panel .text', 'text-align').should == 'left' }
  end

  shared_examples 'image scaled to the minimum allowed size' do
    it 'scales the image to the minimum allowed size' do
      width('.current').should == 200
      height('.current').should == 200
    end
  end

  context 'minimumSize.width' do
    let(:js) { 'hermitage.minimumSize.width = 200'}
    let(:before_click) { Proc.new{ page.driver.resize(250, 1000) } }
    it_behaves_like 'image scaled to the minimum allowed size'
  end

  context 'minimumSize.width' do
    let(:js) { 'hermitage.minimumSize.height = 200'}
    let(:before_click) { Proc.new{ page.driver.resize(1000, 150) } }
    it_behaves_like 'image scaled to the minimum allowed size'
  end

end