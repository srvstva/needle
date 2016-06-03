require "needle/actions"
require "needle/generator"

module Needle
	class CLI < Actions

		desc("new [project]", "Creates a new automation project")
		def new(project)
			say("Creating new #{project}")
		end

		register(
			Needle::Generator, 
			"generate", 
			"generate [COMMAND]", 
			"Delegates task to a subcommand"
		)
	end
end