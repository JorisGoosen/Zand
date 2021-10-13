#version 440

#include "definities.glsl"

void main()
{
	vec4 	nieuweBasis = imageLoad(basis1, PLEK),
			oudeBasis 	= imageLoad(basis0, PLEK); // maar bevat wel de nieuwe sediment waarde

	nieuweBasis.g = oudeBasis.g;

	imageStore(basis1, PLEK, nieuweBasis);
}