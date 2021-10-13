#include "definities.glsl"

void main()
{
    imageStore(basis0,   PLEK, imageLoad(basis0, PLEK) * vec4(1,0,4,0));
    imageStore(basis1,   PLEK, vec4(0.0f));
    imageStore(flux0,    PLEK, vec4(0.0f));
    imageStore(flux1,    PLEK, vec4(0.0f));
    imageStore(droesem0, PLEK, vec4(0.0f));
    imageStore(droesem1, PLEK, vec4(0.0f));
}