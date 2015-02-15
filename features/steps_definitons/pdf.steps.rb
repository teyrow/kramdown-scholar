require 'kramdown-scholar'
require 'rake'

include  Rake::DSL

def results
  File.join 'features', 'results'
end

Given(/^I have markdownfile "(.*?)"$/) do |basename|
  @basename = basename
  @infile = File.join('spec', 'fixtures', "#{basename}.md" )
  expect(File).to exist(@infile)
end

When(/^I create "(.*?)" from template "(.*?)"$/) do |outputformat, template|
  opts ={:input => 'KramdownScholar', :template => "data/kramdown/#{template}"}  #TODO, share with spec
  optsfile = @infile.ext('yml')
  opts.merge!(YAML::load_file(optsfile)) if File.exists?(optsfile)
  @doc = Kramdown::Document.new(File.read(@infile),opts )

  @latex = File.join(results, "#{@basename}.tex")
  File.open(@latex, "w") do |file| 
    file.puts @doc.instance_eval("to_#{outputformat}")
  end

end

When(/^I create pdf from the latexfile$/) do
  sh "latexmk -cd -silent -xelatex  #{@latex} " do |ok, res|
    %w(pdf log).each do |ext|
      puts "<a href='#{@basename.ext(ext)}'>#{ext}</a>"
    end
    expect(ok).to be_truthy
  end 
end

Then(/^the pdf should be created without error$/) do
  pdf = File.join(results, @basename.ext('pdf'))
  expect(File).to exist(pdf)
end
