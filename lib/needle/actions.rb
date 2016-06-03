require "thor"

module Needle
	class Actions < Thor
		include Thor::Actions 

		def self.source_root
			File.expand_path("../../../", __FILE__)
		end
	end
end