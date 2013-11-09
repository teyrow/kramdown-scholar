# encoding: utf-8
#
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
        "{\\#{el.options[:footnote_level]}footnote{#{latex_link_target(el)}#{inner(el, opts)}}}"
      end

      def convert_lemma(el, opts)
        @data[:packages] << 'eledmac'
        "\\edtext{#{inner(el, opts)}}"
      end

      def convert_citation(el, opts)
        @data[:packages] << 'natbib'        
        # if el.options[:parentheses] 
          
        # end 

        res = el.children.map do |child|
          #c = child.value
          #prefix, id, suffix = [:prefix, :id, :suffix].map { |k| inner(c[k], opts) }
          #location = c[:location].value
          #"\\citealp[#{prefix}][#{location}]{#{id}}#{suffix}"
          "#{inner(child, opts)}"
        end.join(', ')
        "\\citetext{#{res}}"
        ##  \citetext{see \citealp[][chap 2]{Fis00a}, or even better \citealp[][pp. 20-21]{Meskin2007}}
      end
      
      def convert_cite_textual(el, opts)
        cmd = el.options[:supress_author] ? '\citeyear' : '\citet'
        cmd <<   "{#{el.value}}"
      end

    end


  end
end
