shader_type canvas_item;

uniform vec4 u_old_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 u_new_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec2 u_center = vec2(0.5, 0.5);
uniform float u_radius = 0.0;
uniform float u_aspect = 1.77;

uniform sampler2D noise_texture : repeat_enable;
uniform float speed = 0.05;

void fragment() {
	// 1. Calculate Mask
	vec2 uv = UV;
	vec2 center = u_center;
	
	// Correct for aspect ratio so the circle is actually a circle, not an oval
	uv.x *= u_aspect;
	center.x *= u_aspect;
	
	float dist = distance(uv, center);
	// Smoothstep for a slightly soft edge
	// Inside radius = 0 (New Color), Outside radius = 1 (Old Color)
	// We want new color INSIDE the circle.
	float mask = smoothstep(u_radius, u_radius + 0.05, dist);
	
	// 2. Mix Colors (Inside circle = New, Outside = Old)
	vec3 base_color = mix(u_new_color.rgb, u_old_color.rgb, mask);

	// 3. Apply Noise (Existing logic)
	vec2 noise_uv = UV + vec2(TIME * speed, TIME * speed * 0.5);
	float noise = texture(noise_texture, noise_uv).r;
	
	vec3 final_color = mix(base_color, base_color * 0.8, noise);
	
	COLOR = vec4(final_color, 1.0);
}