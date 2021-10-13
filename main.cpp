#include <weergaveSchermPerspectief.h>
#include <geometrie/vierkantRooster.h>

int main()
{
	weergaveSchermPerspectief scherm("Perspectief Demo");
	scherm.maakVlakVerdelingsShader("toonZand", "shaders/toonZand.vert", "shaders/toonZand.frag", "shaders/toonZand.eval");

	glm::vec2 afmetingen = scherm.laadTextuurUitPng("basis.png", "basis0", false, false, false, GL_RGBA16F);

	glClearColor(0,0,0,0);

	vierkantRooster rooster(16, 16, 2.0f);

	float vlakverdelingen = 16;

	auto zetVlakverdelingenStandaardenOpnieuw = [&]()
	{
		if(vlakverdelingen <= 0)
			vlakverdelingen = 1;

		float 	binnen[] = {vlakverdelingen, vlakverdelingen},
				buiten[] = {vlakverdelingen, vlakverdelingen, vlakverdelingen, vlakverdelingen};

		glPatchParameterfv(GL_PATCH_DEFAULT_INNER_LEVEL, binnen);
		glPatchParameterfv(GL_PATCH_DEFAULT_OUTER_LEVEL, buiten);
	};

	zetVlakverdelingenStandaardenOpnieuw();
	
	scherm.setCustomKeyhandler([&](int key, int scancode, int action, int mods)
	{
		if(action == GLFW_PRESS || action == GLFW_REPEAT)
			switch(key)
			{
			case GLFW_KEY_I:	vlakverdelingen++;	zetVlakverdelingenStandaardenOpnieuw(); break;
			case GLFW_KEY_J:	vlakverdelingen--;	zetVlakverdelingenStandaardenOpnieuw(); break;
			}
	});

	while(!scherm.stopGewenst())
	{
		scherm.bereidRenderVoor();
		scherm.bindTextuur("basis0", 0);
		rooster.tekenJezelfPatchy();
		scherm.rondRenderAf();
	}
}