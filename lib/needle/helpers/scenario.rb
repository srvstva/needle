module Needle
  class Scenario
    attr_reader :name
    attr_reader :thor

    def initialize(name, thor)
      @name = name
      @thor = thor 
    end

    def run
      opts = {
        :project => File.basename(Dir.pwd),
        :testcase => name
      }
      thor.template(
          "templates/scenario/scenario.conf.erb", 
          "scenarios/#{name}.conf"
      )
      # If there is no directory matching
      # the testcase name with scenario name
      # we just return from the code
      # Else we add scenario information 
      # to the testcase.conf file
      # We are also overriding the existing file
      return unless File.directory?("testcases/#{name}")
      
      thor.template(
        "templates/testcase/testcase.conf",
        "testcases/#{name}/testcase.conf",
        opts
        #:force => true
      )
    end
  end
end