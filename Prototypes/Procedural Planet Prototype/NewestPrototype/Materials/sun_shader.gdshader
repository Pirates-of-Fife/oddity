shader_type spatial;

uniform float time : hint_range(0.0, 100.0);
uniform vec4 sun_color : source_color;

void fragment() {
    // Basic animated glow effect based on time
    vec2 uv = FRAGCOORD.xy / vec2(512.0, 512.0);
    float glow = sin(uv.x * 10.0 + time) * 0.5 + 0.5;
    vec3 final_color = sun_color.rgb * glow;
    ALBEDO = final_color;
    EMISSION = final_color * 2.0;  // Add some emissive glow to simulate a sun's brightness
}
