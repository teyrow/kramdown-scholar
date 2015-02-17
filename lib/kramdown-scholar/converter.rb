# encoding: utf-8
#
module Kramdown
  module Converter

    class Html

      # def convert_pages(el, indent)
      #   "#{' '*indent}#{el.value}\n"
      # end
      def convert_scholar(el, opts)
         #TODO collect endnotes?
         inner(el, opts)
      end

      def convert_numbering(el, opts)
        inner(el, opts)
      end

      def convert_pstart(el, opts)
        inner(el, opts)
      end

      def convert_inline_footnote(el, opts)
        #binding.pry
        #el.options[:name] = el.options.to_s
        #e = el.children
        #e.options[:name] = el.options.to_s
        
        #convert_footnote(el, opts)
        #binding.pry
        number = @footnote_counter
        @footnote_counter += 1
        repeat = ''
        @footnotes << [number, el, number, 0]
        inner(el, opts)
        
        "<span style='color:red' title='#{inner(el,opts)}'>#{inner(el.options[:lemma_short],opts)}</span>" + 
        "<sup id=\"fnref:#{number}#{repeat}\"><a href=\"#fn:#{number}\" class=\"footnote\">#{number}</a></sup>"
      end

      def convert_lemma(el, opts)        
        #"<span style='color:red'>#{inner(el, opts)}</span>"
        ""
      end

      def convert_cite_location(el, opts)
        inner(el, opts)
      end
      # overrides 
      def convert_footnote(el, indent)
        repeat = ''

        #name = el.options[:lemma_short].children.first.value
        #if (footnote = @footnotes_by_name[name])
        #  number = footnote[2]
        #  repeat = ":#{footnote[3] += 1}"
        #else
          number = @footnote_counter
          name = number
          @footnote_counter += 1
          @footnotes << [name, el, number, 0]
          @footnotes_by_name[name] = @footnotes.last
        #end
        "<sup id=\"fnref:#{name}#{repeat}\"><a href=\"#fn:#{name}\" class=\"footnote\">#{number}</a></sup>"
      end    

    end



    class Kramdown

      # def convert_pages(el, opts)
      #   "*{{::pages}#{el.value}}\n"
      # end

    end

    class Latex
      alias_method :convert_header_orig, :convert_header
      alias_method :initialize_orig, :initialize

       def initialize(root, options)
         initialize_orig(root, options)
         @data[:endnotes] = Set.new
       end

      def convert_pages(el, opts)
        # TODO remove and use numbering
        @data[:packages] << 'eledmac' #Must be before eledpar
        @data[:packages] << 'eledpar'

        latex_environment('pages', el, inner(el, opts) ) <<   "\\Pages"
      end

      def convert_numbering(el, opts)
        @data[:packages] << 'eledmac' #Must be before eledpar
        @data[:packages] << 'eledpar' #? needed? 
        s = "\\beginnumbering\n#{latex_link_target(el)}#{inner(el, opts)}"
        #@data[:endnotes].each do |l|
        #  s << "\n\\doendnotes{#{l}}"
        #end
        s << "\\endnumbering\n"
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
        if @data[:use_endnotes]
          @data[:endnotes] << letter
          cmd = "#{letter}endnote"
        else 
          cmd = "#{letter}footnote"
        end
        #cmd = if letter == 'B' or true
        #  "#{letter}endnote"
        #else
        #  "footnote#{letter}"
        #end
        lemma = if el.options[:lemma_short]
          separator = @data[:use_endnotes] ? '\rbracket' : ''
          "\\lemma{#{inner(el.options[:lemma_short], options)}#{separator}}"
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
          "#{convert_header_orig(el, opts).strip}\n\\addcontentsline{toc}{#{type}}{#{inner(el, opts)}}\n\n"
        else
          convert_header_orig(el, opts)
        end
      end

      def convert_sidenote(el, opts)
        @data[:packages] << 'eledmac'
        "\\ledsidenote{#{inner(el, opts)}}"
      end

      def convert_scholar(el, opts)
        @data[:use_endnotes] = true
        inner(el, opts)
      end

    end


  end
end
