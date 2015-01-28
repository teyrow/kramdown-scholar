Feature: Pdf creation
  In order to use kramdown for langauge transcriptions
  As an editor
  I want write markdown and produce pdf output

Scenario Outline: pdf generation
  Given I have markdownfile "<mdfilename>"
  When I create "latex_scholar" from template "<template>" 
  And I create pdf from the latexfile
  Then the pdf should be created without error

  Examples:
    | mdfilename          | template |
    | parallel            | article.latex_scholar  |
    | ed_text             | article.latex_scholar  |
    | citations           | article.latex_scholar  |
    | scholar             | article.latex_scholar  |
