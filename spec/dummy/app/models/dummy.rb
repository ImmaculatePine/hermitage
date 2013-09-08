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

class DummyFile < DummyBase
  def url(options = nil)
    magic(options)
  end
end

class DummyImage
  attr_accessor :file
  def initialize(name)
    @name = name
    @file = DummyFile.new(name)
  end

  def description
    "description of #{@name}"
  end
end

class DummyPhoto < DummyBase
  def photo(options = nil)
    magic(options)
  end
end

