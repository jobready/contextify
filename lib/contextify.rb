require "contextify/version"
require "contextify/railtie"
require "contextify/context"

module Contextify
  class NoCurrentContext < StandardError
    def message
       'User has no current context set'
    end
  end

  def contextify(options = {})
    has_many :contexts, after_add: :set_current_context, after_remove: :unset_current_context
    belongs_to :current_context, class_name: 'Context', autosave: true
    has_one :role, through: :current_context
    has_many :permissions, through: :role
    validates_associated :contexts, message: 'User already exists in that context'
    include Contextify::Context
  end
end
