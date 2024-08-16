class_name Bullet
extends Sprite2D

@export_enum("raycast", "area") var detection_type = "raycast"
@export var speed:float = 600
@export var damage:int = 1
@onready var raycast = $RayCast2D
var direction:Vector2 = Vector2.UP

func set_direction(d):
	direction = d

func set_speed(s):
	speed = s

func _physics_process(delta):
	var distance = direction * speed * delta
	if detection_type == "raycast":
		raycast.target_position = distance - Vector2(0, texture.get_size().y/2)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var hit = raycast.get_collider()
			if hit is Destructible:
				hit._damage(damage)
			queue_free()
	position += distance
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_body_entered(body):
	if detection_type == "area":
		if body is Destructible:
			body._damage(damage)
			queue_free()
	pass # Replace with function body.
