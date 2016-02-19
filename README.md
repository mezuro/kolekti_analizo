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

## Usage

Just register it into Kolekti with

```ruby
require 'kolekti'
require 'kolekti_analizo'

Kolekti.register_collector(Kolekti::Analizo::Collector.new)
```
