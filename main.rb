require_relative "./requires.rb"

class Game < Window
	attr_reader :state, :explode, :shot, :beep
	def initialize
		super(800, 600, false)
		$window=self
		self.caption = "Fall of Atlantis"
		@explode = Gosu::Sample.new(self, "sounds/Explosion.ogg")
		@shot = Gosu::Sample.new(self, "sounds/shot.ogg")
		@beep = Gosu::Sample.new(self, "sounds/beep.ogg")
		@state=Splash.new
	end	
	
	def startgame(control)
		@state=Manager.new(control)
	end
	
	def gotitle
		@state=Title.new
	end
	
	
	def needs_cursor?
		true
	end
	
	def update
		@state.update	
		
		self.caption = "Fall of Atlantis #{Gosu::fps} fps"
	end
	
	def draw
		@state.draw
	end
	
	def button_down(id)
		@state.button_down(id)	
	end
	
end

#srand 242
Game.new.show
