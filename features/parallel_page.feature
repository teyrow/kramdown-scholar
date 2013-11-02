Feature: Parallel pdf
  In order to use kramdown for langauge transcriptions
  As a editor
  I want write markdown and produce parallell pages output

Scenario: Parallel pages
  Given I have markdownfile "parallel"
  When I create "latex" from template "article" 
  And I create pdf from the latexfile
  Then the pdf should be created without error
  