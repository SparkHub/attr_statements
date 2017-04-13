[![Gem Version](https://badge.fury.io/rb/attr_statements.svg)](http://badge.fury.io/rb/attr_statements)
[![Build Status](https://travis-ci.org/SparkHub/attr_statements.svg?branch=master)](https://travis-ci.org/SparkHub/attr_statements)
[![Code Climate](https://codeclimate.com/github/SparkHub/attr_statements/badges/gpa.svg)](https://codeclimate.com/github/SparkHub/attr_statements)
[![Test Coverage](https://codeclimate.com/github/SparkHub/attr_statements/badges/coverage.svg)](https://codeclimate.com/github/SparkHub/attr_statements/coverage)
[![Issue Count](https://codeclimate.com/github/SparkHub/attr_statements/badges/issue_count.svg)](https://codeclimate.com/github/SparkHub/attr_statements)
[![Dependency Status](https://gemnasium.com/SparkHub/attr_statements.svg)](https://gemnasium.com/SparkHub/attr_statements)

# AttrStatements

AttrStatements is a simple strong typed attributes generator on classes. It also add the ability to validate these attributes. These validations are extended with ActiveModel::Errors, so you can have a full integration with ActiveRecord.
A typical usecase will be extending a serializer with AttrStatements in order to have automatic ActiveModel::Errors management.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attr_statements', '~> 0.1.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_statements

## Usage

```ruby
require 'attr_statements'

class Profile
  extend AttrStatements

  attr_statement :email, String, presence: true, length: { maximum: 15 }
  attr_statement :city,  String
end

Profile.attr_statements
# => [:email, :city]

profile = Profile.new
# => #<Profile:0x007fc83511e8b0>

profile.valid?
# => false

profile.errors.any?
# => true

profile.errors
# => #<ActiveModel::Errors:0x007fc82bec5d88 @base=#<Profile:0x007fc83511e8b0 @errors=#<ActiveModel::Errors:0x007fc82bec5d88 ...>>, @messages={:email=>["can't be blank"]}>

profile.errors.full_messages
# => ["Email can't be blank"]

profile.email = 'mylongtest@email.com'
# => "mylongtest@email.com"

profile.valid?
# => false

profile.errors.full_messages
# => ["Email is too long (maximum is 15 characters)"]

profile.email = 'test@email.com'
# => 'test@email.com'

profile.valid?
# => true

profile.email = 42
# => 42

profile.valid?
# => false

profile.errors.full_messages
# => ["Email must be a String"]
```

## Bonuses

### Add translations

The `type` validation for example would need a translation (at least a default `:en`). Translation is compatible with I18n. So all we need, is a yml with:

```yaml
en:
  errors:
    messages:
      type: 'must be a %{class}'
```

### Inject AttrStatements errors within an ActiveRecord validation process

AttrStatements errors can be easily injected within an ActiveRecord validation processus. Here is an example:

```ruby
Class User < ActiveRecord::Base
  serialize :profile_attributes, Profile

  after_validation :validate_profile_attributes

  private

  def validate_profile_attributes
    if profile_attributes && !profile_attributes.valid?
      # merge child errors with parent errors
      profile_attributes.errors.each do |k, v|
        errors.add("profile_attribute_#{k}", v)
      end
    end
  end
end
```

User will now have the `:profile_attributes` errors generated by AttrStatements on `create`, `update`. (see [ActiveRecord::Validations#valid?](https://apidock.com/rails/ActiveRecord/Validations/valid%3F))

## Running tests

To run tests:

    $ bundle exec rake spec

## Running CI tools

To run rubocop:

    $ rubocop

To run reek:

    $ reek

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SparkHub/attr_statements. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
