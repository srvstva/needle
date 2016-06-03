module Needle
	class Testsuite
		attr_reader :name
		attr_reader :thor

		def initialize(name, thor)
			@name = name
			@thor = thor 
		end

		def run
			testcases = Array.new
			if File.directory?("#{name}")
				testcases = Dir.entries("testcase").reject do |f|
					# Reject symlinks to directories
					# starting with '.' and '..'
					f.start_with?(".", "..")
				end
				# in place sort the array
				testcases.sort!
			end
			thor.create_file("testsuites/#{name}.conf")
			testcases.each do |testcase|
				thor.append_to_file(
					"testsuites/#{name}.conf",
					"TEST_CASE_NAME #{testcase} Continue 1 1\n",
					:verbose => false
				)
			end
		end
	end
end