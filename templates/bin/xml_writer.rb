#!/usr/bin/env ruby1.9.1
# Name: xml_writer.rb
# Purpose: Parse the testresult file and convert to XML 
# Author: Ankur Srivastava<ankur.srivastava@cavisson.com>
# Convention: Indentation using 4 spaces, no tabs
# Last Modified: 
#     1. 9/7/2015 (Initial Version)
# Limitations:
#     1. Requires rubygem 'nokogiri' to be pre installed in the 
#        system
#     2. Requires ruby >= 1.9.1
#
# To install nokogiri : sudo gem1.9.1 install nokogiri

# Import libraries
require 'nokogiri'
require 'optparse'


# Process test results file and return a list
# of records
def process_test_results(infile, outfile)
    # Empty array list
    results = []

    # Open the input file and process it line by line.
    # the Obj.each() method excepts a block and performs the operation
    File.open(infile).each do |line|
        # Continue next iteration if line starts with any of these
        next if line.start_with? "TestID", "Failed"
       
        # Split the lines in a tuple and store in local variables
        _id, testrun, component, category, status, desc = line.split(",")

        # Push array of :name=>value pairs into the results array.
        # Resulting array is a multi-dimension array of following forma
        # results = [[:id=>'SMOKE-001', :testrun=>"TR1024", :status=>'PASS', ..],
        #            [:id=>'SMOKE-002', :testrun=>"TR1025", :status=>'FAIL', ..]]
        results << [:id => _id, :testrun => testrun, :component => component,
                    :category => category, :status => status, :desc => desc]
    end
    # Return the results array.
    # Note that we need not to specify return, as Ruby does it explicitly
    # The last statement is evaluated and returned from the function
    results 
end


# Write the records in a XML format.
# Returns XML representation of the doc
def write_testcase_doc(results, name="NA", total=0, success=0, failures=0)
    # Generates the XSD in following format
    # <testsuites>
    #     <testsuite name="smoke" total="10" failures="5" success="5">
    #         <testcase id="SMOKE-001-001">
    #             <testrun>TR1024</testrun>
    #             <status>Pass</status>
    #             <desc>Flowpath case </desc>
    #          </testcase>
    #      </testsuite>
    # </testsuites>
    builder = Nokogiri::XML::Builder.new do |xml|
        xml.testsuites do
            xml.testsuite(:name=>name, :total=>total, :success=>success, :failures=>failures) do
                results.each do|result|
                    # For each result create a testcase node and add testrun
                    # status, desc as child node. 
                    # Each testcase node is associated with an attribute
                    # called 'id'
                    result.each do |r|
                        xml.testcase(:id=>r[:id]) do
                            xml.testrun r[:testrun]
                            xml.status r[:status]
                            # remove trailing whitespace and new line
                            # using chomp
                            xml.desc r[:desc].chomp
                        end
                    end
                end
            end
        end
    end
    # Return the XML representation of the in memory doc
    # indented by four whitespaces.
    builder.to_xml(indent:2, indent_text: ' ')
end


# Command line parsing using inbuilt Optionparser
# Returns the options hash and the parser object
# as an array
def parse_cmd()
    options = {}
    parser = OptionParser.new do |opts|
        opts.on("-i", "--infile FILE", "The input test result file. This is mandatory argument") do |f|
            options[:infile] = f
        end

        opts.on("-o", "--outfile OUT", "Write Parsed XML output to") do |o|
            options[:outfile] = o
        end

        opts.on("-n", "--name NAME", "The name of the testsuite") do |name|
            options[:name] = name
        end

        opts.on("-f", "--failures FAILURE", "Total no of failures") do |failures|
            options[:failures] = failures
        end

        opts.on("-s", "--success SUCCESS", "Total success count") do |success|
            options[:success] = success
        end

        opts.on("-t", "--total TOTAL", "Total testcase count") do |total|
            options[:total] = total
        end
        opts.on_tail("-h", "--help", "Show this message") do
           puts opts
        end
    end
    parser.parse!
    [options, parser]
end


# Entry point for our little app
# Does command line parsing, validation of arguments
# and then calls appropriate methods to generate the results
def main
    options, parser = parse_cmd

    infile = options[:infile]  if options[:infile]
    outfile = options[:outfile] if options[:outfile]
    testname = options[:name] if options[:name]
    total = options[:total] if options[:total]
    failures = options[:failures] if options[:failures]
    success = options[:success] if options[:success]

    # Safety check for mandatory argument.
    # Prints the programs help menu when no options 
    # are provided in the command line
    if infile.nil?
        puts "Error: Mandatory argument missing."
        puts parser.help
        exit 1
    end
    
    results = process_test_results(infile, outfile)
    content = write_testcase_doc(results, testname, total, success, failures)

    # If outfile is not nil and provided by enduser, write to it
    if !outfile.nil?
        puts "Writing to #{options[:outfile]}"
        File.open(options[:outfile], 'w') do |f|
            f.write(content)
        end
    else
        puts content
    end
end


# Run this program only when called manually. 
# This prevents it from running when loaded 
# in external programs
if __FILE__ == $0
    main
end
