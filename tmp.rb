require 'bundler'
Bundler.require(:default, :development)

text = <<-HTML
PAGES:
more random *apa* 
slutp

{::pages}
Some nice text *that* wrap 
{:/pages}

HTML


doc = Kramdown::Document.new(text, :input => 'KramdownScholar')
puts doc.to_latex
#puts doc.to_html