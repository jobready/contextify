module Contextify::Permission
  # @return true if there is a Policy class available to complement the permission
  def has_policy?
    policy_class
    true
  rescue NameError
    false
  end

  # The name of the policy class if one is present
  # @raise NameError if none present
  def policy_class
    [action_name.camelize, object_type, 'Policy'].join.constantize
  end

  # Apply this permission to the ability, directly via cancan
  # or via the Policy object if one is available
  #
  def apply_to(ability)
    if has_policy?
      policy = policy_class.new(ability)
      policy.apply!
    else
      ability.can(action_name.to_sym, object_type.constantize)
    end
  end
end
