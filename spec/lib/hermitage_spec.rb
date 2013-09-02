require 'spec_helper'

describe Hermitage do
  it 'should has a version' do
    Hermitage::VERSION.should_not be_nil
  end

  it { should respond_to(:configs) }
  its(:configs) { should be_kind_of(Hash) }
  its(:configs) { should include(:default) }
end