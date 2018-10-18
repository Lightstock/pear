#!/usr/bin/env ruby

require 'csv'

if ARGV[-1].nil?
  puts 'Usage: pear.rb input.csv'
  exit
end

input_file = ARGV[-1].strip

unless input_file =~ /.*\.csv$/i
  puts "ERROR: CSVs only (input: #{input_file})"
  exit
end

csv = CSV.open(input_file, 'r+', headers: true, header_converters: :downcase)
rows = csv.read

unless csv.headers.include? 'name'
  puts 'CSV must have a header row, with one of the columns being "Name"'
  puts "Headers: #{csv.headers&.to_a&.join(', ')}"
  exit
end

puts rows
