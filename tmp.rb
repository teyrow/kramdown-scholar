require 'bundler'
Bundler.require(:default, :development)

text = <<-HTML
PAGES:

more random *apa* 
slutp

:PAGES
mer text
HTML


doc = Kramdown::Document.new(text, :input => 'KramdownScholar')
puts doc.to_latex
puts doc.warnings if doc.warnings.any?
#puts doc.to_html