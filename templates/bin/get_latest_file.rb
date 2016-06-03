#!/usr/bin/env ruby

require 'optparse'

# Command line parsing using option
# parse. 
# All the parsed command line arguments
# are avalaible in the options HASH
def parse_arguments
    options = {}
    parser = OptionParser.new do |opts|
        opts.on("-d", "--dir DIR", "absolute or relative path of the directory") do |arg|
            options[:dir] = arg
        end

        opts.on("-p", "--pattern PATTERN", "search pattern - can contain asterisk(*) as wildcard") do |arg|
            options[:pattern] = arg
        end
    end
    parser.parse!
    [options, parser]
end

# Returns the latest file based on the pattern
def get_latest_file(dir, pattern)
    # Get list of files using the pattern and max'es out
    # the file according to sort criteria.
    # Sort criteria is based on creation time
    Dir.glob(File.join(dir, pattern)).max do |f1, f2|
        File.ctime(f1) <=> File.ctime(f2)
    end
end


# Runs the script only when not called loaded via module
if __FILE__ == $0
    options, parser = parse_arguments
    # Print help and exit in case arguments are missing
    if options[:dir].nil? || options[:pattern].nil?
        puts parser.help
        exit
    end

    f = get_latest_file(options[:dir], options[:pattern])

    # Print output only when not NULL or None or Nill
    puts f if !f.nil?
end

