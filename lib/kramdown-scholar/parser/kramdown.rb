# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  def initialize(source, options)
   super
   @span_parsers.unshift(:erb_tags)
   @block_parsers.unshift(:pages)
  end

  # def handle_extension(name, opts, body, type)
  #   case name
  #   when 'pages'
  #     #binding.pry
  #     el = new_block_el(:pages)
  #     puts body
  #     parse_spans(el, body)
  #     @tree.children << el
  #     #@tree.children << el
  #     #parse_blocks(el, body)
  #     true
  #   else 
  #     super
  #   end
  # end

  ERB_TAGS_START = /<%(.*?)%>/

  def parse_erb_tags
   @src.pos += @src.matched_size
   @tree.children << Element.new(:raw, @src[1])
  end
  define_parser(:erb_tags, ERB_TAGS_START, '<%')



  PAGES_START = /^#{OPT_SPACE}PAGES: ?/

  # Parse the pages at the current location.
  def parse_pages
    result = @src.scan(PARAGRAPH_MATCH)
    while !@src.match?(self.class::LAZY_END)
      result << @src.scan(PARAGRAPH_MATCH) rescue break
    end

    result.gsub!(PAGES_START, '')

    el = new_block_el(:pages)
    # pry.binding
    @tree.children << el
    parse_blocks(el, result)
    true
  end
  define_parser(:pages, PAGES_START)  

  end
