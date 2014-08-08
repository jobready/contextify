module Copper::Permission
  extend ActiveSupport::Concern

  class Naming
    def self.action_class_name(type, action)
      [action.camelize, type, 'Policy'].join
    end

    def self.class_name(type)
      [type, 'Policy'].join
    end
  end

  # @return true if there is a Policy class specific to the action available to complement the permission
  def has_action_policy?
    self.class.const_defined?(Naming.action_class_name(object_type, action_name))
  end

  # @return true if there is a Policy class for the type available to complement the permission
  def has_type_policy?
    self.class.const_defined?(Naming.class_name(object_type))
  end

  # The Policy class for the specific action if one is present
  # @raise NameError if none present
  def policy_action_class
    Naming.action_class_name(object_type, action_name).constantize
  end

  # The Policy class for the type if one is present
  # (Only used if there is no specific action class)
  # @raise NameError if none present
  def policy_type_class
    Naming.class_name(object_type).constantize
  end

  # Apply this permission to the ability, directly via cancan
  # or via the Policy object if one is available
  #
  def apply_to(ability)
    if has_action_policy?
      policy_action_class.new(ability).apply!
    elsif has_type_policy?
      policy_type_class.new(ability).apply!
    else
      ability.can(action_name.to_sym, object_type.constantize)
    end
  end
end
