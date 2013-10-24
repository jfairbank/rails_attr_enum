# RailsAttrEnum
## Enums for Rails models

I created RailsAttrEnum as a way to create an enum-like structure similar to
enums in C languages. You can specify the accepted identifiers for the possible
integer values for the model's attribute as well have built-in validation to
ensure only the values are accepted.

### Usage

Here's an example given a class `User` with an attribute `role`:

    # Example model User for a blog app
    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role, :admin, :author, :editor, :user
    end

    # Creates module `User::Role` with constants for each possible value
    User::Role::ADMIN  == 0
    User::Role::AUTHOR == 1
    User::Role::EDITOR == 2
    User::Role::USER   == 3

As you can see, this would give a module `User::Role` containing constants `ADMIN`, `AUTHOR`,
`EDITOR`, and `USER` with the respective values of `0`, `1`, `2`, and `3`.

You can also specify the integer values for each identifier or only some. Those
you don't specify will automatically be filled with the first available integer
value.

    # Target specific identifiers
    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role, :admin, { author: 12 }, :editor, { user: 42 }
    end

    User::Role::ADMIN  == 0
    User::Role::AUTHOR == 12
    User::Role::EDITOR == 1   # Notice this still defaulted to 1
    User::Role::USER   == 42

    # Use a hash to specify all values
    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role, {
        admin: 1,
        author: 2,
        editor: 4,
        user: 8
      }
    end

    User::Role::ADMIN  == 1
    User::Role::AUTHOR == 2
    User::Role::EDITOR == 4
    User::Role::USER   == 8

    # Use a block to specify some (or all)
    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role do
        add admin: 42
        add :author
        add :editor
        add user: 7
      end
    end

    User::Role::ADMIN  == 42
    User::Role::AUTHOR == 0  # Again notice how `AUTHOR` and `EDITOR` defaulted
    User::Role::EDITOR == 1
    User::Role::USER   == 7

### Labels
RailsAttrEnum also creates a label for each identifier that you can use in your
app to display something meaningful for a value. Appropriate label constants are
added to the module enum as well as a helper `display_*` method on instances of
your model.

    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role, :admin, :author, :editor, :user
    end

    User::Role::ADMIN_LABEL  == 'Admin'
    User::Role::AUTHOR_LABEL == 'Author'
    User::Role::EDITOR_LABEL == 'Editor'
    User::Role::USER_LABEL   == 'User'

    user = User.new(role: User::Role::ADMIN)
    user.display_role == 'Admin' # Helper method added by RailsAttrEnum

You can specify your own labels if you like. By default, RailAttrEnum calls
`.to_s.titleize` on the symbol identifier.

    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role,
        { admin: 'Admin Role' }, :author, { editor: 'Editor Role' }, :user
    end

    User::Role::ADMIN_LABEL  == 'Admin Role'
    User::Role::AUTHOR_LABEL == 'Author'
    User::Role::EDITOR_LABEL == 'Editor Role'
    User::Role::USER_LABEL   == 'User'

    # With a hash
    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role, {
        admin: 'Admin Role',
        author: 'Author Role',
        editor: 'Editor Role',
        user: 'User Role'
      }
    end

    User::Role::ADMIN_LABEL  == 'Admin Role'
    User::Role::AUTHOR_LABEL == 'Author Role'
    User::Role::EDITOR_LABEL == 'Editor Role'
    User::Role::USER_LABEL   == 'User Role'

    # With a block
    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role do
        add :admin
        add author: 'Author Role'
        add editor: 'Editor Role'
        add :user
      end
    end

    User::Role::ADMIN_LABEL  == 'Admin'
    User::Role::AUTHOR_LABEL == 'Author Role'
    User::Role::EDITOR_LABEL == 'Editor Role'
    User::Role::USER_LABEL   == 'User'

### Mix-and-match
If you need to be very specific about values and labels, then you can specify
both at the same time too.

    class User < ActiveRecord::Base
      extend RailsAttrEnum

      attr_enum :role, { admin: { label: 'Admin Role', value: 1 } },
                       { author: 'Author Role' },
                       { editor: 42 },
                       :user
    end

    User::Role::ADMIN        == 1
    User::Role::ADMIN_LABEL  == 'Admin Role'
    User::Role::AUTHOR       == 0
    User::Role::AUTHOR_LABEL == 'Author Role'
    User::Role::EDITOR       == 42
    User::Role::EDITOR_LABEL == 'Editor'
    User::Role::USER         == 2
    User::Role::USER_LABEL   == 'User'
