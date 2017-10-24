# frozen_string_literal: true

require 'hermitage/view_helpers'

module Hermitage
  class Railtie < Rails::Railtie
    initializer 'hermitage.view_helpers' do |_app|
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
