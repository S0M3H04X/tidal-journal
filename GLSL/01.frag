#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
    // gl_FragColor = vec4(1.0,0.0,1.0,1.0);
    vec4 color = vec4(vec3(0.7,0.6,0.2),1.0);
    gl_FragColor = color;
}

vec4 red() {
    return vec4(1.0,0.0,0.0,1.0);
}
