module Needle
	class Kickstart
		attr_reader :name
		attr_reader :thor

		def initialize(name, thor)
			@name = name
			@thor = thor
		end

		def run
			unless ant_available?
				thor.say("Ant is not installed in system", :red)
				thor.say("Automation needs ant to run. To install 'ant' run command")
				thor.say("  # apt-get install ant")
				thor.say("Or visit http://ant.apache.org/bindownload.cgi")
				return
			end
			thor.say("Creating new automation project #{name} ...", :green)
			thor.empty_directory(name)
			apply_templates
			init_git
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
				thor.template(
					"templates/bin/generate_report.py", 
					"#{name}/bin/generate_report.py",
					:force => true
				)
				Dir.glob("#{name}/bin").each do |f| 
					thor.chmod f, 0755
				end
			end

			def init_git
				unless git_available?
					thor.say("[NOTICE]", :yellow)
					puts("Looks like git is not available in your system")
					puts("It is recommended to install git for version controlling your project")
					puts("To install run command 'apt-get install git' with root access")
					return
				end
				Dir.chdir(name) do ||
					`git init`
					`git add .`
					thor.say("Intialized git repo in #{File.absolute_path('.')}")
				end
			end

			def git_available?
				output = `which git`
				# If command rest
				return false if output.empty?
				output.chomp!
				return File.exist?(output)
			end

			private
				def ant_available?
					guess = `which ant`.chomp
					return false if guess.empty?
					return File.exist?(guess)
				end
	end
end