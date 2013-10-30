# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  def initialize(source, options)
   super
   @span_parsers.unshift(:erb_tags)
   @block_parsers.unshift(:pages)
  end

  ERB_TAGS_START = /<%(.*?)%>/

  def parse_erb_tags
   @src.pos += @src.matched_size
   @tree.children << Element.new(:raw, @src[1])
  end
  define_parser(:erb_tags, ERB_TAGS_START, '<%')

  #PAGES_START = /^#{OPT_SPACE}PAGES:(.*?):PAGES ?\n/m
  PAGES_START = /^#{OPT_SPACE}PAGES: ?/
  PAGES_END = /^#{OPT_SPACE}:PAGES ?/
  # Parse the pages at the current location.
  def parse_pages
    result = @src.scan_until(PAGES_END)
    
    unless result
      warning('Warning: PAGES: start found but missing :PAGES')
      return false
    end

    result.gsub!(PAGES_START, '')
    result.gsub!(PAGES_END, '')

    el = new_block_el(:pages)
    parse_blocks(el, result)
    # not interested in the blanks
    el.children.reject!{|e| e.type == :blank}
    left = new_block_el(:parallel_side)
    left.options['side'] = 'Left'
    right= new_block_el(:parallel_side)
    right.options['side']= 'Right'
    # TODO assert same length in even and odd. 
    el.children.each_with_index do |e, i| 
      para = new_block_el(:pstart)
      para.children << e
      (i.even? ? left : right ).children << para
    end
    el.children = [left, right]
    #el.children << right
    @tree.children << el
    true
  end
  define_parser(:pages, PAGES_START)

end
