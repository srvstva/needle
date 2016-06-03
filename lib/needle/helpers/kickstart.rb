module Needle
	class Kickstart
		attr_reader :name
		attr_reader :thor

		def initialize(name, thor)
			@name = name
			@thor = thor
		end

		def run
			thor.say("Creating new automation project #{name} ...", :green)
			thor.empty_directory(name)
			apply_templates
		end

		def remove
			thor.remove_dir(name)
		end

		private 
			def apply_templates
				thor.template(
					"templates/build.project.xml.erb", 
					"#{name}/build.xml"
				)	
				thor.directory(
					"templates/lib", 
					"#{name}/lib"
				)
				thor.directory(
					"templates/bin", 
					"#{name}/bin"
				)
				thor.directory(
					"templates/include",
					"#{name}/include"
				)
			end
	end
end