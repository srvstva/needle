require "needle/actions"
require "needle/generator"

module Needle
	class CLI < Actions

		desc("new [PROJECT]", "Creates a new automation project")
		def new(project)
			require "needle/helpers/kickstart"
			# Setting instance variable for thor here
			# It is not the right place, just testing out
			# for now
			# TODO: Need a workaround for this. Not working
			# while passing the class variable and applying
			# template. It has to be defined here only
			@project = project
			Needle::Kickstart.new(project, self).run
		end

		desc("destroy [PROJECT]", "Destroys the given project")
		def destroy(project)
			# This removes the project and empties the directories
			# No templating is required here
			require "needle/helpers/kickstart"
			Needle::Kickstart.new(project, self).remove
		end

		register(
			Needle::Generator, 
			"generate", 
			"generate [COMMAND]", 
			"Delegates task to a subcommand"
		)
	end
end