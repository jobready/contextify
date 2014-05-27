# Describes the capacity or "role" a user has within a certain context
# For example, a user may be an officer at a an RTO (the entity) and an admin in other cases giving them two contexts
class Context < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :entity, polymorphic: true

  delegate :name, to: :role,     prefix: true, allow_nil: true
  delegate :name, to: :entity,   prefix: true, allow_nil: true
  delegate :priority, to: :role, prefix: true

  validates :role_id, uniqueness: { scope: [:user_id, :entity_id, :entity_type] }
  validates :role_id, presence: true
  validates :entity_type, uniqueness: { scope: :user_id, 
                                      message: 'must be unique. The user has already been added to an Entity of that type' }

  validates_with ContextEntityAdminCountValidator
  include Contextify::Context
end

