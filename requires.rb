require "gosu"
require 'chipmunk'
require_relative "./game.rb"
require_relative "./player.rb"
require_relative "./enemy.rb"
require_relative "./ui.rb"
include Gosu

SUBSTEPS = 4
BLACK=Gosu::Color::BLACK
GREEN=Gosu::Color::GREEN
YELLOW=Gosu::Color::YELLOW
BLUE=Gosu::Color::BLUE
WHITE=Gosu::Color::WHITE
GRAY=Gosu::Color::GRAY

module CP
	class Space
		attr_reader :active_shapes
	end
end