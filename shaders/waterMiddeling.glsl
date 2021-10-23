#version 440

#include "definities.glsl"


float waterHoogte(ivec2 hier)
{
	vec2 spul = imageLoad(basis0, PLEK + hier).rb;// * hoogteSchaling;

	return spul.y;
}

void main()
{
	vec4 	nieuweBasis = imageLoad(basis1, PLEK);
			

	vec4 buren			= vec4(waterHoogte(ivec2(-1, 0)), waterHoogte(ivec2(1, 0)), waterHoogte(ivec2(0, 1)), waterHoogte(ivec2(0, -1))),
		burenSchuin		= vec4(waterHoogte(ivec2(-1, 1)), waterHoogte(ivec2(1, 1)), waterHoogte(ivec2(-1, -1)), waterHoogte(ivec2(1, -1)));

	nieuweBasis.a = (((som4(buren) + som4(burenSchuin)) / 8.0) + nieuweBasis.b) / 2.0;

	imageStore(basis1, PLEK, nieuweBasis);
}
