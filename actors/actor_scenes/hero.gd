extends CharacterBody2D


#@onready var animation_tree: AnimationTree = %AnimationTree
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
#func update_animation_parameters():
	## actions: "move_left", "move_right", "jump", "actions"
	## conditions: "idle", "is_attacking", "is_jumping", "is_landing", "is_running"
	## all animations in the animation tree: "idle", "run", "jump", "landing", "attack1", "attack2"
	#
	## example path value: "parameters/conditions/idle"
	#if velocity.x == 0 && velocity.y == 0:
		#animation_tree["parameters/conditions/idle"] = true
		#animation_tree["parameters/conditions/is_attacking"] = false
		#animation_tree["parameters/conditions/is_jumping"] = false
		#animation_tree["parameters/conditions/is_landing"] = false
		#animation_tree["parameters/conditions/is_running"] = false
#
#
#
#func _ready():
	#animation_tree.active = true
	#
	#
#func _physics_process(delta: float) -> void:
	#
	#update_animation_parameters()
	#
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	
	
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var attack_timer: Timer = $AttackTimer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking = false
var current_attack = 0 # Tracks the current attack combo (0 = no attack, 1 = attack1, 2 = attack2)

func update_animation_parameters():
	# Character is idle or running
	if velocity.x == 0 and is_on_floor() and !is_attacking:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_running"] = false
		animation_tree["parameters/conditions/is_jumping"] = false
		animation_tree["parameters/conditions/is_landing"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
	
	if abs(velocity.x) > 0 and is_on_floor() and !is_attacking:
		animation_tree["parameters/conditions/is_running"] = true
	else:
		animation_tree["parameters/conditions/is_running"] = false
	
	# Jumping and landing logic
	if velocity.y < 0 and not is_on_floor():
		animation_tree["parameters/conditions/is_jumping"] = true
		animation_tree["parameters/conditions/is_landing"] = false
	else:
		animation_tree["parameters/conditions/is_jumping"] = false
	
	if velocity.y > 0 and not is_on_floor():
		animation_tree["parameters/conditions/is_landing"] = true
	else:
		animation_tree["parameters/conditions/is_landing"] = false

	# Handle attack animations
	if is_attacking:
		if current_attack == 1:
			animation_tree["parameters/conditions/is_attacking"] = true
			animation_tree["parameters/actions/attack1"] = true
		elif current_attack == 2:
			animation_tree["parameters/conditions/is_attacking"] = true
			animation_tree["parameters/actions/attack2"] = true
	else:
		animation_tree["parameters/conditions/is_attacking"] = false
		animation_tree["parameters/actions/attack1"] = false
		animation_tree["parameters/actions/attack2"] = false

func _ready():
	animation_tree.active = true
	attack_timer.timeout.connect(_on_attack_timeout) # Connect timer signal to a timeout handler
	
func _physics_process(delta: float) -> void:
	update_animation_parameters()

	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle attack input and combo
	if Input.is_action_just_pressed("attack"):
		# If already attacking and within combo window, play the second attack
		if is_attacking and attack_timer.is_stopped():
			current_attack = 2
			attack_timer.start(0.5) # Extend timer for next combo if needed
		else:
			# First attack
			is_attacking = true
			current_attack = 1
			attack_timer.start(0.5) # Start combo timer for chaining to attack2

	# Move character
	move_and_slide()

# Handle attack combo timeout
func _on_attack_timeout():
	is_attacking = false
	current_attack = 0 # Reset combo after timeout
