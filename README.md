# Contextify

User Contexts/Roles/Permissions

## Installation

Add this line to your application's Gemfile:

    gem 'contextify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contextify

## Usage

``ruby
user = User.last
user.add_context!(:admin, Entity.first)
user.has_context?(:admin, Entity.first)
user.entity
user.has_role?(:admin)
user.permissions
user.has_permission?(:manage, User)
```

## Contributing

1. Fork it ( http://github.com/jobready/contextify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
