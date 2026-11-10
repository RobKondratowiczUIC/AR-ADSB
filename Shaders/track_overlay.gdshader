shader_type canvas_item;

uniform vec3 line_color : source_color = vec3(0.0,1.0,0.0);
uniform float line_thickness = 0.05;

void fragment()
{
    vec2 centeredUV = 2.0*UV - vec2(1.0, 1.0);
	float value = abs((abs(centeredUV.y) + abs(centeredUV.x) - 1.0) + line_thickness);
	COLOR = vec4(line_color, step(value,line_thickness));
}