#gem 'chipmunk', '~>5.3.4.5'
require "gosu"
require 'chipmunk'
require_relative "./game.rb"
require_relative "./player.rb"
require_relative "./enemy.rb"
require_relative "./ui.rb"
#require_relative "./chipmunk.so"
include Gosu

SUBSTEPS = 4
BLACK=Gosu::Color::BLACK
GREEN=Gosu::Color::GREEN
YELLOW=Gosu::Color::YELLOW
BLUE=Gosu::Color::BLUE
WHITE=Gosu::Color::WHITE
GRAY=Gosu::Color::GRAY
RED=Gosu::Color::RED

module CP
	class Space
		attr_reader :active_shapes
	end

end

=begin
	module Shape
		class Circle
			def object=(o)
				@object=o
			end
			
			def object
				@object
			end
		end
		class Poly
			def object=(o)
				@object=o
			end
			
			def object
				@object
			end
		end
		class Segment
			def object=(o)
				@object=o
			end
			
			def object
				@object
			end
		end
	end
=end
