extends Area2D
signal hit
@export var speed = 400 # pixel/second
@export var ammo_scene: PackedScene
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	if Input.is_action_just_pressed("shoot"):
		
		var ammo = ammo_scene.instantiate()
		
		var ammo_velocity = ( 
			velocity.normalized() if absf(velocity.x) > 0 and absf(velocity.y) > 0
			else Vector2.RIGHT if $AnimatedSprite2D.animation == "walk" and not $AnimatedSprite2D.flip_h 
			else Vector2.LEFT if $AnimatedSprite2D.animation == "walk" and $AnimatedSprite2D.flip_h
			else Vector2.UP if $AnimatedSprite2D.animation == "up" and not $AnimatedSprite2D.flip_v
			else Vector2.DOWN
			)
		#ammo.position = position
		#ammo.linear_velocity = Vector2(0.0, 800.0) if velocity.length() == 0.0 else velocity * 2
		ammo.shoot(position, ammo_velocity * 1600.0, ammo_velocity.angle())
			
		add_sibling(ammo)
	
func _on_body_entered(body):
	hit.emit()
	disable_collision(3)
	player_blinking(3)

	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
func player_blinking(second):
	for i in int(second / 0.25):
		await  get_tree().create_timer(0.25).timeout
		$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible

func disable_collision(second):
	$CollisionShape2D.set_deferred("disabled", true)
	await  get_tree().create_timer(second).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	
	
	
