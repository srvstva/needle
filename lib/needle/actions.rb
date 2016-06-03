require "thor"

module Needle
	class Action < Thor
		inclue Thor::Actions 

		def self.source_root
			File.expand_path("../../../", __FILE__)
		end
	end
end