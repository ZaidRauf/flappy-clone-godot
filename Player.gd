extends CharacterBody2D

var character_velocity = Vector2.ZERO
var is_alive = true
var is_active = false
const max_rotation = 30

func _ready():
	character_velocity = Vector2.ZERO
	is_alive = true

func _process(delta):
	if !is_alive:
		self.rotate(2 * delta)
	
	if is_active:
		character_velocity += Vector2.DOWN * 1000 * delta

		if is_alive and Input.is_action_just_pressed("game_jump"):
			character_velocity = Vector2.UP * 500
			$JumpSound.play()
		else:
			var normalized_velocity = character_velocity.normalized()
			var velocity_magnitude = character_velocity.length()
			
			if(velocity_magnitude > 650):
				character_velocity = normalized_velocity * 650
		
		var normalized_velocity = character_velocity.normalized()
		
		if(normalized_velocity == Vector2.UP) and self.rotation_degrees > -35:
			self.rotation_degrees -= 150 * delta

		if(normalized_velocity == Vector2.DOWN) and (self.rotation_degrees) < 35:
			self.rotation_degrees += 100 * delta

		self.velocity = character_velocity
		self.move_and_slide()
