# TODO: Roles should have some sort of heirarchy
# Eg; an admin role has higher privileges than a manager
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :contexts
  has_and_belongs_to_many :permissions
  accepts_nested_attributes_for :permissions

  scopify

  def self.names
    scoped.map(&:name)
  end
end

