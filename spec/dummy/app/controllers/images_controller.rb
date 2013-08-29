require 'dummy'

class ImagesController < ActionController::Base
  def index
    @images = Array.new(2) { |i| DummyImage.new(i.to_s) }
  end
end