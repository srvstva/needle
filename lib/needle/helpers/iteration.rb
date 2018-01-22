module Needle
  class Iteration
    attr_reader :name
    attr_reader :thor
    attr_reader :testcase

    def initialize(name, testcase, thor)
      @name = name
      @testcase = testcase
      @thor = thor
    end

    def run
      return unless File.exists?("testcases/#{testcase}/iteration.spec")
      thor.insert_into_file("testcases/#{testcase}/iteration.spec", :before => "#END_ITERATION\n") do
        "#{name}|10|ALL IMMEDIATELY|SESSIONS 10|ALL IMMEDIATELY|hpd_tours|127.0.0.1 192.168.255.2 -|1|ALL 1|ALL 1 0 2000|ALL ALL 1|ALL ALL 3 10 50|ALL 1|ALL 0 0 0 0|default\n"
      end
      funcname = name.tr("-", "_").downcase
      thor.insert_into_file("testcases/#{testcase}/check_status", :before => "# End case def\n") do
        "    \"#{name}\") handle_#{funcname}_case ;;\n"
      end

      thor.insert_into_file("testcases/#{testcase}/check_status", :before => "# Call to main function\n") do
        <<-EOC
# TODO:
# 1. Add logic to validate case #{name}
# 2. Depending upon evaluation update the status with your own description
function handle_#{funcname}_case() {
  log_status_int "FAIL" "Testcase #{name} has yet not been implemented"
}

        EOC
      end
    end
  end
end
