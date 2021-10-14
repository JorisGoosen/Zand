#version 440

#define GEENPLAATJES
#include "definities.glsl" 

layout(binding = 0, rgba16f)	uniform image2D 	basis0;
layout(binding = 1)				uniform sampler2D 	basis1;
layout(binding = 2, rgba16f)	uniform image2D 	snelheidPlt;

//Hier gaan we iets raars doen. 
//We gaan de zojuist geschreven waardes in basis1 opvragen via texture voor interpolatie en dan wegschrijven naar basis0, 
//en dan straks weer terug naar basis1, zodat ze daaaarna weer in basis0 komen....
void main()
{
	vec2 plek 		= vec2(PLEK);
	vec2 snelheid 	= imageLoad(snelheidPlt, PLEK).xy;

	vec4 	huidigeBasis			= texture(basis1, plek 													/ vec2(imageSize(basis0))),
			geinterpoleerdeBasis 	= texture(basis1, (plek - (snelheid * TIJD_STAP * hoogteSchalingInv)) 	/ vec2(imageSize(basis0))),
			oudeBasis				= imageLoad(basis0, PLEK);
			
//	if(huidigeBasis.z > 0.0)
		oudeBasis.g = geinterpoleerdeBasis.g;

	imageStore(basis0, PLEK, oudeBasis);
}