extends Area2D

signal hit

# Declare member variables here. Examples:
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

var target = Vector2() # where the player is currently touching

# Called when the node enters the scene tree for the first time.
func _ready():

	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10 \
		and target.y != 0 \
		and target.x != 0:
		velocity = target - position

	if(Input.is_action_pressed("ui_up")            \
			or Input.is_action_pressed("ui_down")  \
			or Input.is_action_pressed("ui_down")  \
			or Input.is_action_pressed("ui_right") \
			or Input.is_action_pressed("ui_left")):
		velocity.y = 0
		velocity.x = 0
		target.y = 0
		target.x = 0

	if(Input.is_action_pressed("ui_up")):
		velocity.y -= 1
	if(Input.is_action_pressed("ui_down")):
		velocity.y += 1
	if(Input.is_action_pressed("ui_right")):
		velocity.x += 1
	if(Input.is_action_pressed("ui_left")):
		velocity.x -= 1

	if(velocity.length() > 0):
		velocity = velocity.normalized() * speed
		get_node("AnimatedSprite").play()
	else:
		#$ is shorthand for get_node()
		$AnimatedSprite.stop()
	
	# We still need to clamp the player's position here because on devices that don't
	# match your game's aspect ratio, Godot will try to maintain it as much as possible
	# by creating black borders, if necessary.
	# Without clamp(), the player would be able to move under those borders.
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		#$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(_body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	target = pos # initial target is start position
	show()
	$CollisionShape2D.disabled = false

# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
