module FixturesHelper
  def fixture_for(path)
    File.read("#{Dir.pwd}/spec/fixtures/#{prefix}/#{path}")
  end

  private

  def prefix
    if Rails::VERSION::MAJOR == 3
      'rails-3.2'
    else
      'rails-4.x'
    end
  end
end
