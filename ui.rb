class Splash
	def initialize
		#@font = Gosu::Font.new($window, "Arial", 40)
		@i=0
		#@text="Splash page"
		@img=Image.new("img/splash.png")
	end
	
	def update
		@i+=1
		$window.beep.play if @i==10
		if @i==300
			$window.gotitle
		end
	end
	
	def draw
		@img.draw(160,490,1)
	end
	
	def button_down(id)
		$window.gotitle if id==KbEscape or id==KbReturn
	end
	
end

class Title
	def initialize
		@font = Gosu::Font.new($window, "Arial", 50)
		@font2 = Gosu::Font.new($window, "img/atari full.ttf", 20)
		@i=0
		@title="Fall of Atlantis"
		@text1="Press ENTER for classic controls"
		@text2="Press SPACE for alternative controls"
		@texton=true
		$window.explode.play
	end
	
	def update
		@i+=1
		if @i.modulo(10)==0
			if @texton==false
				@texton=true
			else
				@texton=false
			end
		end
	end
	
	def draw
		@font.draw(@title, 240, 250, 1, 1.0, 1.0, 0xffffffff)
		@font2.draw(@text1, 50, 350, 1, 1.0, 1.0, YELLOW) if @texton==true
		@font2.draw(@text2, 50, 390, 1, 1.0, 1.0, BLUE) if @texton==true
	end
	
	def button_down(id)
		$window.startgame(0) if id==KbReturn
		$window.startgame(1) if id==KbSpace
	end
	
end