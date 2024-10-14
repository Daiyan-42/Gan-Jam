extends CharacterBody2D


@export var SPEED : float = 50
var damage : int = 10 #for now
var direction : int = 0
var player_nearby : bool = false
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Sprite flipping
	
	if direction == 1:
		sprite.flip_h = false
	elif direction == -1:
		sprite.flip_h = true

	# Motion
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		if self.position.x > body.position.x:
			direction = -1
		elif self.position.x < body.position.x:
			direction = 1
			
	pass # Replace with function body.


func _on_detection_zone_body_exited(body):
	if body.name == "Player":
		player_nearby = false
		direction = 0
	pass # Replace with function body.
