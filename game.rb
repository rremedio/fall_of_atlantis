class Manager
	attr_reader :i, :enemies, :level, :enemybuffer, :space, :cannons
	attr_accessor :bullets, :delay
	def initialize(control)
		@points=0
		@bpoints=0
		@spare=0
		@font = Gosu::Font.new($window, "img/atari full.ttf", 18)
		@space = CP::Space.new #chipmunk space init
		@space.damping = 1.0 #chipmunk config
		@enemies=[]
		@ttile=Image.new("img/ttile.png", tileable: true )
		@ttile1=Image.new("img/ttile1.png", tileable: true)
		@cannons=[]
		for i in 0..2
			@cannons<<Cannon.new(i, self)
		end
		@buildings=[]
		@buildings<<Building.new(64,570, 1, false, self)
		@buildings<<Building.new(152,520, 2, false, self)
		@buildings<<Building.new(248,504, 3, true, self)
		@buildings<<Building.new(330,466, 4, true, self)
		@buildings<<Building.new(384,542, 5, false, self)
		@buildings<<Building.new(586,504, 6, true, self)
		@bullets=[]
		map="NNNNNNNNNNNNNNNNNN**NNNNNNNNNNNNNNNNNNN***
==+++++++++++++++=**==++++++++++++++++=***
##...............#####................####
##...............#####................####
##.............#######.............#######
###......#####.########......#####.#######
####....################....##############
####....################....##############
##########################################".split(/[\r\n]+/x)
		@map=[]
		loadmap(map)
		add_walls
		#@space.add_collision_func(:npc, :wall) {|p, w, a| stopmove(p,w, a)}
		@to_del=[]
		@level=0
		@i=0
		@enemybuffer=[]
		@delay=0
		@leveling=false
		@levelkill=0
		@levelfailed=false
		@explosions=[]
		@exp_img=Image.load_tiles("img/explosion.png",44,12)
		@en_img=[]
		for i in 1..3
			@en_img<<Image.new("img/en#{i}.png", retro: true)
		end
		spawn
		@control=Kcontrol.new(control,self)
		@lost=[]
		@space.add_collision_func(:bullet, :ship) {|b, s, a| hit(b,s, a)}
		@space.add_collision_func(:bullet, :ship2) {|b, s, a| hit2(b,s, a)}
		@space.add_collision_func(:b1, :bullet) {|b1, bul, a| bul_away(b1, bul, a)}
		@space.add_collision_func(:build, :ray) {|b, r, a| hit_build(b, r, a)}
		@space.add_collision_func(:cannon, :ray) {|c, r, a| hit_cannon(c, r, a)}
		@flash=nil
		@locked=false
	end
	
	def add_to_del(shape)
		@to_del<<shape
	end
	
	
	def finish_flash
		if @locked==true
			$window.game_over(@points, @level)
		else
			@flash=nil
		end
	end
		
	def spawn
		a=[1,2].sample
		b=Enemy.new(a, rand(5..5.0+(2*@level)), self, @en_img[a-1])
		b.dwarp
		@enemies<<b
		if @level==0
			for i in 0..8
				a=[1,2].sample
				@enemybuffer<<Enemy.new(a, rand(5..5.0+(2*@level)), self, @en_img[a-1])
			end
		else
			for i in 0..8
				a=rand(0..30)
				if a<5+@level
					aa=3
				else
					aa=[1,2].sample
				end
				@enemybuffer<<Enemy.new(aa, rand(5..5.0+(2*@level)), self, @en_img[aa-1])
			end
		end
	end
	
	def lvfail
		@levelfailed=true
	end
	
	def hit_build(b, r, a)
		if a.first_contact? and r.object.par.level==3
			if @cannons[2]==nil
				@lost<<b.object.type
				@to_del<<r
				@to_del<<b
				@explosions<<Explosion.new(b.object.x, b.object.y, @exp_img)
				@buildings.delete(b.object)
				r.object.par.del_ray
				@flash=Flash.new(200)
			end
		end
	end
	
	def hit_cannon(c, r, a)
		if a.first_contact? and r.object.par.level==3
				@to_del<<r
				@to_del<<c
				@explosions<<Explosion.new(c.object.x-30, c.object.y, @exp_img)
				@cannons.delete(c.object)
				r.object.par.del_ray
				@flash=Flash.new(200)
		end
	end
	
	def destroy_explosion(e)
		@explosions.delete(e)
	end
		
	def add_walls
		body1 = CP::Body.new(1.0, 1.0)
		body2 = CP::Body.new(1.0, 1.0)
		body3 = CP::Body.new(1.0, 1.0)
		@shape1 = CP::Shape::Segment.new(body1, CP::Vec2.new(-60.0, -60.0), CP::Vec2.new(-60.0, 660.0), 1)
		@shape1.collision_type = :b1
		@shape2 = CP::Shape::Segment.new(body2, CP::Vec2.new(-60.0, -60.0), CP::Vec2.new(860.0, -60.0), 1)
		@shape2.collision_type = :b1
		@shape3 = CP::Shape::Segment.new(body3, CP::Vec2.new(860.0, -60.0), CP::Vec2.new(860.0, 660.0), 1)
		@shape3.collision_type = :b1
		@space.add_shape(@shape1)
		@shape1.body.p = CP::Vec2.new(0.0, 0.0)
		@space.add_shape(@shape2)
		@shape2.body.p = CP::Vec2.new(0.0, 0.0)
		@space.add_shape(@shape3)
		@shape3.body.p = CP::Vec2.new(0.0, 0.0)
		@shape1.object="Col1"
		@shape2.object="Col2"
		@shape3.object="Col3"
	end
	
	def bul_away(b1,bul, a)
		if a.first_contact?
			@to_del<<bul
			@bullets.delete(bul.object)
		end
	end
		
	def hit(b, s, a)
		if a.first_contact?
			s.object.del_ray
			@levelkill+=1
			@to_del<<b
			@to_del<<s
			@explosions<<Explosion.new(s.object.x, s.object.y, @exp_img)
			@bullets.delete(b.object)
			@enemies.delete(s.object)
			@points+=100
			@bpoints+=100
			@bullets.delete(b.object) if b.object
			@enemies.delete(s.object) if s.object
		end
	end
	
	def hit2(b, s, a)
		if a.first_contact?
			@points+=1000+@enemies.size*100
			@bpoints+=1000+@enemies.size*100
			@enemies.each do |en|
				en.del_ray
				@levelkill+=1
				@to_del<<en.shape
				@explosions<<Explosion.new(en.x, en.y, @exp_img)
				@enemies.delete(en)
			end
			
			@to_del<<b
			@bullets.delete(b.object)
			@enemies.each do |en|
				en.del_ray if en!=nil
				@levelkill+=1 if en!=nil
				@to_del<<en.shape if en!=nil
				@explosions<<Explosion.new(en.x, en.y, @exp_img) if en!=nil
				@enemies.delete(en) if en!=nil
			end
			@bullets.delete(b.object) if b.object
			@flash=Flash.new(200)
		end
	end
	
	def add_shape(shape)
		@space.add_shape(shape)
	end
			
	def add_enemy
		@enemies<<Enemy.new([1,2].sample, 5, self)
	end
	
	def delete_enemy(enemy)
		enemy.del_ray
		@enemies.delete(enemy)
	end
	
	def loadmap(map)
		for i in 0..map.size-1
			for k in 0..map[i].size-1
				@map<<Tile.new(k*16, 456+(i*16), map[i][k]) if map[i][k]!="N"
			end
		end
	end
	
	def update
		@delay-=1 if @delay>0
		@i+=1
		if @locked==false
			if @i.modulo(165)==0
				if @enemybuffer.first!=nil
					@enemybuffer.first.dwarp 
					@enemies<<@enemybuffer.first
					@enemybuffer.delete(@enemybuffer.first)
				end
			end
			if @enemies.size==0 and @enemybuffer.size==0
				@delay=300 if @leveling==false
				@leveling=true if @leveling==false
				if @delay==150 and @leveling==true
					@level+=1
					$window.beep.play
					@points+=@buildings.size*500+@level*500
					@bpoints+=@buildings.size*500+@level*500
					@levelfailed=false
					@levelkill=0
					if @bpoints>=10000
						@spare+=1
						@bpoints-=10000
					end
					if @spare>0
						c=0
						b=[[64,570,false],[152,520,false],[248,504,true],[330,466,true],[384,542,false],[586,504,true]]
						if @cannons[2]==nil
							@cannons[2]=Cannon.new(2, self)
							c+=1
						end
						
						if @lost.size>0
							a=@lost.sample
							@buildings<<Building.new(b[a-1][0],b[a-1][1],a, b[a-1][2], self)
							@lost.delete a
							c+=1
						end
						@spare-=1 if c>0
					end
					
							
				end
				if @delay==0 and @leveling==true
					spawn
					@leveling=false
					@i=0
				end				
			end
		end
		SUBSTEPS.times do
			@enemies.each do |enemy|
				if enemy!=nil
					enemy.update
				else
					puts @enemies.inspect
				end
			end
			@map.each do |tile|
				tile.update
			end
			@buildings.each do |b|
				b.update
			end
			@bullets.each do |bul|
				bul.update
			end
			if @bpoints>=10000
				@spare+=1
				@bpoints-=10000
			end
			@explosions.each do |e|
				e.update
			end
			@flash.update if @flash!=nil
			@space.step(1.0/60.0)
		end
		@to_del.each do |shape|
			@to_del.delete(shape)
			@space.remove_shape(shape)
		end
		if @buildings.size==0 and @cannons[2]==nil
			if @locked==false
				@flash=Flash.new(50000)
				@locked=true
			end
		end
		
	end
	
	def draw
		@map.each do |tile|
			tile.draw
		end
		@enemies.each do |enemy|
			enemy.draw
		end
		draw_quad(656,0,GRAY, 800,0,GRAY, 656,600,GRAY, 800,600,GRAY, 4)
		@cannons.each do |can|
			can.draw
		end
		@buildings.each do |b|
			b.draw
		end
		@bullets.each do |bul|
			bul.draw
		end
		@explosions.each do |e|
			e.draw
		end
		@font.draw("#{@points}", 660, 10, 5, 1.0, 1.0, 0xffffffff)
		@font.draw("I"*@spare, 660, 30, 5, 1.0, 1.0, 0xffffffff)
		@font.draw("Level #{@level}", 660, 50, 5, 1.0, 1.0, 0xffffffff)
		@flash.draw if @flash!=nil
	end
	
	def sdata
		puts @enemies.size
		puts @bullets.size
		puts @enemybuffer.size
		
	end
	
	def button_down(id)
		if id==KbEscape
			#puts @level
			#puts @enemies.size
			#puts @enemybuffer.size
			#puts
			#@space.active_shapes.each do |shape|
			#	puts shape.object
			#end
			#puts
			#@enemies.each do |en|
			#	puts en.inspect
			#end
			$window.close 
		else
			if @locked==false
				@control.button_down(id)
			else
				$window.game_over(@points, @level)
			end
		end
		
	end
	
end

	

class Tile
	def initialize(x,y,type)
		@x=x
		@y=y
		@type=type
		@z=3
		load(@type)
		@i=0
	end
	
	def load(type)
		if type!="N"
			case type
				when "+"
				@imgs=[Image.new("img/ttile.png", tileable: true),Image.new("img/ttile2.png", tileable: true)]
				@img=@imgs[0]
				@z=0
				when "="
				@img=Image.new("img/ttile1.png", tileable: true)
				@z=3
				when "#"
				@img=Image.new("img/gtile.png", tileable: true)
				@z=3
				when "."
				@img=Image.new("img/wtile.png", tileable: true)
				@z=1
				when "*"
				@img=Image.new("img/ttile3.png", tileable: true)
				@z=3
			end
		end
	end
	
	def update
		if @type=="+"
			@i+=1
			if @i==12
				if @img==@imgs[0]
					@img=@imgs[1]
					@i=0
				end
			else
				if @i==24
					if @img==@imgs[1]
						@img=@imgs[0]
						@i=0
					end
					
				end
				
			end
		end
	end
	
	def draw
		@img.draw(@x,@y,@z)
	end
end

class Explosion
	def initialize(x,y, img)
		@x=x
		@y=y
		@img=img
		@i=0
		@k=0
		$window.explode.play
	end
	
	def update
		@i+=1
		@k+=1 if @i.modulo(30)==0 and @k<4
		if @i>120
			$window.state.destroy_explosion(self)
		end
	end
	
	def draw
		@img[@k].draw(@x,@y,3)
	end
end

class Flash
	def initialize(time)
		@i=0
		@ison=true
		@color=GRAY
		@time=time
	end
	
	def update
		@i+=1
		if @i.modulo(10)==0
			if @ison==true
				@ison=false
			else
				@ison=true
			end
		end
		if @i==@time
			$window.state.finish_flash
		end
	end
	
	def draw
		$window.draw_quad(0,0,@color, 656,0,@color, 0,485,@color, 656,485,@color, 2) if @ison==true
	end
end

