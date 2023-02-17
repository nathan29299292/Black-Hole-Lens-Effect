shader_type spatial;
render_mode unshaded;

uniform float dist = 1.5;  // Default distance from camera.

uniform float scale = 1.0;	// The size of the blackhole.

uniform sampler2D bhcam;  // The black hole camera.

uniform vec2 effect_origin;	 // The origin of the blackhole.

void fragment() {
	float size;

    // Simulate the internal wrap around effect.
	if (dist < scale) {
		size = pow(pow(0.5, 1.0 / scale), dist); // (1/2^(sqrt(1.0 / scale)))^dist, creates a specific curve.
	} else {
		size = scale / (2.0 * (dist)); // Simulate the perspective effect normally.
	}

    // Create the lens effect.
	float lens = size + .124;

    // Create the two radii that represents the boundaries of each effect.
	bool edge = size > UV.y;
	bool lensing = lens > UV.y;

    // Generate the masks for the two boundaries.
	float bh = ceil(edge ? 1.0 : 0.0); // Black hole itself.
	float lensing_mask = ceil(lensing ? 1.0 : 0.0); // Lensing effect.

	float inv_bh = 1.0 - bh;

    if (bh > 0.999) {
		ALBEDO = vec3(0.0, 0.0, 0.0); // Black hole itself.
	} else if (lensing_mask > 0.999) {
		float distort =
			-pow(clamp(1.0 - (UV.y * 8.0) + lens * 8.0 - 1.0, 0.0, 1.0), 4); // Create a distortion effect using a curve.

		if (distort < -0.999) {
			ALBEDO = vec3(0.3, 0.1, 0.1);
			EMISSION = vec3(1);
		} else {
			ALBEDO = textureLod(bhcam,
								(SCREEN_UV - effect_origin) * (1.0 + distort) +
								effect_origin, 0.0).xyz;
		}
	} else {
		ALBEDO = vec3(0.0, 0.0, 0.0);
		ALPHA = 0.0;
		ALPHA_SCISSOR = 0.01;
	}
}
