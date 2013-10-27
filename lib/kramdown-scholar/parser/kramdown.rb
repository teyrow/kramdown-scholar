# encoding: utf-8
#
# kramdown.rb - gist-enabled kramdown parser
# Copyright (C) 2012 Matteo Panella <morpheus@level28.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'kramdown/parser/kramdown'

module Kramdown
  module Parser

    # Standard Kramdown parser with support for embedding GitHub Gists
    # in the output.
    #
    # This class extends the default Kramdown syntax with a new block-level
    # element for embedding gists: `*{gist:<id>}`. The element is rendered
    # as a `<script>` tag pointing to `http://gist.github.com/<id>.js`.
    #
    # @author Matteo Panella
    class KramdownScholar < ::Kramdown::Parser::Kramdown

      # Create a new gist-enabled Kramdown parser with the given `options`.
      def initialize(source, options)
        super
        @block_parsers.unshift(:gist)
      end

      # Regex for matching a gist tag
      # @private
      GIST_START = /^#{OPT_SPACE}\*\{gist:([0-9a-fA-F]+?)\}\n/

      # Do not use this method directly, it's used internally by Kramdown.
      # @api private
      def parse_gist
        @src.pos += @src.matched_size
        gist_id = @src[1]
        @tree.children << Element.new(:gist, gist_id)
      end
      define_parser(:gist, GIST_START)

    end

  end
end
