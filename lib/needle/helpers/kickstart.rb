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
			copy_templates
		end

		private 
			def copy_templates
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
			end
	end
end