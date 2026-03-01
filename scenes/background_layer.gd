extends CanvasLayer
@onready var color_rect = $ColorRect
func _ready() -> void:
	# Create a noise texture programmatically so you don't need extra files
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.02
	
	var noise_tex = NoiseTexture2D.new()
	noise_tex.noise = noise
	noise_tex.seamless = true
	# Wait for the noise to generate
	await noise_tex.changed 
	
	# Assign noise to shader
	var material = color_rect.material as ShaderMaterial
	material.set_shader_parameter("noise_texture", noise_tex)
	
	# Connect to global signal
	GlobalVar.world_color_changed.connect(_on_world_color_changed)

var current_color: Color = Color(0.5, 0.5, 0.5, 1.0) # Start with gray or your default color

func _on_world_color_changed(new_color: Color, player_screen_pos: Vector2) -> void:
	var material = color_rect.material as ShaderMaterial
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Update colors
	material.set_shader_parameter("u_old_color", current_color)
	material.set_shader_parameter("u_new_color", new_color)
	
	# Calculate center UV
	var center_uv = player_screen_pos / viewport_size
	# In Godot shaders, UV (0,0) is top-left, which matches screen coords usually.
	material.set_shader_parameter("u_center", center_uv)
	
	# Update Aspect Ratio
	var aspect = viewport_size.x / viewport_size.y
	material.set_shader_parameter("u_aspect", aspect)
	
	# Animate Radius
	var tween = create_tween()
	tween.tween_method(
		func(r): material.set_shader_parameter("u_radius", r),
		0.0,
		1.5, # Go larger than 1.0 to ensure corners are covered
		0.8  # Duration increased slightly for better feel
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# Store for next time
	current_color = new_color
