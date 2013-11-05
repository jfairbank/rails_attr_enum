### v0.0.6
* Added example usage of extending `RailsAttrEnum` and calling
  `attr_enum` in `User` model in test Rails app.
* Fixed a bug that crashed the Rails environment when a model without an
  existing table used `RailsAttrEnum`. An example of this happening
  would be when someone tried to run `rake db:schema:load`.
* Fixed a bug in `clear_user` in the spec_helper.rb file with calling
  the private `remove_instance_variable` method on the test model
  `User`.
* Added `default_user_roles` to spec_helper.rb file, so a default usage
  of extending `RailsAttrEnum` and calling `attr_enum` could be
  established. This allows other future specs that depend on that
  default usage to not be messed up by the user_spec.rb file which
  alters `RailsAttrEnum` usage in `User` for different tests.

### v0.0.5
* Fix a bug with the 'to_json' and 'as_json' methods for a model that
  has an enum attribute set up.
