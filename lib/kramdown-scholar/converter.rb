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
        "*{{::pages}#{el.value}}\n"
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
        l_r = el.options['side']
        env = "#{l_r}side"
        content = inner(el, opts)
        res = "\\beginnumbering\n#{content}\\endnumbering\n"
        res = ("\\ledsectnotoc\n" << res) if l_r == 'Right'
        latex_environment(env, el, res )
      end

      def convert_pstart(el, opts)
        "\\pstart\n#{inner(el, opts)}\\pend\n"
      end

      def convert_inline_footnote(el, opts)
        letter = el.options[:footnote_level]
        cmd = if letter == 'B'
          "#{letter}footnote"
        else
          "footnote#{letter}"
        end
        lemma = if el.options[:lemma_short]
          "\\lemma{#{inner(el.options[:lemma_short], options)}}"
        else 
          ''
        end
        "{#{lemma}\\#{cmd}{#{latex_link_target(el)}#{inner(el, opts)}}}"
      end

      def convert_lemma(el, opts)
        @data[:packages] << 'eledmac'
        "\\edtext{#{inner(el, opts)}}"
      end

      def convert_citation(el, opts)
        @data[:packages] << 'natbib'

        res = el.children.map do |child|
          els = child.children
          prefix = Element.new(:text)
          #suffix = Element.new(:text)

          pos = els.find_index{|e| e.type == :cite_textual}

          prefix.children = els.shift(pos)
          key = els.shift.value

          location = nil

          els.reject! do |e|
            location = e.value if e.type == :cite_location
          end
          "\\citealp[#{inner(prefix, opts).strip}][#{location.to_s.strip}]{#{key}}#{inner(child, opts)}"
        end.join(', ')
        "\\citetext{#{res}}"
        ##  \citetext{see \citealp[][chap 2]{Fis00a}, or even better \citealp[][pp. 20-21]{Meskin2007}}
      end

      def convert_cite_textual(el, opts)
        cmd = el.options[:supress_author] ? '\citeyear' : '\citet'
        cmd <<   "{#{el.value}}"
      end

      def convert_cite_location(el, opts)
        el.value.strip
      end

      # subclassing and patching header to allow unnumbered headers in toc
      def convert_header(el, opts)
        type = @options[:latex_headers][output_header_level(el.options[:level]) - 1]
        if el.options[:unnumbered]
          el.attr['class'] = 'no_toc'
          "#{super.strip}\n\\addcontentsline{toc}{#{type}}{#{inner(el, opts)}}\n\n"
        else
          super
        end
      end

      def convert_sidenote(el, opts)
        @data[:packages] << 'eledmac'
        "\\ledsidenote{#{inner(el, opts)}}"
      end

    end


  end
end
