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

people = {}
CSV.foreach(input_file, headers: true, header_converters: :symbol) do |row|
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

CSV.open(input_file, 'w') do |csv|
  csv << %w[name last_paired_with]
  people.each_value do |p|
    csv << [p[:name], p[:last_paired_with]]
  end
end
