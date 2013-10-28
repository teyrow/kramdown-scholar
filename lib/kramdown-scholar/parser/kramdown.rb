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

    
    #while !@src.match?(self.class::PAGES_END)
    #  result << @src.scan(PARAGRAPH_MATCH) 
    #end

    result.gsub!(PAGES_START, '')
    result.gsub!(PAGES_END, '')
    #@src.pos += @src.matched_size
    el = new_block_el(:pages)
    # pry.binding
    @tree.children << el
    parse_blocks(el, result)
    true
  end
  define_parser(:pages, PAGES_START)  

  end
