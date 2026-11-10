shader_type spatial;
render_mode unshaded;

uniform vec3 line_color : source_color = vec3(0.0,1.0,0.0);
uniform float line_thickness = 0.05;
uniform float diamond_size = 500;

///TODO: doesnt seem to work with high aspect viewports like with a phone?
void vertex()
{
    vec2 viewport_size = vec2(VIEWPORT_SIZE);
    
    float scale = diamond_size / viewport_size.y;
    
    float dist = distance(NODE_POSITION_WORLD, CAMERA_POSITION_WORLD);
    
    float world_scale = dist * scale * 2.0;
	
    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0] * world_scale, INV_VIEW_MATRIX[1] * world_scale, INV_VIEW_MATRIX[2] , MODEL_MATRIX[3]);
}

//void vertex()
//{
//	 MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
//}

void fragment()
{
    vec2 centeredUV = 2.0*UV - vec2(1.0, 1.0);
	float value = abs((abs(centeredUV.y) + abs(centeredUV.x) - 1.0) + line_thickness);
	ALBEDO = vec3(line_color);
	ALPHA = step(value,line_thickness);
}