#include <weergaveSchermPerspectief.h>
#include <geometrie/vierkantRooster.h>

int main()
{
	weergaveSchermPerspectief scherm("Perspectief Demo");
	scherm.maakShader("toonZand", "shaders/toonZand.vert", "shaders/toonZand.frag");

	glClearColor(0,0,0,0);

	vierkantRooster rooster(16,16, 4.0f);
	
	while(!scherm.stopGewenst())
	{
		scherm.bereidRenderVoor();
		rooster.tekenJezelf();
		scherm.rondRenderAf();
	}
}