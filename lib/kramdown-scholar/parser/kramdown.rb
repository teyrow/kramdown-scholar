# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  def initialize(source, options)
   super
   @span_parsers.unshift(:inline_footnote, :sidenote, :cite_parenthes, :cite_textual, :cite_location)
  end

  INLINE_FOOTNOTE_START = /\[(.*?)\]\^([A-G]?)\(/m
  LEMMA_START           = /\[/
  LEMMA_END             = /[\^\]]/
  INLINE_FOOTNOTE_END   = /\)/

  # Parse the inline footnote marker at the current location.
  def parse_inline_footnote
    footnote_level = @src[2]    
    
    @src.scan(LEMMA_START)
    el = Element.new(:lemma)
    parse_spans(el, LEMMA_END)

    lemma_short = Element.new(:text)
    @src.getch if  @src.matched ==  '^'  
    parse_spans(lemma_short, /\]/)
    fn = Element.new(:inline_footnote)
    fn.options[:footnote_level] = footnote_level
    if lemma_short.children.any?
      fn.options[:lemma_short]= lemma_short
    end


    @src.scan_until(/\(/)
    parse_spans(fn, INLINE_FOOTNOTE_END)
    @src.scan(INLINE_FOOTNOTE_END)
    #el.children << fn
    @tree.children << el
    @tree.children << fn
  end
  define_parser(:inline_footnote, INLINE_FOOTNOTE_START)

  SIDENOTE_START = /\[>.*?\]/
  SIDENOTE_END   = /\]/
  def parse_sidenote
    @src.scan(/\[>/)
    parse_spans(el = Element.new(:sidenote), SIDENOTE_END)
    @src.scan(SIDENOTE_END)
    @tree.children << el
  end

  define_parser(:sidenote, SIDENOTE_START)

  def handle_extension(name, opts, body, type)
    case name
     when 'scholar'
      el = new_block_el(:pages)
      parse_blocks(el, body)
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
     else 
        super
     end 
   end

end
