# StrongInterface

Simple implementation of an interface pattern for Ruby

This design pattern is widely spread and included in many programming languages.
And this is an attempt to implement this pattern.
So, it is not a big deal to make a dsl for checking if method exists at some class or not,
however it is much more tricky to put it at the top of a class.

In this gem the main problem was solved.
It allows to put a definition of interfaces which should be implemented wherever within the class or module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strong_interface'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install strong_interface

## Usage

#### Define an interface

```ruby
module IDog
  WORD = String
  def self.create(*); end
  def eat(food); end
  def voice; end
end
```

#### Then implement it

```ruby
class Lessy
  extend StrongInterface
  implements IDog
  
  WORD = 'gav'

  def self.create(name)
    # Creating...
  end
  
  def eat(food)
    # Eating...
  end
  
  def voice
    WORD
  end
end
```

#### And if you don't

```ruby
class Lessy
  extend StrongInterface
  implements IDog

  def eat(food, water)
    # Eating...
  end

  def voice
    'Gav'
  end
end
```

#### Exception will be raised

```shell
StrongInterface::ImplementationError (Constant `WORD` is absent at `Lessy`)
Class method `create` is not implemented at `Lessy`
Invalid parameters at method `eat`, expected: `def eat(food)`, got: `def eat(food, water)`
```

## Validation Strategies

Validation strategy could be set through environment variable `SI_VALIDATION_STRATEGY`.
This variable could receive only two values: `raise` and `log`. 
In case of incorrect value the `StrongInterface::UnknownStrategy` will be raised.
If the variable is not set, the `raise` strategy will be applied.

#### raise (default)

This is a default strategy. When validator finds incorrect implementation, it raises the `StrongInterface::ImplementationError` exception,
and provides a list of methods which aren't implemented

#### log

In this case nothing raises, the validator just logs the errors.
It could be convenient, if you don't want to crash the whole application at boot time in production,
even if it has this kind of a problem in code.

## TODO

- [x] Check if methods of interfaces all exists in a class or module
- [x] Check the arguments of methods
- [x] Check constants
- [ ] Checking the privacy of methods???
- [ ] Allow optional arguments at interface methods???

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/programyan/strong_interface. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/programyan/strong_interface/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StrongInterface project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/programyan/strong_interface/blob/main/CODE_OF_CONDUCT.md).
