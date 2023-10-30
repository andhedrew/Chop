shader_type canvas_item;

uniform float time_offset;

void fragment() {
    vec2 uv = UV;
    uv.x += mod(TIME + time_offset, 1.0); // Assuming the animation frames are arranged horizontally
    COLOR = texture(TEXTURE, uv);
}