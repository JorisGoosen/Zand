#include <weergaveSchermPerspectief.h>
#include <geometrie/vierkantRooster.h>

int main()
{
	weergaveSchermPerspectief scherm("Perspectief Demo");
	scherm.maakVlakVerdelingsShader("toonZand", 			"shaders/toonZand.vert", "shaders/toonZand.frag", "shaders/toonZand.eval"	);
	scherm.maakRekenShader(			"initialiseer", 		"shaders/initialiseer.glsl"													);
	scherm.maakRekenShader(			"fluxen", 				"shaders/fluxen.glsl"														);
	scherm.maakRekenShader(			"waterHoogte", 			"shaders/waterHoogte.glsl"													);

	glm::vec2 afmetingen = 	scherm.laadTextuurUitPng("basis.png", 	"basis0", 								false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"basis1", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"flux0", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"flux1", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"droesem0", afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"droesem1", afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							
	glClearColor(0,0,0,0);

	vierkantRooster rooster(128, 128, 4.0f);

	float vlakverdelingen = 32;

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

	size_t pingPong = 0;

	auto bindPlaatjes = [&]()
	{
		scherm.bindTextuurPlaatje("basis0", 	0	+		pingPong);
		scherm.bindTextuurPlaatje("basis1", 	0	+	(1-	pingPong));
		scherm.bindTextuurPlaatje("flux0", 		2	+		pingPong);
		scherm.bindTextuurPlaatje("flux1", 		2	+	(1-	pingPong));
		scherm.bindTextuurPlaatje("droesem0", 	4	+		pingPong);
		scherm.bindTextuurPlaatje("droesem1", 	4	+	(1-	pingPong));
	};

	auto bindTexturen = [&]()
	{
		scherm.bindTextuur("basis0", 			0	+		pingPong);
		scherm.bindTextuur("basis1", 			0	+	(1-	pingPong));
		scherm.bindTextuur("flux0", 			2	+		pingPong);
		scherm.bindTextuur("flux1", 			2	+	(1-	pingPong));
		scherm.bindTextuur("droesem0", 			4	+		pingPong);
		scherm.bindTextuur("droesem1", 			4	+	(1-	pingPong));
	};

	scherm.doeRekenVerwerker("initialiseer", glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);

	glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);

	while(!scherm.stopGewenst())
	{
		scherm.doeRekenVerwerker("fluxen", 		glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);	glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);
		scherm.doeRekenVerwerker("waterHoogte", glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);	glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);
		
		pingPong = 1 - pingPong;

		scherm.bereidRenderVoor("toonZand");
		bindTexturen();
		rooster.tekenJezelfPatchy();
		scherm.rondRenderAf();
	}
}