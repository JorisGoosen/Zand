#version 440

uniform float hoogteSchalingInv;
uniform float hoogteSchaling;

layout(binding = 0)	uniform sampler2D basis0;
layout(binding = 4)	uniform sampler2D snelheid0;

uniform bool isZand;

out vec4 col;

in vec2 texFrag;

void main()
{
	vec4 basis 		= texture(basis0, 	texFrag) * vec4(hoogteSchalingInv, 1, hoogteSchalingInv, 1);
	vec4 snelheid	= texture(snelheid0,texFrag);
	vec3 normaal	= vec3(basis.a, snelheid.zw);
	float helder	=  dot(normalize(vec3(1,1,1)), normaal);

	if(isZand)	col	= max(0.5, helder) * vec4(abs(-1.0 + (2.0 * basis.x)) , basis.x * 0.8, 0, 1);
	else
	{
		//vec4 droesem 	= texture(snelheid0,	texFrag);

		if(basis.b <= hoogteSchalingInv)
			discard;

		snelheid.xy *= hoogteSchalingInv;

		col = vec4(length(snelheid.xy), basis.g,
				//vec4((snelheid.xy), 
				 0.8, 0.8);//max(0.2, min(0.8, basis.b * 10.0)));
	}
}