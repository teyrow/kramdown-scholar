# -*- coding: utf-8 -*-

require 'kramdown/parser/kramdown'

class Kramdown::Parser::KramdownScholar < Kramdown::Parser::Kramdown

  CITE_PARENTHES = /\[[^\]]*?@.+?\]/

  def parse_cite_parenthes
    @src.scan(/\[/) #eat the bracket
    
    cites = Element.new(:citation)
    while parse_spans(el = Element.new(:text), /(;|\])/)
      cites.children << el
      @src.pos += 1
    end
    
    @tree.children << cites
    @src.scan_until(/\]/)
  end
  define_parser(:cite_parenthes, CITE_PARENTHES)

  CITE_TEXTUAL = /(-?)@([^"@',\#}{~%:\]\s;]+)/
  # according to bibtex guide: .#$%&-_+?<>~/
  def parse_cite_textual
    @src.pos += @src.matched_size
    if @src.pre_match[-1..-1] =~ /[A-Z0-9._%+]/i
      el = Element.new :text
      el.value = '@' << @src[2]
    else 
      el = Element.new :cite_textual
      el.value = @src[2]
      el.options[:supress_author] = @src[1] == '-'
    end 
    @tree.children << el
  end
  define_parser(:cite_textual, CITE_TEXTUAL)

  CITE_LOCATION = /\s?\w+\.(,? +[0-9-]+)+/
  
  def parse_cite_location
    @src.pos += @src.matched_size
    add_text(@src[0], @tree, :cite_location)
  end

  define_parser(:cite_location, CITE_LOCATION)

end
