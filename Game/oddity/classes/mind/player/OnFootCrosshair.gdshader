shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment()
{
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    // Invert the screen color's RGB channels
    vec3 inverted_color = vec3(1.0) - screen_color.rgb;
    
    // Output the inverted color with the original screen alpha
    COLOR = vec4(inverted_color, screen_color.a);
}
