#include "definities.glsl"

vec4 fluxUit(ivec2 uitRichting)
{
	return imageLoad(flux1, PLEK + uitRichting);
}

void main()
{
	vec4 basis 				= imageLoad(basis0, PLEK); 
	vec4 flux				= imageLoad(flux1,	PLEK);
	vec4 inFlux				= vec4(fluxUit(ivec2(-1, 0)).g, fluxUit(ivec2(1, 0)).r, fluxUit(ivec2(0, 1)).a, fluxUit(ivec2(0, -1)).b);  
	float volumeVerandering	= TIJD_STAP * (som4(inFlux) - som4(flux));
	basis.b					+= volumeVerandering;

	imageStore(basis1, PLEK, basis);
}