require "needle/actions"

module Needle
	class Generator < Actions 
		desc("project [name]", "Generates a new project")
		def project(name)
			require "needle/helpers/project"
			Needle::Project.new(name, self).run
		end
	end
end