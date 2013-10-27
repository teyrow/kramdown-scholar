# encoding: utf-8
#
# kramdown-scholar.rb - Kramdown extension for gist tags
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

require 'kramdown-scholar/version'

require 'kramdown'

module Kramdown

  # Monkey-patch Element class to include :gist as a block-level element
  # @private
  class Element
    # Register :gist as a block-level element
    CATEGORY[:gist] = :block
  end

end

require 'kramdown-scholar/parser'
require 'kramdown-scholar/converter'
