require 'active_support/concern'

module Contextify
  module Context
    extend ActiveSupport::Concern

    included do
      # Find the contexts for the given entity (may be nil)
      def self.for(_entity)
        # TODO: Spec this
        if _entity.present?
          where { entity == _entity }.first
        else
          where { entity_id == nil }.first
        end
      end

      # Finds all contexts if entity is nil or the contexts just for the given
      # entity otherwise
      def self.all_for(_entity)
        if _entity == Etd.instance
          where({})
        else
          where { entity_type == _entity.class.name and entity_id == _entity.id }
        end
      end
    end

    # FIXME: While this is an improvement on earlier designs
    # it probably should be more genericised such that 
    # there are only roles such as admin, officer etc
    # and that these behave differently in different contexts
    # TODO: Spec this
    def grantable_roles
      Role.all
    end

    def description
      [role_name, entity_name].compact.join(' at ')
    end
  end
end
