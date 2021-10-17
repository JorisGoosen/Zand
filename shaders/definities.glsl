layout(local_size_x = 1, local_size_y=1) in;

#define PLEK ivec2(gl_GlobalInvocationID.xy)

#ifdef GEENPLAATJES
//dan doen we niks
#else
layout(binding = 0, rgba16f)	uniform image2D basis0;
layout(binding = 1, rgba16f)	uniform image2D basis1;
layout(binding = 2, rgba16f)	uniform image2D flux0;
layout(binding = 3, rgba16f)	uniform image2D flux1;
layout(binding = 4, rgba16f)  	uniform image2D snelheidPlt;
layout(binding = 5, rgba16f)  	uniform image2D droesemFlux;
#endif

/*
    basis0/1    =  {   grond,     droesem,     water,      ???     }
    flux0/1     =  {   links,     rechts,      boven,      onder   }
    snelheid0/1  =  {   snelheidX, snelheidY,   ???,    ???     }
*/

uniform float hoogteSchaling; //Als de hoogte van zand tussen 0 en 1 ligt, dan moeten we de afstand tussen de cellen afleiden uit textuurgroote en schaling
uniform float hoogteSchalingInv;

#define PIJP_DIKTE      1.0
#define PIJP_LENGTE     1.0
#define TIJD_STAP       0.05
#define ZWAARTEKRACHT   10.0 //misschien op 1 zetten?
#define DROESEMKRACHT   1.
#define OPLOSHEID       0.002
#define BEZINKHEID      0.001


float som4(vec4 telMeOp)
{
    return telMeOp.x + telMeOp.y + telMeOp.z + telMeOp.w;
}



