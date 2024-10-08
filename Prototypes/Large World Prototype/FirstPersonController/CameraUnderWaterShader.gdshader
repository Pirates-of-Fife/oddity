shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Calculate a simple sine wave pattern for distortion
    float wave = sin(TIME + UV.x * 10.0 + UV.y * 10.0) * 0.01;
    
    // Apply the distortion to the UV coordinates
    vec2 distorted_uv = UV + vec2(wave, wave);
    
    // Sample the screen texture with the distorted UVs
    vec3 color = texture(SCREEN_TEXTURE, distorted_uv).rgb;
    
    // Apply a blue tint to simulate underwater color
    color = mix(color, vec3(0.0, 0.3, 0.6), 0.5);
    
    // Output the final color
    ALBEDO = color;
}
