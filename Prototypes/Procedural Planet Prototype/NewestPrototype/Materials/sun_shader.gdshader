shader_type spatial;

uniform float time : hint_range(0.0, 100.0);
uniform vec4 sun_color : source_color;

void fragment() {

    vec2 uv = SCREEN_UV;


    float glow = (uv.x * 2.0 ) * 0.5 + 3.5;


    glow = smoothstep(0.3, 0.7, glow);


    vec3 final_color = sun_color.rgb * glow;





    ALBEDO = final_color;
    EMISSION = final_color * 1.5;
}