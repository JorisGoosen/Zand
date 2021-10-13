#include "definities.glsl"

vec4 fluxUit(ivec2 uitRichting)
{
	return imageLoad(flux1, PLEK + uitRichting);
}


/*
    basis0/1    =  {   grond,     ???,         water,      ???     }
    flux0/1     =  {   links,     rechts,      boven,      onder   }
    droesem0/1  =  {   snelheidX, snelheidY,   droesem,    ???     }
*/

void main()
{
	vec4 basis 				= imageLoad(basis0, PLEK); 
	vec4 flux				= imageLoad(flux1,	PLEK);
	vec4 inFlux				= vec4(fluxUit(ivec2(-1, 0)).g, fluxUit(ivec2(1, 0)).r, fluxUit(ivec2(0, 1)).a, fluxUit(ivec2(0, -1)).b);  
	float volumeVerandering	= TIJD_STAP * (som4(inFlux) - som4(flux));
	basis.b					+= volumeVerandering;

	imageStore(basis1, PLEK, basis);

	vec4 oudeDroesem		= imageLoad(droesem0, PLEK);
	vec2 snelheid			= vec2(inFlux.g - flux.g + flux.r - inFlux.r / 2.0, inFlux.b - flux.b - inFlux.a - flux.a / 2.0);

	imageStore(droesem1, PLEK, vec4(snelheid, oudeDroesem.ba));
}