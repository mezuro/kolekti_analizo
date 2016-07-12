# KolektiAnalizo

[![Code Climate](https://codeclimate.com/github/mezuro/kolekti_analizo.png)](https://codeclimate.com/github/mezuro/kalibro_client)

Generic parser for Analizo static code metrics collector.

## Contributing

Please, have a look the wiki pages about development workflow and code standards:

* https://github.com/mezuro/mezuro/wiki/Development-workflow
* https://github.com/mezuro/mezuro/wiki/Standards

## Installation

Add this line to your application's Gemfile:

    gem 'kolekti_analizo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kolekti_analizo

### Important note about Ruby versions older than 2.2.2

KolektiAnalizo depends on [activesupport](https://github.com/rails/activesupport) to work.
AS version 5 dropped support for Ruby versions older than 2.2.2. Unfortunately,
RubyGems does not take that into account while selecting a Gem version to be installed.
It will attempt to install version 5 and fail in many cases.

If your project is not using Rails (which will already lock the AS version to it's own),
you need to add the following snippet to your Gemfile if you want to keep support
for those old Ruby versions.

```ruby
# Active Support 5 drops Ruby < 2.2.2 support. We still want to support it, so
# manually add a maximum version bound for incompatible Ruby versions.
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2')
    gem 'activesupport', '< 5'
end
```

If you are installing KolektiAnalizo manually as outlined earlier, you must install a version
of f AS compatible with your Ruby installation first, by running the following command:

    gem install activesupport -v '< 5'

## Usage

Just register it into Kolekti with

```ruby
require 'kolekti'
require 'kolekti_analizo'

Kolekti.register_collector(Kolekti::Analizo::Collector.new)
```
