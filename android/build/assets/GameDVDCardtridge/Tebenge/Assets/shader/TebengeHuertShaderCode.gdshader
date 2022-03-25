// Huert Shader Code. BitBirdy Hurt Invincible tutorial
// https://www.youtube.com/watch?v=tHEr7x5Un9c
// https://github.com/robyn3choi/godot-tutorial_hurtbox/blob/main/whiten.shader

shader_type canvas_item;

uniform bool redden = false;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (redden) {
		vec3 white = vec3(1,1,1);
		vec3 red = vec3(1,0,0);
		vec3 whitened_texture_rgb = mix(texture_color.rgb, red, 0.6);
		COLOR = vec4(whitened_texture_rgb, texture_color.a);
	} else {
		COLOR = texture_color
	}
}