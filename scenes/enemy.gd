extends CharacterBody2D
enum MetaState {AGGRESIVE, PASSIVE}
enum States {MOVE_LEFT, MOVE_RIGHT, STOP}
var state:States = States.MOVE_LEFT
var meta_state = MetaState.PASSIVE
var player
var max_speed = 200
var buffer_zone = 50

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	$Timer.connect("timeout", get_aggresive)

func _physics_process(delta):
	match(meta_state):
		MetaState.AGGRESIVE:
			match(state):
				States.MOVE_LEFT:
					velocity.x = -max_speed
					if player.global_position.x > global_position.x + buffer_zone:
						state = States.MOVE_RIGHT
					elif abs(player.global_position.x - global_position.x) < buffer_zone:
						state = States.STOP
					
				States.MOVE_RIGHT:
					velocity.x = max_speed
					if player.global_position.x < global_position.x - buffer_zone:
						state = States.MOVE_LEFT
					elif abs(player.global_position.x - global_position.x) < buffer_zone:
						state = States.STOP

				States.STOP:
					velocity.x = 0
					if player.global_position.x < global_position.x - buffer_zone:
						state = States.MOVE_LEFT
					if player.global_position.x > global_position.x + buffer_zone:
						state = States.MOVE_RIGHT
		MetaState.PASSIVE:
			velocity.x = 0
	
	move_and_slide()

func get_aggresive():
	meta_state = MetaState.AGGRESIVE
	
func calm_down():
	meta_state = MetaState.PASSIVE
	
