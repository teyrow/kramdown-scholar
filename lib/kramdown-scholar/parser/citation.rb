# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  CITE_PARENTHES = /\[.*?@.+?\]/

  def parse_cite_parenthes
    @src.scan(/\[/) #eat the bracket
    cites = Element.new(:citation)
    #while @src.scan(/(.*?)@(.+?)\b,?(.*?)(\s*\D*?);/)      
    loop do
      el = Element.new(:text)
      el.value = {}
      @src.scan(/(,| )*/)

      el.value[:prefix] = Element.new(:text)
      parse_spans(el.value[:prefix], / ?@/)
      
      @src.pos += @src.matched_size

      el.value[:id] = Element.new(:text)
      parse_spans(el.value[:id], /\W/)
      
      @src.scan(/(,| )*/)

      el.value[:location] = Element.new(:text)
      el.value[:location].value = @src.scan(/([,.A-Za-z ]+[0-9-]+)+/)

      el.value[:suffix] = Element.new(:suffix)
      parse_spans(el.value[:suffix], /(;|\])/)
      p el.value[:suffix]
      
      @src.pos += @src.matched_size

      cites.children << el
      break if @src[0] == ']'

    end
    @tree.children << cites
    @src.scan_until(/\]/)
  end
  define_parser(:cite_parenthes, CITE_PARENTHES)

  CITE_TEXTUAL = /@([^"@',\#}{~%;\] ]+)/

  def parse_cite_textual
    @src.pos += @src.matched_size
    
    if @src.pre_match[-1] =~ /[A-Z0-9._%+-]/i
      el = Element.new :text
      el.value = '@' << @src[1]
    else 
      el = Element.new :cite_textual
      el.value = @src[1]
    end 
    @tree.children << el
  end
  define_parser(:cite_textual, CITE_TEXTUAL)

end
