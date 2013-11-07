# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  # CITE_TEXT_START = /@.+?\b/
  # def parse_cite_text
    
  # end
  # define_parser(:cite_text, CITE_TEXT_START)

  #CITE_PARENTHES = /\[(.*?)@(.+?)\b(.*?)\]/
  CITE_PARENTHES = /\[(.*?@.+?)\]/
  def parse_cite_parenthes
    el = Element.new(:citation)
    el.options[:parentheses] = true
    el.value = []
    @src[1].split(';').each do |ref|
       m = ref.match(/(.*?)@(.+?)\b,?(.*?)(\s*\D*?)$/)
       el.value << {:prefix => m[1].strip, :id => m[2], :locator => m[3], :suffix => m[4]}
    end 
    #p el
    @src.scan_until(/\]/)
    @tree.children << el

  end
  define_parser(:cite_parenthes, CITE_PARENTHES)


end
