# encoding: utf-8
#
# converter.rb - monkey-patches for Kramdown converters
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

module Kramdown
  module Converter

    class Html

      def convert_pages(el, indent)
        "#{' '*indent}#{el.value}\n"
      end

    end

    class Kramdown

      def convert_pages(el, opts)
        "*{pages:#{el.value}}\n"
      end

    end

    class LatexScholar < Latex

      def convert_pages(el, opts)
        @data[:packages] << 'eledmac' #Must be before eledpar
        @data[:packages] << 'eledpar'        
        
        latex_environment('pages', el, inner(el, opts) ) <<   "\\Pages" 
      end

      def convert_parallel_side(el, opts)
        # TODO assert opts['side'] is Right or Left
        env = "#{el.options['side']}side"
        numbering = "\\beginnumbering\n#{inner(el, opts)}\\endnumbering\n"
        latex_environment(env, el, numbering )
      end

      def convert_pstart(el, opts)
        "\\pstart\n#{inner(el, opts)}\\pend\n"
      end

      def convert_inline_footnote(el, opts)
        "\\footnote{#{latex_link_target(el)}#{inner(el, opts)}}"
      end

      def convert_a(el, opts)
        url = el.attr['href']
        if url =~ /^([A-G]*)\^(.*)/
          @data[:packages] << 'eledmac'
          "\\edtext{#{inner(el, opts)}}{\\footnote#{$1}{#{$2}}}"
        else
          super
        end
      end

    end

  end
end
