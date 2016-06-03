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
			thor.template(
					"templates/build.xml.erb", 
					"#{name}/build.xml"
			)
			["scripts", "scenarios", "topology", "mprof"].each do |dest|
				thor.empty_directory("#{name}/#{dest}")
			end
		end
	end
end