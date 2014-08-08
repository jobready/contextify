module Contextify
  module Role
    extend ActiveSupport::Concern

    included do
      def self.names
        scoped.map(&:name)
      end
    end
  end
end
