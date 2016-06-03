require "needle/actions"

module Needle
	class Generator < Actions 
		desc("project [name]", "Generates a new project")
		def project(name)
			say("Creating new project #{name}", :green)
		end
	end
end