#version 440

#define GEENPLAATJES
#include "definities.glsl" 

layout(binding = 0, rgba16f)	uniform image2D 	basis0;
//layout(binding = 1)				uniform sampler2D 	basis1;
layout(binding = 1, rgba16f)	uniform image2D 	basis1;
layout(binding = 2, rgba16f)	uniform image2D 	snelheidPlt;

//Hier gaan we iets raars doen. 
//We gaan de zojuist geschreven waardes in basis1 opvragen via texture voor interpolatie en dan wegschrijven naar basis0, 
//en dan straks weer terug naar basis1, zodat ze daaaarna weer in basis0 komen....
void main()
{
	vec2 snelheid 	= imageLoad(snelheidPlt, PLEK).xy;

	if(length(snelheid) > 1.0)
		snelheid = normalize(snelheid);

	vec2 	plek 	= vec2(PLEK) + (snelheid);
	ivec2 	van		= ivec2(floor(plek)),
			naar	= ivec2(ceil(plek));

	float interpoleerDeze[4];
	
	interpoleerDeze[0] = imageLoad(basis1, van)					.g;
	interpoleerDeze[1] = imageLoad(basis1, ivec2(naar.x, van.y)).g;
	interpoleerDeze[2] = imageLoad(basis1, ivec2(van.x, naar.y)).g;
	interpoleerDeze[3] = imageLoad(basis1, naar)				.g;
	
	float interpolatie = 
		mix(
			mix(interpoleerDeze[0], interpoleerDeze[1], plek.x - float(van.x)),
			mix(interpoleerDeze[2], interpoleerDeze[3], plek.x - float(van.x)),
			plek.y - float(van.y)
		);

	vec4	//geinterpoleerdeBasis 	= imageLoad(basis1, PLEK),
			oudeBasis				= imageLoad(basis0, PLEK);
			
	oudeBasis.g = interpolatie;

	imageStore(basis0, PLEK, oudeBasis);
}