/*{ "osc": 4000 }*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform sampler2D osc_tidal;
uniform sampler2D video1;
uniform sampler2D video2;

vec2 rotate(in vec2 p, in float t) {
    return mat2(cos(t), -sin(t), sin(t), cos(t)) * p;
}
float random(in vec2 st) {
    return fract(abs(sin(dot(st, vec2(94.2984, 488.923))) * 234.9892));
}
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}
float rects(in vec2 p, in float t) {
    return random(vec2(p.x * .0001 + t * .008, floor(p.y * 17.)));
}
void main() {
    vec2 uv = gl_FragCoord.xy / resolution;
    vec2 p = (gl_FragCoord.xy * 2. - resolution) / min(resolution.x, resolution.y);
    p *= 3.4;

    p = rotate(p, time * .2);

    float l = length(p);
    float r = texture2D(osc_tidal, vec2(.0)).r * sin(l * 2. + 0.);
    float g = texture2D(osc_tidal, vec2(.4)).r * sin(l * 2. + 2.);
    float b = texture2D(osc_tidal, vec2(.7)).r * sin(l * 2. + 4.);
    // IMAGES
    float z = 19.01;
    float t = time * .2;
    vec2 uv0 = (uv - .5) * .9 + .5;
    vec2 uv1 = uv0 + vec2(noise(uv0 * z - t), noise(uv0 * z + t)) * .03;
    vec2 uv2 = uv1 + vec2(noise(uv1 * z + t), noise(uv1 * z - t)) * .02;

    float n = rects(p, time);
    // gl_FragColor = (texture2D(image1, uv1) + texture2D(image1, uv2)) * vec4(.2, .4, .5, 1);
    gl_FragColor = vec4(r, g, b, 1) * n;
    gl_FragColor += texture2D(backbuffer, rotate(uv - .5, time) * .9 +.5, time) * .93;
    // gl_FragColor = vec4(0);
}
