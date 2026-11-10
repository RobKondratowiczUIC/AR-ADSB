shader_type canvas_item;

// Godot automatically maps these uniforms to CameraTexture IDs when assigned
uniform sampler2D camera_y : hint_default_black;
uniform sampler2D camera_cbcr : hint_default_black;

void fragment() {
    // Read the split texture channels
    float y = texture(camera_y, UV).r;
    vec4 cbcr = texture(camera_cbcr, UV);
    
    // Shift CbCr values to a signed range (-0.5 to 0.5)
    float cb = cbcr.r - 0.5;
    float cr = cbcr.g - 0.5;
    
    // YCbCr to RGB conversion matrix standard
    float r = y + 1.402 * cr;
    float g = y - 0.344136 * cb - 0.714136 * cr;
    float b = y + 1.772 * cb;
    
    COLOR = vec4(r, g, b, 1.0);
}