
class_name Weed extends CharacterBody2D

@onready var kill_timer: Timer = $KillTimer

@export var base_score: float
var spawn_pos: Vector2
var width: int
var manager: WeedManager
const GRAVITY = 980
var random_vector
var random_offset
var rotation_speed
var is_dead: bool = false
@export var flower_texture: Texture
@export var sprite_array: Array[Texture]
const INITIAL_OFFSET: Vector2 = Vector2(0, 235)

signal stretched(weed: Weed)

@export var grow_rate: float = 50.0
var base_length = 240
var grow_rate_additive: float = 0.0
var growth: float = 0
var is_growing: bool = true
var is_grabbing: bool
var grab_point: Vector2
var initial_position: Vector2
var rotation_time: float = 0.5
var scale_time = 0.3
var stretch_threshold: float = 100

@onready var weed_mask: Sprite2D = $WeedMask
@onready var weed_sprite: Sprite2D = $WeedMask/WeedSprite
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var flower: Sprite2D = $Flower


@export var cutting: PackedScene

func _ready() -> void:
	initial_position = position
	collision_shape.shape = collision_shape.shape.duplicate()
	weed_sprite.texture = sprite_array.pick_random()
	weed_mask.offset = INITIAL_OFFSET
	flower.texture = flower_texture
	collision_shape.position = INITIAL_OFFSET
	kill_timer.timeout.connect(remove_from_scene)
	set_kill_velocity()
	random_offset = randf()

func _physics_process(delta: float) -> void:
	if(weed_mask.offset.y > 0 and is_growing and !is_dead):
		growth += delta * grow_rate
		flower.position.y = -growth -3
		flower.rotation = sin((growth + random_offset) / 10) / 2
		var offset = Vector2(0, INITIAL_OFFSET.y - growth)
		weed_mask.offset = offset
		collision_shape.position = offset
	elif(is_grabbing):
		var mouse_pos = get_global_mouse_position()
		var to_mouse = mouse_pos - position
		var distance_from_grab = (mouse_pos - grab_point).length()
		grow_rate_additive += (delta * grow_rate * 0.2)
		look_at(get_global_mouse_position())
		rotation += PI/2
		scale.y = to_mouse.length() / (base_length - weed_mask.offset.y)
		if(distance_from_grab > stretch_threshold):
			fully_stretched()
	if(is_dead):
		rotation += rotation_speed * delta
		velocity.y += GRAVITY * delta
		move_and_slide()
	if(weed_mask.offset.y <= 0):
		manager.game_over()
		
func return_to_normal():
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), scale_time)
	tween.tween_property(self, "rotation", 0, rotation_time)
	
func grab(grabbing: bool):
	is_grabbing = grabbing
	if(is_grabbing):
		is_growing = false
		grab_point = get_global_mouse_position()
	else:
		is_growing = true
		grow_rate += grow_rate_additive
		grow_rate_additive = 0
		return_to_normal()

func fully_stretched():
	grab(false)
	stretched.emit(self)

func cut():
	var cutting_instance = cutting.instantiate()
	call_deferred("add_child", cutting_instance)
	var mouse_pos = get_global_mouse_position()
	var offset = Vector2(0, INITIAL_OFFSET.y - growth)
	cutting_instance.init(weed_sprite, -mouse_pos.y, growth)
	
	growth = -mouse_pos.y
	
	weed_mask.offset = offset
	
func weedkiller():
	print("weed killering")

func init(manager_ref: WeedManager, difficulty: float, spawn_position: Vector2, width_value: int):
	manager = manager_ref
	grow_rate *= difficulty
	spawn_pos = spawn_position
	width = width_value

func check_kill(is_met: bool):
	if(is_met):
		kill()
	else:
		punishment(10)

func kill():
	set_kill_velocity()
	is_dead = true
	is_growing = false
	manager.update_score(base_score)
	kill_timer.start()
	
func remove_from_scene():
	manager.remove_weed(self)

func punishment(grow_rate_add: float):
	grow_rate += grow_rate_add

func set_kill_velocity():
	var random_angle = randf_range(0, PI)
	random_vector = Vector2(cos(random_angle), -sin(random_angle))
	var speed = randf_range(0, 250)
	velocity += random_vector * speed
	rotation_speed = randf_range(-10, 10)
