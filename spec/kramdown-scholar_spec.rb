# encoding: utf-8
#
# kramdown-scholar_spec.rb - kramdown-scholar RSpec tests
# Copyright (C) 2012 Matteo Panella <morpheus@level28.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'kramdown-scholar'
require 'rake'


describe Kramdown::Parser::KramdownScholar do
  fixtures_path = File.expand_path("../fixtures", __FILE__)
  FileList.new("#{fixtures_path}/*.md").each do |f|
    text = File.read(f)
    fixture = File.basename(f, '.md')
    
    context "when parsing #{fixture}" do
      doc = ::Kramdown::Document.new(File.read(f), :input => 'KramdownScholar')
    
      it "converts to valid latex" do
        expected = File.read(File.join(fixtures_path, "#{fixture}.tex"))
        doc.to_latex.should eql(expected)
      end
    
    end
  end
end
