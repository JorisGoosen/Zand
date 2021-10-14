#version 440

layout(binding = 0)	uniform sampler2D basis0;
layout(binding = 4)	uniform sampler2D snelheid0;

uniform bool isZand;

out vec4 col;

in vec2 texFrag;

void main()
{
	vec4 basis 		= texture(basis0, 	texFrag);
	if(isZand)	col	= vec4(basis.x * 0.5 + 0.5, basis.x * 0.8, 0, 1);
	else
	{
		//vec4 droesem 	= texture(snelheid0,	texFrag);

		if(basis.b <= 0.001)
			discard;

		col = vec4(0.0, 0.0, min(0.8, 0.2 + basis.b * 3.0), max(0.3, min(1, basis.b * 10.0)));
	}
}