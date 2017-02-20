# acts_as_hashids

[![Gem Version][gem-image]][gem-link]
[![Download][download-image]][download-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][cov-image]][cov-link]
[![Code Climate][gpa-image]][gpa-link]

Use [Hashids](https://github.com/peterhellberg/hashids.rb) (a.k.a. Youtube-Like ID) in ActiveRecord seamlessly.

## Installation

Add the acts_as_hashids gem to your Gemfile.

```ruby
gem "acts_as_hashids"
```

And run `bundle install`.

## Usage

Activate the function in any model of `ActiveRecord::Base`.

```ruby
class Foo < ActiveRecord::Base
  acts_as_hashids
end

foo = Foo.create
# => #<Foo:0x007feb5978a7c0 id: 3>

foo.to_param
# => "ePQgabdg"

Foo.find(3)
# => #<Foo:0x007feb5978a7c0 id: 3>

Foo.find("ePQgabdg")
# => #<Foo:0x007feb5978a7c0 id: 3>

Foo.with_hashids("ePQgabdg").first
# => #<Foo:0x007feb5978a7c0 id: 3>
```

### Use in Rails

Only one thing you need to hash ids is put `acts_as_hashids` in `ApplicationRecord`, then you will see hash ids in routes URL and they are handled correctly as long as you use `find` to find records.

## Options

### length

You can customize the length of hash ids per model. The default length is 8.

```ruby
class Foo < ActiveRecord::Base
  acts_as_hashids length: 2
end

Foo.create.to_param
# => "Rx"
```

### secret

You can customize the secret of hash ids per model. The default secret is the class name. The name of base class is used for STI.

```ruby
class Foo1 < ActiveRecord::Base
  acts_as_hashids secret: 'my secret'
end

class Foo2 < ActiveRecord::Base
  acts_as_hashids secret: 'my secret'
end

Foo1.create.to_param
# => "RxQce3a2"

Foo2.create.to_param
# => "RxQce3a2"
```

## Test

Execute the command below to run rspec and rubocop.

```
bundle exec rake
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.




[gem-image]:   https://badge.fury.io/rb/acts_as_hashids.svg
[gem-link]:    http://badge.fury.io/rb/acts_as_hashids
[download-image]:https://img.shields.io/gem/dt/acts_as_hashids.svg
[download-link]:https://rubygems.org/gems/acts_as_hashids
[build-image]: https://secure.travis-ci.org/dtaniwaki/acts_as_hashids.png
[build-link]:  http://travis-ci.org/dtaniwaki/acts_as_hashids
[cov-image]:   https://coveralls.io/repos/dtaniwaki/acts_as_hashids/badge.png
[cov-link]:    https://coveralls.io/r/dtaniwaki/acts_as_hashids
[gpa-image]:   https://codeclimate.com/github/dtaniwaki/acts_as_hashids.png
[gpa-link]:    https://codeclimate.com/github/dtaniwaki/acts_as_hashids

