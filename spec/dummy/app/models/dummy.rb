class DummyBase
  def initialize(name)
    @name = name
  end

  protected
  
  # This method MAGICALLY returns name of image according to given options
  def magic(options = nil)
    options == nil ? "/assets/#{@name}-full.png" : "/assets/#{@name}-#{options}.png"
  end
end

class DummyImage < DummyBase
  def image(options = nil)
    magic(options)
  end
end

class DummyFile < DummyBase
  def file(options = nil)
    magic(options)
  end
end