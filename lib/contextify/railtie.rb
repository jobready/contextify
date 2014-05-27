require 'contextify'
require 'rails'

module Contextify
  class Railtie < Rails::Railtie
    initializer 'contextify.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, Contextify
      end
    end
  end
end
