shader_type sky;

uniform float grid_spacing = 10.0;
uniform float line_width = 0.15;

uniform vec3 line_color : source_color = vec3(1.0);
uniform vec3 background_color : source_color = vec3(0.0);

uniform vec3 north_color : source_color = vec3(1.0,0.0,0.0);
uniform vec3 east_color : source_color = vec3(0.0,0.0,1.0);
uniform vec3 south_color : source_color = vec3(1.0,0.5,0.5);
uniform vec3 west_color : source_color = vec3(0.5,0.5,1.0);

uniform vec3 horizon_color : source_color = vec3(0.0,1.0,0.0);

void sky() {
    // Direction from the camera into the sky.
    vec3 dir = normalize(EYEDIR);

    // Convert the viewing direction into angles.
    float azimuth = atan(dir.x, -dir.z);
    float elevation = asin(clamp(dir.y, -1.0, 1.0));

    // Convert radians to degrees.
    float azimuth_deg = degrees(azimuth);
    float elevation_deg = degrees(elevation);

    // Distance to the nearest 10-degree increment.
    float horizontal_dist = abs(mod(azimuth_deg + grid_spacing * 0.5, grid_spacing) - grid_spacing * 0.5);
    float vertical_dist = abs(mod(elevation_deg + grid_spacing * 0.5, grid_spacing) - grid_spacing * 0.5);
    
    float north_dist = abs(azimuth_deg);
    float east_dist = abs(azimuth_deg-90.0);
    float south_dist = 180.0-abs((azimuth_deg));
    float west_dist = abs(azimuth_deg+90.0);
    
    float horizon_dist = abs(elevation_deg);

    // Draw a line if either angle is close to a grid increment.
    //bool on_line =
    //    horizontal_dist < line_width ||
    //    vertical_dist < line_width;
    //COLOR = on_line ? line_color : background_color;
    
    //float onLine = 1.0-step(0.10, min(horizontal_dist,vertical_dist));
	float onLine = 1.0-smoothstep(line_width-0.1, line_width+0.1, min(horizontal_dist,vertical_dist));
    COLOR = (line_color*onLine) + ((1.0-onLine)*background_color);
    
	float onNorth = 1.0-smoothstep(line_width-0.1, line_width+0.1, north_dist);
    COLOR = (north_color*onNorth) +((1.0-onNorth)*COLOR);
    
    float onEast = 1.0-smoothstep(line_width-0.1, line_width+0.1, east_dist);
    COLOR = (east_color*onEast) +((1.0-onEast)*COLOR);
    
    float onSouth = 1.0-smoothstep(line_width-0.1, line_width+0.1, south_dist);
    COLOR = (south_color*onSouth) +((1.0-onSouth)*COLOR);
    
    float onWest = 1.0-smoothstep(line_width-0.1, line_width+0.1, west_dist);
    COLOR = (west_color*onWest) +((1.0-onWest)*COLOR);
    
    float onHorizon = 1.0-smoothstep(line_width-0.1, line_width+0.1, horizon_dist);
    COLOR = (horizon_color*onHorizon) +((1.0-onHorizon)*COLOR);
}