class Enemy
	attr_reader :i, :shape, :x, :level, :speed, :y
	def initialize(type, speed, manager, img)
		@type=type
		@img=img
		@ang=[1,-1].sample
		case @ang
			when 1
			@x=-400
			@pad=0
			when -1
			@x=1200
			@pad=30
		end
		case @type
			when 1
			body = CP::Body.new(0.1, 0.1)
			shape_array = [CP::Vec2.new(-30.0, -8.0), CP::Vec2.new(-30.0, 8.0), CP::Vec2.new(30.0, 8.0), CP::Vec2.new(30.0, -8.0)]
			@shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
			@shape.collision_type = :ship
			@speed=speed
			when 2
			body = CP::Body.new(0.1, 0.1)
			shape_array = [CP::Vec2.new(-30.0, -7.0), CP::Vec2.new(-30.0, 7.0), CP::Vec2.new(30.0, 7.0), CP::Vec2.new(30.0, -7.0)]
			@shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
			@shape.collision_type = :ship
			@speed=speed
			when 3
			body = CP::Body.new(0.1, 0.1)
			shape_array = [CP::Vec2.new(-18.0, -7.0), CP::Vec2.new(-18.0, 7.0), CP::Vec2.new(18.0, 7.0), CP::Vec2.new(18.0, -7.0)]
			@shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
			@shape.collision_type = :ship2
			@speed=speed+4
		end
		@y=50.0
		@shape.body.p = CP::Vec2.new(@x, @y)
		@shape.object=self
		manager.add_shape(@shape)
		@level=0
		@i=0
		@ray=Ray.new(@x, self, manager)
	end
	
	def del_ray
		$window.state.add_to_del(@ray.shape) if @ray!=nil
		@ray=nil
	end
	
	def dwarp
		@x=-61 if @x==-400
		@x=673+16 if @x==1200
	end

	def warp
		if @ang==1
			@x=-61
		else
			@x=673+16
		end
		
		if @level==3
			$window.state.lvfail
			$window.state.delete_enemy(self)
		end
		
		if @level<3
			@level+=1
			@y=50+(100*@level)
		end
		@i=0
	end
	
	def tes
		@ang*@speed/SUBSTEPS
	end
		
	def update
		@x+=@ang*@speed/SUBSTEPS
		if @ang==1
			warp if @x>=673+16
		else
			warp if @x<=-61
		end
		@shape.body.p = CP::Vec2.new(@x, @y)
		@ray.update(@x+(-1*@ang*12)) if @level==3 and @ray!=nil
		@i+=1
	end
	
	def draw
		@ray.draw if @level==3 and @ray!=nil
		@img.draw_rot(@x, @y, 3, 0, center_x = 0.5, center_y = 0.5, scale_x = @ang, scale_y = 1, color = 0xff_ffffff, mode = :default)
	end
end

class Ray
	attr_reader :par, :shape
	def initialize(x,par, manager)
		@x=x
		@y=356
		@par=par
		@img=Image.new("img/ray.png")
		body = CP::Body.new(0.1, 0.1)
		shape_array = [CP::Vec2.new(0.0, 0.0), CP::Vec2.new(0.0, 244.0), CP::Vec2.new(6.0, 244.0), CP::Vec2.new(6.0, 0.0)]
		@shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
		@shape.body.p = CP::Vec2.new(@x, @y)
		@shape.collision_type = :ray
		@shape.object=self
		manager.add_shape(@shape)
	end
	
	def update(x)
		@x=x
		@shape.body.p.x=@x
	end
	
	def draw
		@img.draw(@x, @y, 2)
	end
end
