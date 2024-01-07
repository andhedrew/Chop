shader_type canvas_item;

void fragment() {
    // Sample the color of the current pixel
    vec4 color = texture(TEXTURE, UV);

    // Lighten the color slightly
    color.rgb += 0.05; // Adjust this value to control the amount of lightening
	
	
	// Calculate the average of the RGB values
    float average = (color.r + color.g + color.b) / 3.0;

    // Move the RGB values towards the average to reduce contrast
    // The factor controls the amount of contrast reduction
    float factor = 0.6; // Adjust this value between 0.0 and 1.0 to control the effect
    color.rgb = mix(color.rgb, vec3(average), factor);
	color.b += 0.05;

    // Ensure the color values remain within the valid range [0, 1]
    color.rgb = min(color.rgb, vec3(1.0));

    // Output the modified color
    COLOR = color;
}