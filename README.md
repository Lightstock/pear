# Pear: Pair People Together

## Installation
1. Download [pear.rb](https://raw.githubusercontent.com/Lightstock/pear/master/pear.rb) to the directory of your choosing
2. Write a CSV file with a header containing the column "name", and a list of names below it, one per row. See [input.csv](https://github.com/Lightstock/pear/blob/master/input.csv) as a sample (`last_paired_with` is optional, and will be written automatically on first run).
3. Give pear.rb the execute permission (either via the GUI or `chmod +x pear.rb`)

## Requirements
Ruby 2.3+. No special gems, all stdlib.

## Usage
`./pear.rb [options] input.csv`

1. Open Terminal
2. Navigate to the appropriate directory (`cd /path/to/pear.rb`)
3. For standard operation: `./pear.rb input.csv`
4. To exclude specific people from a run: `./pear.rb -e "Jerry Gergich, Toby Flenderson" input.csv`
