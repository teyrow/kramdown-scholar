kramdown-scholar
=============

[![Build Status](https://travis-ci.org/rfc1459/kramdown-scholar.png)](https://travis-ci.org/rfc1459/kramdown-scholar)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/rfc1459/kramdown-scholar)

This gem extends the default [kramdown][] parser with a new block-level
element which adds support for embedding [GitHub Gists][gists] via
Javascript without having to hardcode `<script>` tags.

It has been designed with [nanoc][] in mind, but it can be used with
any other program which embeds kramdown (as long as it allows to
override the parser being used.)


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

### With nanoc

If you're using [nanoc][], it's sufficient to require this gem from the
`Rules` file of your site and then pass `{ :input => 'KramdownScholar' }` as
options for any instance of the kramdown filter.

Example:

    require 'kramdown-scholar'

    compile '*.md' do
       filter :kramdown, { :input => 'KramdownScholar' }
    end


### With standalone kramdown

Usage with standalone kramdown is similar:

    require 'kramdown'
    require 'kramdown-scholar'

    Kramdown::Document.new(content, :input => 'KramdownScholar').to_html


Syntax
------

The extended parser class supports the same [syntax][km-syntax] as kramdown
with the addition of the `*{gist:<id>}` block-level element. The element
will be replaced with an appropriate `<script>` tag.

`<id>` should be replaced with the identifier of the Gist you wish to embed.


Known issues
------------

LaTeX output sucks, contributions are more than welcome.


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
[km-syntax]: http://kramdown.rubyforge.org/syntax.html
[gists]: https://gist.github.com/
[nanoc]: http://nanoc.ws/
