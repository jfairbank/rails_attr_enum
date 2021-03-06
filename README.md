# RailsAttrEnum

Enums for Rails attributes. Specify enumeration identifiers for int attributes
on your Rails models. Includes constants for your identifiers, validation,
model class scopes, and instance helper methods.

## Build Status
[![Build Status](https://travis-ci.org/jfairbank/rails_attr_enum.png?branch=master)](https://travis-ci.org/jfairbank/rails_attr_enum)

## Installation
Add to your Gemfile:

```ruby
gem 'rails_attr_enum'
```

And then run bundler:

    $ bundle install

## Usage

Here's an example given a class `User` with an attribute `role`:

```ruby
# Example model User for a blog app
class User < ActiveRecord::Base
  extend RailsAttrEnum
  attr_enum :role, :admin, :editor, :author, :user
end

# Creates module `User::Role` with constants for each possible value
User::Role::ADMIN  == 0
User::Role::EDITOR == 1
User::Role::AUTHOR == 2
User::Role::USER   == 3
```

[View other ways to define and customize enums](https://github.com/jfairbank/rails_attr_enum/wiki/Adding-an-Enum-to-a-Model)

## Helpers for Model Instances

A couple helpers methods are added to the model and the enum attribute.

Get the "display" label for the current value with the `display_*` method:

```ruby
user = User.new(role: User::Role::ADMIN)
user.display_role == 'Admin'
```

You can check for a specific value with a query `*?` method:

```ruby
user = User.new(role: User::Role::AUTHOR)
user.role.admin?  # false
user.role.editor? # false
user.role.author? # true
user.role.user?   # false
```

The query method works via a forwarding class, so the normal `role` and `role=`
methods should work as expected.

**NOTE**: one caveat to this is if you try to use
a hash map of the enum values to some other value. See below:

```ruby
alt_label_map = {
  User::Role::ADMIN  => 'The admin user',
  User::Role::EDITOR => 'An editor',
  User::Role::AUTHOR => 'An author',
  User::Role::USER   => 'A user'
}

user = User.new(role: User::Role::EDITOR)
alt_label = alt_label_map[user.role]
alt_label == nil # not 'An editor'
```

If you want the hash to work as expected then call the `.value` method on the
attribute:

```ruby
alt_label = alt_label_map[user.role.value]
alt_label == 'An editor'
```

Thus, the `.value` method on the attribute gives the actual `Fixnum` value.
There is also a `.key` method which gives the symbol key:

```ruby
user = User.new(role: User::Role::ADMIN)
user.role.key == :admin
```

The attribute value can also be set with a bang `*!` method

```ruby
user = User.new
user.role.user!
user.display_role == 'User'

user.role.author!
user.display_role == 'Author'
```

## Scopes for Models

Convenient scopes are created for each possible enum value on the model class:

```ruby
User.role_admin  == User.where(role: User::Role::ADMIN)
User.role_editor == User.where(role: User::Role::EDITOR)
User.role_author == User.where(role: User::Role::AUTHOR)
User.role_user   == User.where(role: User::Role::USER)
```

## Enum Helper Methods

Helper methods are added to the actual `Enum` module as well.

### get_label and get_key
Get the (surprise!) label and key for a given enum
value:

```ruby
User::Role.get_label(User::Role::ADMIN) == 'Admin'
User::Role.get_key(User::Role::USER) == :user
```

### attr_name
Return the attribute name as a symbol

```ruby
User::Role.attr_name == :role
```

### keys
Return all the enum keys

```ruby
User::Role.keys == [:admin, :editor, :author, :user]
```

### values
Return all the enum values

```ruby
User::Role.values == [0, 1, 2, 3]
```

### labels
Return all the enum labels

```ruby
User::Role.labels == ['Admin', 'Editor', 'Author', 'User']
```

### label_value_pairs
Return an array of pairs of the label and value for each
enum value. This is mainly a convenience method for something like the
collection option for a select input in the
[Formtastic](https://github.com/justinfrench/formtastic) or
[ActiveAdmin](https://github.com/gregbell/active_admin) (which uses Formtastic)
gems, so you can easily generate select options:

```ruby
User::Role.label_value_pairs == [
  ['Admin', 0], ['Editor', 1], ['Author', 2], ['User', 3]
]

# In an ActiveAdmin form
ActiveAdmin.register User do
  form do |f|
    f.inputs 'User Details' do
      f.input :first_name
      f.input :last_name
      f.input :email

      # Example usage of `label_value_pairs`
      f.input :role, as: :select, collection: User::Role.label_value_pairs
    end
  end
end
```

You can also filter the results by passing in enum value keys as symbol
arguments:

```ruby
User::Role.label_value_pairs(:admin, :author) == [
  ['Admin', 0], ['Author', 2]
]
```

### to_h and to_json
`to_h` and `to_json` return a hash and a json string representation of the enum,
respectively. They both offer an `only` and an `except` option to specify if
you only want the value or maybe only the label and key or if you want
everything but key. **NOTE**:  passing only key to `only` or excluding all but
one key via `except` will give that single value (whether it's value, key, or
label) instead of a hash. See below to understand:

```ruby
# Default call with no options
User::Role.to_h == {
  'ADMIN'  => { key: :admin,  label: 'Admin',  value: 0 },
  'EDITOR' => { key: :editor, label: 'Editor', value: 1 },
  'AUTHOR' => { key: :author, label: 'Author', value: 2 },
  'USER'   => { key: :user,   label: 'User',   value: 3 }
}

# Call with a single symbol (would also work with `only: [:value]`)
# Notice the mapped values are not hashes like above because we only
# specified that we wanted the value
User::Role.to_h(only: :value) == {
  'ADMIN'  => 0,
  'EDITOR' => 1,
  'AUTHOR' => 2,
  'USER'   => 3
}

# Would also work with `except: [:value]`
User::Role.to_json(except: :value) ==
  "{\"ADMIN\":{\"key\":\"admin\",\"label\":\"Admin\"},\"EDITOR\":{\"key\":\"editor\",\"label\":\"Editor\"},\"AUTHOR\":{\"key\":\"author\",\"label\":\"Author\"},\"USER\":{\"key\":\"user\",\"label\":\"User\"}}"
```

## Feedback and Pull Requests Welcome
This is my first real Rails gem, so I welcome all feedback and ideas. I hope this gem is as helpful to you as it has been to me in my own projects.
