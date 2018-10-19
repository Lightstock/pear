#!/usr/bin/env ruby

require 'csv'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-e', '--exclude STRING,STRING', 'Exclude names from this run') do |x|
    options[:exclude] = x.split(',')
  end
end.parse!

if ARGV[-1].nil?
  puts 'Usage: pear.rb [options] input.csv'
  exit
end

options[:in] = ARGV[-1].strip

unless options[:in] =~ /.*\.csv$/i
  puts "ERROR: CSVs only (input: #{options[:in]})"
  exit
end

people = {}
CSV.foreach(options[:in], headers: true, header_converters: :symbol) do |row|
  unless row.headers.include? :name
    puts 'CSV must have a header row, with one of the columns being "Name"'
    puts "Headers: #{row.headers&.to_a&.join(', ')}"
    exit
  end

  people[row[:name]] = { name: row[:name],
                         last_paired_with: row[:last_paired_with] }
end

@names = people.keys.uniq.shuffle
off_last_time = people.select { |_k, v| v[:last_paired_with].nil? }.keys.shuffle
off_last_time.each do |name|
  @names.delete(name)
  @names.unshift(name)
end

options[:exclude]&.each do |n|
  name = n&.strip
  if @names.delete(name)
    people[name][:last_paired_with] = nil
    puts "#{name}: Excluded"
  end
end

pairs_count = @names.length / 2

pairs_count.times do
  person = people[@names.shift]
  available_matches = @names.reject { |name| name == person[:last_paired_with] }
  pair = available_matches.sample
  person[:last_paired_with] = pair
  people[pair][:last_paired_with] = person[:name]
  @names.delete(pair)

  puts "#{person[:name]} & #{person[:last_paired_with]}"

  pairs_count -= 1
end

unless @names.length.zero?
  person = people[@names.shift]

  people[person[:name]][:last_paired_with] = nil

  puts "#{person[:name]}: Bye Week"
end

CSV.open(options[:in], 'w') do |csv|
  csv << %w[name last_paired_with]
  people.each_value do |p|
    csv << [p[:name], p[:last_paired_with]]
  end
end
