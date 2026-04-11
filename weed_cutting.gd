extends CharacterBody2D
const GRAVITY = 980
var random_vector = Vector2.ZERO
var rotation_speed = 0
func init(sprite: Sprite2D, bottom: float, top: float) -> void:
	var weed_mask: Sprite2D = $WeedMask
	var kill_timer: Timer = $KillTimer
	kill_timer.timeout.connect(_on_timeout)
	kill_timer.call_deferred("start")
	var weed_sprite: Sprite2D = $WeedMask/WeedSprite
	weed_sprite.texture = sprite.texture
	var pixel_range = top - bottom
	if(pixel_range < 0):
		pixel_range = 0.1
	weed_mask.scale.y = pixel_range/240
	weed_sprite.scale.y = 1/weed_mask.scale.y
	
	position.y = -(top + bottom) / 2
	
	var random_angle = randf_range(0, PI)
	random_vector = Vector2(cos(random_angle), -sin(random_angle))
	var speed = randf_range(0, 250)
	velocity += random_vector * speed
	rotation_speed = randf_range(-50, 50)
	
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	rotation += rotation_speed * delta
	velocity.y += GRAVITY * delta
	move_and_slide()
	
func _on_timeout():
	queue_free()
