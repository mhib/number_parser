# number_parser
[![Build Status](https://travis-ci.com/mhib/number_parser.svg?token=QxTjF5cyvAyFx6gAmphf&branch=master)](https://travis-ci.com/mhib/number_parser)

[Numerizer](https://github.com/jduff/numerizer) in crystal

It passes 100% numerizer tests.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  number_parser:
    github: mhib/number_parser
```

## Usage

```crystal
require "number_parser"

>> NumberParser.parse('forty two')
=> "42"
>> NumberParser.parse('two and a half')
=> "2.5"
>> NumberParser.parse('three quarters')
=> "3/4"
>> NumberParser.parse('two and three eighths')
=> "2.375"
```

## Contributing

1. Fork it (<https://github.com/mhib/number_parser/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mhib](https://github.com/your-github-user) Marcin Henryk Bartkowiak - creator, maintainer
