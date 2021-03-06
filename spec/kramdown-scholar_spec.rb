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

begin
  require 'pry'
rescue LoadError
  puts "pry is not required"
  puts "Do not pry..."
end
describe Kramdown::Parser::KramdownScholar do
  fixtures_path = File.expand_path("../fixtures", __FILE__)
  FileList.new("#{fixtures_path}/*.md").each do |f|
    fixture = File.basename(f, '.md')
    next if fixture.start_with? '_'

    text = File.read(f)
    context "when parsing #{fixture}.md" do
      opts = {:input => 'KramdownScholar'}
      optfile = fixture.ext('yml')
      opts.merge!(YAML::load_file(optfile)) if File.exists?(optfile)
      
      doc = ::Kramdown::Document.new(File.read(f), opts)
      p doc.warnings if doc.warnings.any?

      FileList.new("#{fixtures_path}/#{fixture}.*").exclude("**/*.md").each do |f|
        format  = File.extname(f).delete('.')
        it "converts correct to #{format}" do
          expected = File.read(f)
          
          res = doc.send("to_#{format}".to_sym)
          File.open("result/"  + File.basename(f), "w") { |file| file.puts res.strip }
          expect(res.strip).to eql(expected.strip), res.inspect
        end
      end

    end
  end
end
