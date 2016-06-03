require "needle/actions"
require "needle/generator"

module Needle
	class CLI < Actions

		desc("new [project]", "Creates a new automation project")
		def new(project)
			require "needle/helpers/kickstart"
			# Setting instance variable for thor here
			# It is not the right place, just tesing out
			# for now
			@project = project
			Needle::Kickstart.new(project, self).run
		end

		register(
			Needle::Generator, 
			"generate", 
			"generate [COMMAND]", 
			"Delegates task to a subcommand"
		)
	end
end