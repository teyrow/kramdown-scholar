# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  def initialize(source, options)
   super
   @block_parsers.unshift(:pages)
   @span_parsers.unshift(:inline_footnote)
  end

  PAGES_START = /^#{OPT_SPACE}PAGES: ?/
  PAGES_END = HR_START
  # Parse the pages at the current location.
  def parse_pages
    result = @src.scan_until(PAGES_END)
    
    unless result
      warning('Warning: PAGES: start found but missing ending.')
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

  INLINE_FOOTNOTE_START = /\^\[/
  INLINE_FOOTNOTE_END   = /(\])/  
  
  # Parse the inline footnote marker at the current location.
  def parse_inline_footnote
    @src.scan(INLINE_FOOTNOTE_START)
    el = Element.new(:inline_footnote)
    parse_spans(el, INLINE_FOOTNOTE_END)
    @src.scan(INLINE_FOOTNOTE_END)
    @tree.children << el
  end
  define_parser(:inline_footnote, INLINE_FOOTNOTE_START)

end
