precision mediump float;

uniform vec2 resolution;
uniform float time;
uniform float sphereRadius;

vec2 waveFunction(float x, float t) {
    
    // Compute the wave function here
    float realPart = x;
    float imaginaryPart = t;

    // OSC msg / audio(?) input here



    


    return vec2(realPart, imaginaryPart);
}

float probabilityDensity(vec2 psi) {
    return dot(psi, psi);
}

float sphere(vec3 p, float radius) {
    return length(p) - radius;
}

vec3 getNormal(vec3 p) {
    float d = 0.001;
    vec2 e = vec2(d, 0);
    return normalize(vec3(
        sphere(p + e.xyy, sphereRadius) - sphere(p - e.xyy, sphereRadius),
        sphere(p + e.yxy, sphereRadius) - sphere(p - e.yxy, sphereRadius),
        sphere(p + e.yyx, sphereRadius) - sphere(p - e.yyx, sphereRadius)
    ));
}

float getWireframe(vec3 p, float radius, float lineWidth) {
    float d = sphere(p, radius);
    float b = abs(d) - lineWidth;
    return smoothstep(0.0, 0.01, b);
}

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
    vec3 dir = normalize(vec3(uv, -1.0));
    vec3 origin = vec3(0.0, 0.0, 5.0);
    
    float t = sphereRadius / dot(dir, -origin);
    vec3 p = origin + t * dir;
    vec3 n = getNormal(p);
    
    float wireframe = getWireframe(p, sphereRadius, 0.005);
    
    vec2 psi = waveFunction(acos(dot(n, vec3(0.0, 1.0, 0.0))), time);
    float density = probabilityDensity(psi);
    
    vec3 color = mix(vec3(0.0, 0.0, density), vec3(1.0), wireframe);
    
    gl_FragColor = vec4(color, 1.0);
}
