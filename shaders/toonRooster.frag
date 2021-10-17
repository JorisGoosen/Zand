#version 440

uniform float hoogteSchalingInv;
uniform float hoogteSchaling;

layout(binding = 0)	uniform sampler2D basis0;
layout(binding = 4)	uniform sampler2D snelheid0;

uniform bool isZand;
uniform vec3 zichtRicht;

out vec4 col;

in vec2 texFrag;


float waterHoogte(vec2 hier)
{
	//hier *= .5;
	vec2 basis = texture(basis0, texFrag + (hier / textureSize(basis0, 0))).rb;// * hoogteSchaling;

	return basis.x + basis.y;
}


void main()
{
	vec4 basis 		= texture(basis0, 	texFrag) * vec4(hoogteSchalingInv, 1, hoogteSchalingInv, 1);
	vec4 snelheid	= texture(snelheid0,texFrag);
	
	const vec3 zon 	= normalize(vec3(1,1,0));
	

	if(isZand)
	{
		vec3 normaal	= vec3(basis.a, snelheid.zw);
		float helder	=  dot(zon, normaal);
		col	= max(0.15, helder) * vec4(abs(-1.0 + (2.0 * basis.x)) , basis.x * 0.8, 0, 1);
	}
	else
	{
		if(basis.b <= 0.01)
			discard;

		//vec4 droesem 	= texture(snelheid0,	texFrag);

			vec4 	buren			= vec4(waterHoogte(ivec2(-1, 0)), waterHoogte(ivec2(1, 0)), waterHoogte(ivec2(0, 1)), waterHoogte(ivec2(0, -1)));
				//	burenSchuin		= vec4(waterHoogte(ivec2(-1, 1)), waterHoogte(ivec2(1, 1)), waterHoogte(ivec2(-1, -1)), waterHoogte(ivec2(1, -1)));
			//	vec2 gradienten		= //vec2(((buren.y + basis.r) / 2.0) - ((buren.x + basis.r) / 2.0), ((buren.z + basis.r) / 2.0) - ((buren.w + basis.r) / 2.0));
			//float verwachtteHoogte	= (som4(buren) + som4(burenSchuin)) / 8.0;

			vec3 normaal			= normalize(vec3((buren.y - buren.x) * 2.0, 4.0, (buren.z - buren.w) * 2.0));
									//normalize(vec3(((buren.y + basis.r) - (buren.x + basis.r)), 4.0, ((buren.z + basis.r) - (buren.w + basis.r))));

			

			vec3 	schijn		= reflect(zon, normaal);
			float 	helder		= dot(zon, normaal),
					schijnsel	= pow(max(0, min(1, dot(zichtRicht, schijn))), 900);

		

		snelheid.xy *= hoogteSchalingInv;

		col = mix(
			vec4(0.0, 0.0, 
				//vec4((snelheid.xy), 
				 0.4 + ( 0.6 * helder), 0.2 * helder + 0.5),
				 vec4(vec3(1), 0.8), 
				 schijnsel);
				 //col = vec4(normaal, schijnsel);
	}
}