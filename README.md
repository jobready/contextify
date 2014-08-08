# Copper

User Permissions and Policies. Named after the aussie word for police officer (https://www.youtube.com/watch?v=tKNOgX-u8ao)

## Installation

Add this line to your application's Gemfile:

    gem 'copper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install copper

## Permission module and Policies

Cancancan provides an Ability class to control permissions but it is limited in its ability to define
more specific controls around certain permissions. So we introduce the Permission module and Policies.

You can create your own Permission class (say an ActiveRecord model) which stores permissions (specifically
the `object_type` and `action_name`.

For example:

    class Permission < ActiveRecord::Base
      include Copper::Permission
    end

    Permission.create(
      object_type: 'User',
      action_name: 'manage',
      description: 'Allow management of users'
    )

Modify your cancancan Ability class as follows (or similar, the key is applying the permissions to the ability):

    def initialize(user)
      if user.is_admin?
        can :manage, :all
      else
        user.permissions.each do |permission|
          permission.apply_to(self)
        end
      end
    end

From here everything will work as normal, BUT lets say you want to limit the managing of users to a certain group.
You could create a policy:

    class UserPolicy
      def initialize(ability)
        @ability = ability
      end

      def apply!
        @ability.can(:manage, User, group_id: groups.pluck(:id))
      end

      def groups
        @ability.user.groups
      end
    end

This policy is called a Type Policy as it applies to any action taken on that Type. You can also define Action Policies
which will overide the type policy for the given action.

    class DestroyUserPolicy
      # ...destroy specific logic
    end

## Contributing

1. Fork it ( http://github.com/jobready/copper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
