require "needle/actions"

module Needle
	class Generator < Actions 
		desc("project [NAME]", "Generates a new project")
		def project(name)
			require "needle/helpers/project"
			@project_name = name
			@project_root = File.basename(Dir.pwd)
			Needle::Project.new(name, self).run
		end

		desc(
			"testcase [NAME]", 
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
			"testsuite [NAME]", 
			"Generates a new testsuite\n" + 
			"All existing testcases are appened to the suite\n" +
			"This command should be run from inside the project directory"
		)
		def testsuite(name)
			require "needle/helpers/testsuite"
			Needle::Testsuite.new(name, self).run
		end

		desc(
			"scenario [NAME]", 
			"Generates a new scenario\n" + 
			"Adds the scenario information to testcase.conf if any testcase exists with same scenarios\n" +
			"This command should be run from inside the project directory"
		)
		def scenario(name)
			require "needle/helpers/scenario"
			# Project name is the name of the parent directory 
			# we are working in. 
			# The automation base directory
			@project_name = File.basename(Dir.pwd)
			@name = name
			Needle::Scenario.new(name, self).run
		end

		desc(
			"iteration [NAME][TESTCASE]", 
			"Adds the specified testcase to the iteration.spec file\n" + 
			"This command should be run from inside the project directory"
		)
		def iteration(name, testcase)
			require "needle/helpers/iteration"
			Needle::Iteration.new(name, testcase, self).run
		end
	end
end