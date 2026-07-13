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
	vec3 c_0 = vec3(0.65, 0.0, 0.15); // -90 dBm (Dark Red)
	vec3 c_1 = vec3(0.9, 0.2, 0.15);  // -80 dBm (Red)
	vec3 c_2 = vec3(0.95, 0.6, 0.2);  // -70 dBm (Orange)
	vec3 c_3 = vec3(0.95, 0.95, 0.6); // -60 dBm (Pale Yellow)
	vec3 c_4 = vec3(0.5, 0.8, 0.4);   // -50 dBm (Light Green)
	vec3 c_5 = vec3(0.1, 0.5, 0.2);   // -40 dBm (Dark Green)
	
	vec3 color;
	if (norm <= 0.2) {
		color = mix(c_0, c_1, norm / 0.2);
	} else if (norm <= 0.4) {
		color = mix(c_1, c_2, (norm - 0.2) / 0.2);
	} else if (norm <= 0.6) {
		color = mix(c_2, c_3, (norm - 0.4) / 0.2);
	} else if (norm <= 0.8) {
		color = mix(c_3, c_4, (norm - 0.6) / 0.2);
	} else {
		color = mix(c_4, c_5, (norm - 0.8) / 0.2);
	}
	
	ALBEDO = color;
	ALPHA = 0.6; // Ligeramente transparente
}
