#version 440

layout(local_size_x = 1, local_size_y=1) in;

#define PLEK ivec2(gl_GlobalInvocationID.xy)

layout(binding = 0, rgba16f)	uniform image2D basis0;
layout(binding = 1, rgba16f)	uniform image2D basis1;
layout(binding = 2, rgba16f)	uniform image2D flux0;
layout(binding = 3, rgba16f)	uniform image2D flux1;
layout(binding = 4, rgba16f)	uniform image2D droesem0;
layout(binding = 5, rgba16f)	uniform image2D droesem1;

/*
    basis0/1    =  {   grond,     ???,         water,      ???     }
    flux0/1     =  {   links,     rechts,      boven,      onder   }
    droesem0/1  =  {   snelheidX, snelheidY,   droesem,    ???     }
*/


#define PIJP_DIKTE      1.0
#define PIJP_LENGTE     1.0
#define TIJD_STAP       0.066666
#define ZWAARTEKRACHT   10.0 //misschien op 1 zetten?

float som4(vec4 telMeOp)
{
    return telMeOp.x + telMeOp.y + telMeOp.z + telMeOp.w;
}