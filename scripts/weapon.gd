extends Node2D

@export var bullet:PackedScene
@onready var sfx = $AudioStreamPlayer2D

func _ready():
	if bullet == null:
		push_error("no bullet scene set on " + str(self.name))

func _fire():
	spawn_bullet(Vector2.UP)
	sfx.play()

func spawn_bullet(dir):
	var b = bullet.instantiate()
	get_tree().root.add_child(b)
	b.global_position = global_position
	b.set_direction(dir)
