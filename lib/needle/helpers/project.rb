module Needle
	class Project
		attr_reader :name
		attr_reader :thor

		def initialize(name, thor)
			@name = name
			@thor = thor 
		end

		def run
			thor.empty_directory(name)
		end
	end
end