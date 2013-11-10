# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  def initialize(source, options)
   super
   @block_parsers.unshift(:pages)
   @span_parsers.unshift(:inline_footnote, :cite_parenthes, :cite_textual, :cite_location)
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
    i=0
    while e=el.children.shift
      para = new_block_el(:pstart)
      para.children << e
      if e.type == :header # hangin indent fix
        e.options[:unnumbered] = true
        para.children << el.children.shift 
      end
      (i.even? ? left : right ).children << para
      i += 1
    end 
    el.children = [left, right]
    @tree.children << el
    true
  end
  define_parser(:pages, PAGES_START)

  
  INLINE_FOOTNOTE_START = /\[(.*?)\]\^([A-G]?)\(/
  LEMMA_START           = /\[/
  LEMMA_END             = /\]/
  INLINE_FOOTNOTE_END   = /\)/
  
  # Parse the inline footnote marker at the current location.
  def parse_inline_footnote
    footnote_level = @src[2]
    @src.scan(LEMMA_START)
    el = Element.new(:lemma)
    parse_spans(el, LEMMA_END)
    
    fn = Element.new(:inline_footnote)
    fn.options[:footnote_level] = footnote_level

    @src.scan_until(/\(/)
    parse_spans(fn, INLINE_FOOTNOTE_END)
    @src.scan(INLINE_FOOTNOTE_END)
    #el.children << fn
    @tree.children << el
    @tree.children << fn
  end
  define_parser(:inline_footnote, INLINE_FOOTNOTE_START)


end
