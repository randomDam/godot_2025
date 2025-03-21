shader_type canvas_item;

uniform bool dithering = true;
uniform int dithering_size = 10;
uniform int resolution_scale = 2;
uniform float threshold = 60.0;
uniform vec4 white: source_color = vec4(1,1,1,1);
uniform vec4 black: source_color = vec4(0,0,0,1);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

int dithering_pattern(ivec2 fragcoord) {
	const int pattern[] = {
		-4, +0, -3, +1,
		+2, -2, +3, -1,
		-3, +1, -4, +0,
		+3, -1, +2, -2
	};
	int x = fragcoord.x % 4;
	int y = fragcoord.y % 4;

	return pattern[y * 4 + x]*dithering_size;
}

void fragment() {
	ivec2 uv = ivec2(FRAGCOORD.xy / float(resolution_scale));
	vec3 color = texelFetch(screen_texture, uv * resolution_scale, 0).rgb;
	
	vec4 dither = vec4(1.0);
	
	// Convert from [0.0, 1.0] range to [0, 255] range
	ivec3 c = ivec3(round(color * 255.0));

	// Apply the dithering pattern
	if (dithering) {
		c += ivec3(dithering_pattern(uv));
	}

	// Convert back to [0.0, 1.0] range
	float avg = float(c.x+c.y+c.z)/3.0;
	if (avg < threshold){
		dither = black;
	}else{
		dither = white;
	}
	COLOR = vec4(color,1.0);
	COLOR *= dither;
}