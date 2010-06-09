require 'rubygems'
require 'hoe'

Hoe.plugin :yard

require './lib/ruby_units/units'
require './lib/ruby_units/ruby-units'

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.test_files = FileList['test/test*.rb']
    #t.verbose = true     # uncomment to see the executed command
  end
rescue
end

Hoe.spec 'ruby-units' do 
  self.yard_title = "Ruby-Units"
  self.yard_markup = "markdown"
  self.version = Unit::VERSION
  self.rubyforge_name = 'ruby-units'
  self.summary = %q{A class that performs unit conversions and unit math}
  self.email = 'kevin.olbrich+ruby_units@gmail.com'
  self.url = 'http://github.com/olbrich/ruby-units'
  self.description = "This library handles unit conversions and unit math"
  self.changes = self.paragraphs_of('CHANGELOG.txt', 0..1).join("\n\n")
  self.author = 'Kevin Olbrich, Ph.D'
end
