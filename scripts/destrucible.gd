class_name Destructible
extends CharacterBody2D

@export var health:int = 10

func _damage(d):
	health -= d
	if health <= 0:
		_destroy()

func _destroy():
	queue_free()
