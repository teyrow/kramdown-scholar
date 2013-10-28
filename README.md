kramdown-scholar
=============


[![Build Status](https://travis-ci.org/teyrow/kramdown-scholar.png)](https://travis-ci.org/teyrow/kramdown-scholar)

This gem extends the default [kramdown][] parser to be able to output latex 
for use in scientific critical text editions. It mainly wraps the eledpar
to work with parallel texts, and eledmac for critical footnotes. 


Installation
------------

Add this line to your application's Gemfile:

    gem 'kramdown-scholar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kramdown-scholar


Usage
-----

### With standalone kramdown

Usage with standalone kramdown is similar:

    require 'kramdown'
    require 'kramdown-scholar'


    # might load content from utf8
    content = File.read('article.md', encoding: 'UTF-8')
    Kramdown::Document.new(content, :input => 'KramdownScholar').to_latex


Syntax
------

TODO


Contributing
------------

1. Fork
2. Create a topic branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


License
-------

GPLv3 &mdash; see `COPYING` for more information


[kramdown]: http://kramdown.rubyforge.org/
