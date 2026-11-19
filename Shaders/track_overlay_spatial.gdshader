shader_type spatial;
render_mode unshaded;

uniform vec3 line_color : source_color = vec3(0.0,1.0,0.0);
uniform float line_thickness = 0.05;
uniform float diamond_size = 500;

//void vertex() {
//    vec3 local_up = MODEL_MATRIX[1].xyz;
//    vec4 ax = vec4(normalize(cross(local_up, INV_VIEW_MATRIX[2].xyz)), 0.0);
//    vec4 ay = vec4(local_up.xyz, 0.0);
//    vec4 az = vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, local_up)), 0.0);
//    
//    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(ax, ay, az, MODEL_MATRIX[3]);
//    MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
//}

///TODO: doesnt seem to work with high aspect viewports like with a phone?
//void vertex()
//{
//    vec2 viewport_size = vec2(VIEWPORT_SIZE);
//    
//    float scale = diamond_size / viewport_size.y;
//    
//    float dist = distance(NODE_POSITION_WORLD, CAMERA_POSITION_WORLD);
//    
//    float world_scale = dist * scale * 2.0;
//	
//    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0] * world_scale, INV_VIEW_MATRIX[1] * world_scale, INV_VIEW_MATRIX[2] , MODEL_MATRIX[3]);
//}

void vertex()
{
    //// Fixed Size: Enabled
	//if (PROJECTION_MATRIX[3][3] != 0.0) {
	//	// Orthogonal matrix; try to do about the same with viewport size.
	//	float h = abs(1.0 / (2.0 * PROJECTION_MATRIX[1][1]));
	//	// Consistent with vertical FOV (Keep Height).
	//	float sc = (h * 2.0);
	//	MODELVIEW_MATRIX[0] *= sc;
	//	MODELVIEW_MATRIX[1] *= sc;
	//	MODELVIEW_MATRIX[2] *= sc;
	//} else {
	//	// Scale by depth.
	//	float sc;
	//	if (IS_MULTIVIEW) {
	//		// Assuming stereo rendering.
	//		// Moving in the z-plane gives the illusion of the object growing/shrinking in size.
	//		// We need to take the full distance to camera to compensate.
	//		sc = length((MODELVIEW_MATRIX)[3].xyz);
	//	} else {
	//		sc = -(MODELVIEW_MATRIX)[3].z;
	//	}
	//	MODELVIEW_MATRIX[0] *= sc;
	//	MODELVIEW_MATRIX[1] *= sc;
	//	MODELVIEW_MATRIX[2] *= sc;
	//}

	 MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
}

void fragment()
{
    vec2 centeredUV = 2.0*UV - vec2(1.0, 1.0);
	float value = abs((abs(centeredUV.y) + abs(centeredUV.x) - 1.0) + line_thickness);
	ALBEDO = vec3(line_color);
	ALPHA = step(value,line_thickness);
}