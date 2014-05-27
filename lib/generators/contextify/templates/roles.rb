class Role < ActiveRecord::Base
  has_and_belongs_to_many :contexts
  has_many :permissions
end

