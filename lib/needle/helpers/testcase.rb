module Needle
  class Testcase
    attr_reader :name
    attr_reader :thor

    def initialize(name, thor)
      @name = name
      @thor = thor
    end

    def run
      thor.empty_directory("testcases/#{name}")
      apply_templates
    end

    def remove
      thor.remove_dir(name)
    end

    private 
      def apply_templates
        opts = {
          :project => File.basename(Dir.pwd),
          :testcase => name
        }
        
        thor.template(
          "templates/testcase/iteration.spec", 
          "testcases/#{name}/iteration.spec",
        )
        thor.template(
          "templates/testcase/pre_test_setup", 
          "testcases/#{name}/pre_test_setup"
        )
        thor.template(
          "templates/testcase/post_test_setup",
          "testcases/#{name}/post_test_setup"
        )
        thor.template(
          "templates/testcase/check_status",
          "testcases/#{name}/check_status",
          opts
        )
        thor.template(
          "templates/testcase/testcase.conf",
          "testcases/#{name}/testcase.conf",
          opts
        )
        thor.template(
          "templates/scenario/scenario.conf.erb",
          "scenarios/#{name}.conf"
        )
        # Replacing (hyphen) from testcase and adding to
        # testsuite joining with _
        project_root = opts[:project]
        suite_name = project_root.tr("-", "_").downcase
        suite_name = "#{suite_name}.conf"
      
        if File.exists? "testsuites/#{suite_name}"
          thor.append_to_file("testsuites/#{suite_name}") do ||
            "TEST_CASE_NAME #{name} Continue 1 1\n"
          end
        else
          thor.create_file("testsuites/#{suite_name}") do ||
            "TEST_CASE_NAME #{name} Continue 1 1\n"
          end
        end
      end
  end
end