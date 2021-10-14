#version 440

#include "definities.glsl"

void main()
{   
    imageStore(basis0,      PLEK, imageLoad(basis0, PLEK) * vec4(hoogteSchaling,0,hoogteSchaling,0));
    imageStore(basis1,      PLEK, vec4(0.0f));
    imageStore(flux0,       PLEK, vec4(0.0f));
    imageStore(flux1,       PLEK, vec4(0.0f));
    imageStore(snelheidPlt, PLEK, vec4(0.0f));
}