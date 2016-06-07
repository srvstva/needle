require "needle/actions"
require "needle/generator"

module Needle
  class CLI < Actions

    desc("new [PROJECT]", "Creates a new automation project")
    def new(project)
      require "needle/helpers/kickstart"
      Needle::Kickstart.new(project, self).run
    end

    desc("destroy [PROJECT]", "Destroys the given project")
    def destroy(project)
      require "needle/helpers/kickstart"
      Needle::Kickstart.new(project, self).remove
    end

    register(
      Needle::Generator, 
      "generate", 
      "generate [COMMAND]", 
      "Delegates task to a subcommand"
    )
  end
end