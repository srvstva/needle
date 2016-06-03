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

			if File.exist?("build.xml")
				thor.insert_into_file("build.xml", :after => "<!--New targets to come-->\n") do
					<<-CONTENT
	<target name="#{name}" depends="get-build-info" description="Run #{name.capitalize} testsuite">
			<ant antfile="${#{name}.ant.file}" target="#{name}" useNativeBasedir="true"/>
 	</target>
					CONTENT
				end
			end
		end
	end
end