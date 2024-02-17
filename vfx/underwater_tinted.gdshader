shader_type canvas_item;
render_mode blend_mix;

// Wind settings.
uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.01;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset : hint_range(0.0, 1.0);
uniform float offset = 0; 

// Tint settings.
uniform vec4 topColor = vec4(1.0, 1.0, 1.0, 1.0); // Lighter at the top, with hint_color in the Godot Editor
uniform vec4 bottomColor = vec4(0.0, 0.0, 0.0, 1.0); // Darker at the bottom, with hint_color in the Godot Editor
uniform float tintIntensity : hint_range(0.0, 1.0) = 0.5; // Control the blend intensity


float getWind(vec2 vertex, vec2 uv, float time){
    float diff = pow(maxStrength - minStrength, 2.0);
    float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
    float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
    
    return wind; 
}

void vertex() {
    vec4 pos = MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    float time = TIME * speed + offset;
    VERTEX.x += getWind(VERTEX.xy, UV, time);
}

void fragment() {
    // Interpolate between the top and bottom colors based on vertical position
    float blendFactor = mix(0.0, 1.0, UV.y * tintIntensity);
    vec4 tint = mix(bottomColor, topColor, blendFactor);

    // Apply the tint to the final color
    COLOR = texture(TEXTURE, UV) * tint;
}
