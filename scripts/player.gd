extends CharacterBody2D

var target_velocity:Vector2
var max_speed:float = 400
var accel:float = 4
var decel:float = 8
var reverse = 6

@export_enum("basic", "linear", "curve", "asteroid") var movement_type = "basic"
@export var move_curve:Curve

@onready var active_weapon = $weapon

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		active_weapon._fire()
	
func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		target_velocity.x = max_speed
	if Input.is_action_pressed("move_left"):
		target_velocity.x = -max_speed
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		target_velocity.x = 0
	
	#target_velocity = target_velocity.rotated(rotation)
	
### instant move
	if movement_type == "basic":
		velocity = target_velocity

### accel/decel style movement
	if movement_type == "linear":
		var tsign = sign(target_velocity.x)
		var vsign = sign(velocity.x)
		# move in direction of motion
		if tsign == vsign:
			velocity.x += target_velocity.x * accel * delta
		### change direction of motion
		elif tsign != vsign and target_velocity.x != 0:
			velocity.x += target_velocity.x * reverse * delta
		### come to a stop
		else:
			### linear change
			var change = -sign(velocity.x) * max_speed * decel * delta
			if abs(change) >= abs(velocity.x):
				velocity.x = 0
			else:		
				velocity.x += change
	
	### accel/decel style movement
	if movement_type == "curve":
		var tsign = sign(target_velocity.x)
		var vsign = sign(velocity.x)
		# move in direction of motion
		if tsign == vsign:
			velocity.x += target_velocity.x * accel * move_curve.sample(abs(velocity.x)/max_speed) * delta
		### change direction of motion
		elif tsign != vsign and target_velocity.x != 0:
			velocity.x += target_velocity.x * reverse * move_curve.sample(abs(velocity.x)/max_speed) * delta
		### come to a stop
		else:
			### linear change
			var change = -sign(velocity.x) * max_speed * move_curve.sample(abs(velocity.x)/max_speed) * delta	
			if abs(change) >= abs(velocity.x):
				velocity.x = 0
			else:		
				velocity.x += change
	
	#look_at(get_global_mouse_position())
		
	
	###clamp the velocity so we don't exceed the max speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	#skew = deg_to_rad( 10 * velocity.x / max_speed )
	### at the end of the day, we always move
	move_and_slide()
	#move_and_collide(velocity * delta)
	
