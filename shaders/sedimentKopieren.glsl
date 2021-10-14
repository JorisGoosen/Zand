#version 440

#include "definities.glsl"

void main()
{
	//basis0/1    =  {   grond,     droesem,     water,      verzakking     }
	vec4 	nieuweBasis = imageLoad(basis1, PLEK),
			oudeBasis 	= imageLoad(basis0, PLEK); // maar bevat wel de nieuwe sediment waarde

	nieuweBasis.g = oudeBasis.g;

	//zand kan niet oneindig gestapeld worden dus... moet het soms ook inzakken
	//hoe bepaal je de hoek? 
	//afstand met een buur is 1 of wortel(2) voor diagonaal
	//bereken je dan vanaf hier en kijk je of je nieuw zand krijgt van buren en/of verliest ?
	//Maar hier kunnen we alleen maar bepalen wat het verschil zou zijn, we kunnen het nog niet verwerken want dan vernaggelen we de rest

	

	imageStore(basis1, PLEK, nieuweBasis);
}

/*
Angles of repose (van wikipedia https://en.wikipedia.org/wiki/Angle_of_repose )
Ashes 						40°
Asphalt (crushed) 			30–45°
Bark (wood refuse) 			45°
Bran 						30–45°
Chalk 						45°
Clay (dry lump) 			25–40°
Clay (wet excavated) 		15°
Clover seed 				28°
Coconut (shredded) 			45°
Coffee bean (fresh) 		35–45°
Earth 						30–45°
Flour (corn) 				30–40°
Flour (wheat) 				45°
Granite 					35–40°
Gravel (crushed stone) 		45°
Gravel (natural w/ sand)	25–30°
Malt 						30–45°
Sand (dry) 					34°
Sand (water filled) 		15–30°
Sand (wet) 					45°
Snow 						38°[4]
Urea (Granular) 			27° [5]
Wheat 						27° 
*/