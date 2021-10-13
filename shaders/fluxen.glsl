#version 440

#include "definities.glsl"

float hoogte(ivec2 hier)
{
	vec4 basis = imageLoad(basis0, hier);
	return basis.r + basis.b;
}

float lokaleHoogte;

float hoogteVerschilMet(ivec2 richting)
{
	return lokaleHoogte - hoogte(PLEK + richting);
}

void main()
{
	vec4 	basis 				= imageLoad(basis0, PLEK);
			lokaleHoogte 		= basis.r + basis.b;
	vec4 	oudeFluxen 			= imageLoad(flux0, PLEK);
	vec4 	hoogteVerschillen 	= vec4(hoogteVerschilMet(ivec2(-1, 0)), hoogteVerschilMet(ivec2(1, 0)), hoogteVerschilMet(ivec2(0, 1)), hoogteVerschilMet(ivec2(0, -1)));
	vec4 	nieuweFluxen 		= max(vec4(0.0f), oudeFluxen + (TIJD_STAP * PIJP_DIKTE * ((ZWAARTEKRACHT * hoogteVerschillen)/PIJP_LENGTE)));
	float 	K 					= min(1, basis.b / (som4(nieuweFluxen) * TIJD_STAP));

	imageStore(flux1, PLEK, K * nieuweFluxen);
}