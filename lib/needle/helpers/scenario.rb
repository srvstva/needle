module Needle
	class Project
		attr_reader :name
		attr_reader :thor

		def initialize(name, thor)
			@name = name
			@thor = thor 
		end

		def run
			thor.template(
					"templates/scenarion.conf.erb", 
					"scenarios/#{name}.conf"
			)
			# If there is no directory matching
			# the testcase name with scenario name
			# we just return from the code
			# Else we add scenario information 
			# to the testcase.conf file
			# We are also overriding the existing file
			return unless File.directory?("testcases/#{name}")
			
			thor.create_file(
				"testcases/#{name}/testcase.conf", 
				"SCENARIO_NAME automation/#{project_name}/#{name}\n" +
				"DESCRIPTION Scenario for #{project_name} and #{name}\n",
				:force => true
			)
			end
		end
	end
end