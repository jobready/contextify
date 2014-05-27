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

    # Delegates
    with_options to: :current_context do |context|
      context.delegate :entity,    allow_nil: true
      context.delegate :entity_id, allow_nil: true
      context.delegate :entity=
      context.delegate :grantable_roles
    end

    with_options to: :role, allow_nil: true do |role|
      role.delegate :name, prefix: true
      role.delegate :priority, prefix: true
      role.delegate :is_rto?
      role.delegate :is_admin?
      role.delegate :is_etd?
      role.delegate :is_aac?
      role.delegate :is_employer?
      role.delegate :is_school?
      role.delegate :is_admin_group?
      role.delegate :is_apprentice?
    end

    include Contextify::User
  end
end
