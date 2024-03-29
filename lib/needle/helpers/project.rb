module Needle
  class Project
    attr_reader :name
    attr_reader :thor

    def initialize(name, thor)
      @name = name
      @thor = thor 
    end

    def run
      opts = {
        :base => File.basename(Dir.pwd),
        :project => name
      }
      thor.empty_directory(name)
      thor.template(
          "templates/build.xml.erb", 
          "#{name}/build.xml",
          opts
      )
      ["scripts", "scenarios", "topology", "mprof"].each do |dest|
        thor.empty_directory("#{name}/#{dest}")
      end
      thor.directory(
        "templates/script/hpd_tours",
        "#{name}/scripts/hpd_tours"
      )

      thor.directory(
        "templates/topology/default",
        "#{name}/topology/default"
      )

      thor.template(
        "templates/project.properties.erb",
        "#{name}/etc/#{name}.properties",
        opts
      )
      thor.template(
        "templates/include/mail.properties",
        "#{name}/etc/mail/mail.properties",
      )
      thor.empty_directory("#{name}/etc/mail/.out")
      
      if File.exist?("build.xml")
        thor.insert_into_file("build.xml", :before => "<!--End property definition-->\n") do
          "  <property name=\"#{name}.ant.file\" value=\"${basedir}/#{name}/build.xml\"/>\n"        
        end
        
        thor.insert_into_file("build.xml", :after => "<!--Target definition-->\n") do
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