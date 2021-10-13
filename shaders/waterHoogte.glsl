#version 440

#include "definities.glsl"

vec4 fluxUit(ivec2 uitRichting)
{
	return imageLoad(flux1, PLEK + uitRichting);
}

float grondHoogte(ivec2 hier)
{
	return imageLoad(basis0, PLEK + hier).r;
}

/*
    basis0/1    =  {   grond,     droesem,         water,      ???     }
    flux0/1     =  {   links,     rechts,      boven,      onder   }
    snelheid0/1  =  {   snelheidX, snelheidY,   ???,    ???     }
*/

void main()
{
	vec4 basis 				= imageLoad(basis0, PLEK); 
	vec4 flux				= imageLoad(flux1,	PLEK);
	vec4 inFlux				= vec4(fluxUit(ivec2(-1, 0)).g, fluxUit(ivec2(1, 0)).r, fluxUit(ivec2(0, 1)).a, fluxUit(ivec2(0, -1)).b);  
	float volumeVerandering	= TIJD_STAP * (som4(inFlux) - som4(flux));
	basis.b					+= volumeVerandering;

	float droesem 			= basis.g;
	vec2 snelheid			= vec2(inFlux.g - flux.g + flux.r - inFlux.r / 2.0, inFlux.b - flux.b - inFlux.a - flux.a / 2.0);
	vec4 buren				= vec4(grondHoogte(ivec2(-1, 0)), grondHoogte(ivec2(1, 0)), grondHoogte(ivec2(0, 1)), grondHoogte(ivec2(0, -1)));
//	vec2 gradienten			= //vec2(((buren.y + basis.r) / 2.0) - ((buren.x + basis.r) / 2.0), ((buren.z + basis.r) / 2.0) - ((buren.w + basis.r) / 2.0));
	vec3 normaal			= normalize(vec3((buren.y - buren.x) * 2.0, 4.0, (buren.z * buren.w) * 2.0));
							//	normalize(vec3((((buren.y + basis.r) / 2.0) - ((buren.x + basis.r) / 2.0)) * 2.0, 4.0, (((buren.z + basis.r) / 2.0) - ((buren.w + basis.r) / 2.0)) * 2.0));
	float 	lokaleHelling	= sin(0.1 * acos(dot(normaal, vec3(0,1,0)))),
			draagkracht		= DROESEMKRACHT * lokaleHelling * length(snelheid);

	if(draagkracht > droesem)	
	{
		draagkracht = OPLOSHEID * (draagkracht - droesem);
		if(draagkracht > basis.x) draagkracht = basis.x;

	//	draagkracht *= TIJD_STAP;

		basis.x	-= draagkracht;
		droesem	+= draagkracht;
	}
	else if(draagkracht < droesem)
	{
		draagkracht = BEZINKHEID * (droesem - draagkracht);

	//	draagkracht *= TIJD_STAP;

		basis.x	+= draagkracht;
		droesem	-= draagkracht;
	}

	basis.g = droesem;
	basis.a = lokaleHelling;

	imageStore(basis1, 		PLEK, basis);
	imageStore(snelheidPlt, PLEK, vec4(snelheid,0,0));
}