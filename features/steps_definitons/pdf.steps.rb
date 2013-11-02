require 'kramdown-scholar'
require 'rake'
def results
  File.join 'features', 'results'
end

Given(/^I have markdownfile "(.*?)"$/) do |basename|
  @basename = basename
  @infile = File.join('spec', 'fixtures', "#{basename}.md" )
  expect(File).to exist(@infile)
end

When(/^I create "(.*?)" from template "(.*?)"$/) do |outputformat, template|
  @doc = Kramdown::Document.new(
    File.read(@infile), 
    :input => 'KramdownScholar',
    :template => "data/kramdown/#{template}"
  )
  @latex = File.join(results, "#{@basename}.tex")
  File.open(@latex, "w") do |file| 
    file.puts @doc.instance_eval("to_#{outputformat}")
  end

end

When(/^I create pdf from the latexfile$/) do
  sh "xelatex --output-directory #{results} -halt-on-error #{@latex} " do |ok, res|
    ok.should be_true
  end 
end

Then(/^the pdf should be created without error$/) do
  pdf = File.join(results, @basename.ext('pdf'))
  expect(File).to exist(pdf)
end