#version 440

layout(binding = 0)	uniform sampler2D basis0;

out vec4 col;

in vec2 texFrag;

void main()
{
	vec4 basis = texture(basis0, texFrag);
	col =  vec4(basis.x-basis.b,0,basis.b * 10.0,1);// : vec4(,0,0,1);
}