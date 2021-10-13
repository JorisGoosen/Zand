#version 440

layout(binding = 0)	uniform sampler2D basis0;
layout(binding = 4)	uniform sampler2D snelheid0;

out vec4 col;

in vec2 texFrag;

void main()
{
	vec4 basis 		= texture(basis0, 	texFrag);
	vec4 droesem 	= texture(snelheid0,	texFrag);
	//col =  //vec4(basis.x-basis.b,0,basis.b * 10.0,1);// : vec4(,0,0,1);
	col = mix(vec4(0.0, 0.0, 0.2 + basis.b * 10.0, 1.0), vec4(basis.x, basis.a, 0, 1), 1.0 - basis.b);
}