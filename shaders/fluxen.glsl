#version 440

#include "definities.glsl"

float hoogte(ivec2 hier)
{
	vec4 basis = imageLoad(basis0, hier);
	return (basis.r + basis.b);// * hoogteSchaling;
}

float lokaleHoogte;

float hoogteVerschilMet(ivec2 richting)
{
	richting += PLEK;

	//if(richting.x < 0 || richting.y < 0 || richting.x > imageSize(basis0).x || richting.y > imageSize(basis0).y)
	//	return lokaleHoogte - (2 * hoogteSchaling);

	return lokaleHoogte - hoogte(PLEK + richting);
}

void main()
{
	vec4 	basis 				= imageLoad(basis0, PLEK);
			lokaleHoogte 		= (basis.r + basis.b);
	vec4 	oudeFluxen 			= imageLoad(flux0, PLEK),
		 	hoogteVerschillen 	= vec4(hoogteVerschilMet(ivec2(-1, 0)), hoogteVerschilMet(ivec2(1, 0)), hoogteVerschilMet(ivec2(0, 1)), hoogteVerschilMet(ivec2(0, -1))),
		 	nieuweFluxen 		= max(vec4(0.0f), oudeFluxen + (TIJD_STAP * PIJP_DIKTE * ((ZWAARTEKRACHT * hoogteVerschillen)/PIJP_LENGTE))),
			droesemFluxen		= nieuweFluxen / max(1, basis.b) ;
	float 	waterK 				= min(1, basis.b / (som4(nieuweFluxen) 	* TIJD_STAP)),
			droesemK 			= min(1, basis.g / (som4(droesemFluxen) * TIJD_STAP));

	imageStore(flux1, 		PLEK, nieuweFluxen 	* waterK	);
	imageStore(droesemFlux, PLEK, droesemFluxen * droesemK	);
}