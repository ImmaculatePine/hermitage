require 'dummy'

class ImagesController < ActionController::Base
  def index
    @images = Array.new(3) { |i| DummyImage.new(i.to_s) }
    render layout: 'application'
  end
end