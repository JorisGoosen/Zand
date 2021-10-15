#version 440

#include "definities.glsl"

void main()
{   
    vec4 basis = imageLoad(basis0, PLEK) * vec4(hoogteSchaling,1,hoogteSchaling,1);
    imageStore(basis0,      PLEK, basis);
    imageStore(basis1,      PLEK, basis);
    imageStore(flux0,       PLEK, vec4(0.0f));
    imageStore(flux1,       PLEK, vec4(0.0f));
    imageStore(snelheidPlt, PLEK, vec4(0.0f));
}