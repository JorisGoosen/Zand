#version 440

#include "definities.glsl"

vec4 fluxUit(ivec2 uitRichting)
{
	return imageLoad(flux1, PLEK + uitRichting);
}

vec4 droesemUit(ivec2 uitRichting)
{
	return imageLoad(droesemFlux, PLEK + uitRichting);
}

float grondHoogte(ivec2 hier)
{
	return imageLoad(basis0, PLEK + hier).r;// * hoogteSchaling;
}

/*
    basis0/1    =  {   grond,     droesem,         water,      ???     }
    flux0/1     =  {   links,     rechts,      boven,      onder   }
    snelheid0/1  =  {   snelheidX, snelheidY,   ???,    ???     }
*/

void main()
{
	vec4 	basis 				= imageLoad(basis0, 		PLEK),
			flux				= imageLoad(flux1,			PLEK),
			droesemFlux			= imageLoad(droesemFlux,	PLEK),
			inFlux				= vec4(fluxUit(		ivec2(-1, 0)).g, fluxUit(	ivec2(1, 0)).r, fluxUit(	ivec2(0, 1)).a, fluxUit(	ivec2(0, -1)).b),
			inDroesem			= vec4(droesemUit(	ivec2(-1, 0)).g, droesemUit(ivec2(1, 0)).r, droesemUit(	ivec2(0, 1)).a, droesemUit(	ivec2(0, -1)).b);			
	float 	volumeVerandering	= TIJD_STAP * (som4(inFlux) 	- som4(flux)		),
			droesemVerandering	= TIJD_STAP * (som4(inDroesem) 	- som4(droesemFlux)	);

	basis.b					+= volumeVerandering;

	float droesem 			= max(0.0f, basis.g + droesemVerandering);

	bool ikBenBron = false;
	
	const float afstand = distance(vec2(PLEK), imageSize(basis0) / 2.0);
	if(afstand < 5)
	{
		if(doeBron)
		{
			//if(afstand < 18)
				basis.b = max(hoogteSchaling * bronHoogte - afstand, basis.b + basis.r) - basis.r;

			if(doeSediment)
				droesem = DROESEMKRACHT * 0.5;
		}
		//ikBenBron = true;
	}

	
	
	vec2 snelheid			= vec2((inFlux.g - flux.g + flux.r - inFlux.r) / 2.0, (inFlux.a - flux.a + flux.b - inFlux.b ) / 2.0);
	vec4 buren				= vec4(grondHoogte(ivec2(-1, 0)), grondHoogte(ivec2(1, 0)), grondHoogte(ivec2(0, 1)), grondHoogte(ivec2(0, -1))),
			burenSchuin		= vec4(grondHoogte(ivec2(-1, 1)), grondHoogte(ivec2(1, 1)), grondHoogte(ivec2(-1, -1)), grondHoogte(ivec2(1, -1)));
//	vec2 gradienten			= //vec2(((buren.y + basis.r) / 2.0) - ((buren.x + basis.r) / 2.0), ((buren.z + basis.r) / 2.0) - ((buren.w + basis.r) / 2.0));
	vec3 normaal			= normalize(vec3((buren.y - buren.x) * 2.0, 4.0, (buren.z - buren.w) * 2.0));
								//normalize(vec3(((buren.y + basis.r) - (buren.x + basis.r)), 4.0, ((buren.z + basis.r) - (buren.w + basis.r))));

	float verwachtteHoogte	= (som4(buren) + som4(burenSchuin)) / 8.0;

//	vec2 snelheidRichting	= normalize(snelheid);
	float 	lokaleHelling	= min(1, max(0.00, 1.0-dot(normaal, normalize(vec3(0,1,0))))), //-vec3(snelheid.x,0,snelheid.y))))),
			afwijking 		= max(0.00, min(1, max(0, basis.r - verwachtteHoogte))),//
			draagkracht		= DROESEMKRACHT * afwijking * lokaleHelling * min(2, length(snelheid) * hoogteSchalingInv);



	//basis.b = max(0.0f, basis.b - 0.001f);


	if(!ikBenBron && basis.b <= 0.001f) //zelfde als in frag
	{
		basis.x += droesem;
		droesem = 0;
	}
	else if(!ikBenBron)
	{

		const float zandMult = 64.0;

		float bezinksel = max(1.0 / zandMult, draagkracht);

		if(draagkracht > droesem && OPLOSHEID > 0)	
		{
			draagkracht = OPLOSHEID * (draagkracht - droesem);
		//	draagkracht = max(1, draagkracht);

			//draagkracht *= zandMult;
			if(draagkracht * zandMult > basis.x) draagkracht = basis.x / zandMult;

		//	draagkracht *= TIJD_STAP;

			basis.x	-= draagkracht * zandMult;
			droesem	+= draagkracht ;
		}
		else if(bezinksel < droesem && droesem > draagkracht && (basis.x - verwachtteHoogte) < 0.0001 * hoogteSchaling)
		{
			//draagkracht = BEZINKHEID * (droesem - draagkracht);

		//	draagkracht *= TIJD_STAP;

			

			basis.x	+= bezinksel * zandMult;
			droesem	-= bezinksel;
		}
	}

	basis.g = droesem;
	basis.a = normaal.x;

	imageStore(basis1, 		PLEK, basis);// / vec4(hoogteSchaling, 1, hoogteSchaling, 1));
	imageStore(snelheidPlt, PLEK, vec4(snelheid,normaal.yz));
}