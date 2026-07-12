shader_type spatial;
render_mode unshaded;

uniform vec3 sensor_positions[54];
uniform float sensor_intensities[54];
uniform int sensor_count = 0;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float numerator = 0.0;
	float denominator = 0.0;
	
	for (int i = 0; i < 54; i++) {
		if (i >= sensor_count) break;
		
		float d = distance(world_pos.xz, sensor_positions[i].xz);
		
		if (d < 0.1) {
			numerator = sensor_intensities[i];
			denominator = 1.0;
			break;
		}
		
		float w = 1.0 / (d * d);
		numerator += sensor_intensities[i] * w;
		denominator += w;
	}
	
	float intensity = 0.0;
	if (denominator > 0.0) {
		intensity = numerator / denominator;
	}
	
	float norm = clamp(intensity, 0.0, 1.0);
	vec3 color = vec3(1.0, 0.0, 0.0);
	
	if (norm > 0.66) {
		float p = (norm - 0.66) / 0.34;
		color = mix(vec3(1.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0), p);
	} else if (norm > 0.33) {
		float p = (norm - 0.33) / 0.33;
		color = mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 1.0, 0.0), p);
	} else {
		float p = norm / 0.33;
		color = mix(vec3(1.0, 0.0, 0.0), vec3(1.0, 0.5, 0.0), p);
	}
	
	ALBEDO = color;
	ALPHA = 0.6; // Ligeramente transparente
}
