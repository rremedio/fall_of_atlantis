class Kcontrol
	def initialize(type, manager)
		@type=type
		@manager=manager
	end
	
	def button_down(id)
		if @manager.bullets.size<3
			if @type==0
				if id==KbA or id==KbS or id==KbD
					if button_down?(KbLeft)
						if @manager.delay==0
							@manager.bullets<<Bullet.new(32.0, 464.0, 7.5, -4.5)
							@manager.delay=10
						end
						
					else
						if button_down?(KbRight)
							if @manager.delay==0
								@manager.bullets<<Bullet.new(624.0, 442.0, -7.5, -4.5)
								@manager.delay=10
							end
						else
							if @manager.delay==0 and @manager.cannons[2]!=nil
								@manager.bullets<<Bullet.new(300.0, 440.0, 0, -8)
								@manager.delay=10
							end
						end
					end			
				end
			else			
				if id==KbA
					if @manager.delay==0
						@manager.bullets<<Bullet.new(32.0, 464.0, 7.5, -4.5)
						@manager.delay=10
					end
				end		
				if id==KbD
					if @manager.delay==0
						@manager.bullets<<Bullet.new(624.0, 442.0, -7.5, -4.5)
						@manager.delay=10
					end
				end
				if id==KbS
					if @manager.delay==0 and @manager.cannons[2]!=nil
						@manager.bullets<<Bullet.new(300.0, 440.0, 0, -8)
						@manager.delay=10
					end
				end
			
			end
		end
	end
end

class Cannon
	attr_reader :x, :y
	def initialize(type, manager)
		@type=type
		case @type
			when 0
			@img=Image.new("img/sidecannon.png")
			@pan=0
			@x=16
			@y=474
			@ang=1
			when 1
			@img=Image.new("img/sidecannon.png")
			@pan=16
			@x=624
			@y=448
			@ang=-1
			when 2
			@img=Image.new("img/maincannon.png")
			@pan=0
			@x=304
			@y=448
			@ang=1
			body = CP::Body.new(0.1, 0.1)
			shape_array = [CP::Vec2.new(10, 0), CP::Vec2.new(10, 16), CP::Vec2.new(24, 16), CP::Vec2.new(24, 0)]
			@shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
			@shape.body.p = CP::Vec2.new(@x, @y)
			@shape.collision_type = :cannon
			@shape.object=self
			manager.add_shape(@shape)
		end
	end
	
	def update
		
	end
	
	def draw
		@img.draw_rot(@x+@pan, @y, 3, 0, center_x = 0.5, center_y = 0.5, scale_x = @ang, scale_y = 1, color = 0xff_ffffff, mode = :default)
	end
	
end

class Building
	attr_reader :type, :x, :y
	def initialize(x,y,type, animated, manager)
		@x=x
		@y=y
		@type=type
		@animated=animated
		@img=[]
		if @animated==false
			@img<<Image.new("img/b#{type}.png")
		else
			@img<<Image.new("img/b#{type}a.png")
			@img<<Image.new("img/b#{type}b.png")
		end
		@i=0
		@k=0
		body = CP::Body.new(0.1, 0.1)
		pts=[[64.0,14.0],[64.0,16.0],[26.0,16.0],[26.0,16.0],[64.0,16.0],[26.0,16.0]][type-1]
		shape_array = [CP::Vec2.new(10, 0), CP::Vec2.new(10, pts[1]), CP::Vec2.new(pts[0]-10, pts[1]), CP::Vec2.new(pts[0]-10, 0)]
		@shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
		@shape.body.p = CP::Vec2.new(@x, @y)
		@shape.collision_type = :build
		@shape.object=self
		manager.add_shape(@shape)
	end
	
	def update
		if @animated==true
			if @i==10
				if @k==0
					@k=1
					@i=0
				else
					@k=0
					@i=0
				end
			end
			@i+=1
		end
	end
	
	def draw
		@img[@k].draw(@x,@y,3)
	end
end

class Bullet
	def initialize(x,y,dx,dy)
		@x=x
		@y=y
		@dx=dx
		@dy=dy
		@img=Image.new("img/bullet.png")
		body = CP::Body.new(0.1, 0.1)
		@shape = CP::Shape::Circle.new(body, 6/2, CP::Vec2.new(0.0, 0.0))
		@shape.collision_type = :bullet
		@shape.body.p = CP::Vec2.new(@x, @y)
		@shape.object=self
		$window.state.add_shape(@shape)
		$window.shot.play
	end
	
	def update
		@x+=@dx/SUBSTEPS
		@y+=@dy/SUBSTEPS
		@shape.body.p = CP::Vec2.new(@x, @y)
	end
	
	def draw
		@img.draw(@x, @y, 3)
	end
end