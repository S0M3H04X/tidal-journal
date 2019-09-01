precision mediump float;
uniform float time;
uniform vec2 resolution;

void main(void){
    vec3 rColor = vec3(0.9,0.0,0.3);
    vec3 gColor = vec3(0.0,0.9,0.3);
    vec3 bColor = vec3(0.0,0.3,0.9);
    vec3 yColor = vec3(0.9,0.9,0.3);
	
	
    vec2 p = (gl_FragCoord.xy*2.0-resolution);
    p /= min(resolution.x,resolution.y);
    
    float a = sin(p.y*1.5 - time*0.5)/1.0;
    float b = cos(p.y*1.5 - time*0.2)/1.0;
    float c = sin(p.y*1.5 - time*0.3 + 3.14)/1.0;
    float d = cos(p.y*1.5 - time*0.5 + 3.14)/1.0;
    
    float e = 0.2 / abs(p.x + a);
    float f = 0.1 / abs(p.x + b);
    float g = 0.1 / abs(p.x + c);
    float h = 0.1 / abs(p.x + d);
    
    vec3 destColor = rColor * e + gColor * f + bColor * g + yColor * h;
    gl_FragColor = vec4(destColor,1.0);
}
