#!/usr/bin/env ruby
require File.join( File.dirname(__FILE__), '../../lib/blackbook.rb' )
require File.join( File.dirname(__FILE__), '../lib/open_in_browser.rb' ) # use page.open_in_browser to see scraped page in browser

require 'optparse'

options = {}
importer = :auto

opts = OptionParser.new do |opts|
  opts.on("-u USERNAME") do |username|
    options[:username] = username
  end
  opts.on("-p PASSWORD") do |password|
    options[:password] = password
  end
  opts.on("-i [IMPORTER]") do |importer_name|
    importer = importer_name.to_sym
  end
  opts.on("-x [EXPORTER]") do |exporter_name|
    options[:as] = exporter_name.to_sym
  end
end

opts.parse!(ARGV)

puts contacts = Blackbook.get( importer, options )
