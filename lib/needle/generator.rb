require "needle/actions"

module Needle
	class Generator < Actions 
		desc("project [name]", "Generates a new project")
		def project(name)
			require "needle/helpers/project"
			@project_name = name
			Needle::Project.new(name, self).run
		end

		desc(
			"testcase [name]", 
			"Generates a new testcase. \n" +
			"This command should be run from inside the project directory"
		)
		def testcase(name)
			require "needle/helpers/testcase"
			# Setting global variables for 
			# template action
			@project_name = File.basename(Dir.pwd)
			@name = name
			Needle::Testcase.new(name, self).run
		end

		desc(
			"testsuite [name]", 
			"Generates a new testsuite\n" + 
			"All existing testcases are appened to the suite\n" +
			"This command should be run from inside the project directory"
		)
		def testsuite(name)
			require "needle/helpers/testsuite"
			Needle::Testsuite.new(name, self).run
		end
	end
end