extends RigidBody2D


export var min_speed = 150  # Minimum speed range.
export var max_speed = 500  # Maximum speed range.


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier_screen_exited():
	queue_free()
