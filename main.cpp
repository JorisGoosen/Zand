#include <weergaveSchermPerspectief.h>
#include <geometrie/vierkantRooster.h>

int main()
{
	weergaveSchermPerspectief scherm("Perspectief Demo");
	scherm.maakVlakVerdelingsShader("toonRooster", 			"shaders/toonRooster.vert", "shaders/toonRooster.frag", "shaders/toonRooster.eval"	);
	scherm.maakRekenShader(			"initialiseer", 		"shaders/initialiseer.glsl"													);
	scherm.maakRekenShader(			"fluxen", 				"shaders/fluxen.glsl"														);
	scherm.maakRekenShader(			"waterHoogte", 			"shaders/waterHoogte.glsl"													);
	scherm.maakRekenShader(			"sedimentStroming", 	"shaders/sedimentStroming.glsl"												);
	scherm.maakRekenShader(			"sedimentKopieren", 	"shaders/sedimentKopieren.glsl"												);

	glm::vec2 afmetingen = 	scherm.laadTextuurUitPng("basis.png", 	"basis0", 								false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"basis1", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"flux0", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"flux1", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"snelheid", afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							scherm.maakTextuur(						"droesem", 	afmetingen.x, afmetingen.y, false, false, false, GL_RGBA16F);
							
	glClearColor(0,0,0,0);

	bool doeBron = true, doeSediment = false;

	vierkantRooster rooster(128, 128, 4.0f);

	float vlakverdelingen = 32, bronHoogte = 0.5f;

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

	scherm.zetEigenToetsVerwerker([&](int key, int scancode, int action, int mods)
	{
		if(action == GLFW_PRESS || action == GLFW_REPEAT)
			switch(key)
			{
			case GLFW_KEY_I:		vlakverdelingen++;	zetVlakverdelingenStandaardenOpnieuw(); break;
			case GLFW_KEY_J:		vlakverdelingen--;	zetVlakverdelingenStandaardenOpnieuw(); break;
			case GLFW_KEY_SPACE:	doeBron = !doeBron;	break;
			case GLFW_KEY_ENTER:	doeSediment = !doeSediment;	break;
			case GLFW_KEY_N:		bronHoogte = std::max(0.0f, bronHoogte - 0.02f); break;
			case GLFW_KEY_M:		bronHoogte = std::min(10.0f, bronHoogte + 0.02f); break;
			}
	});

	size_t pingPong = 0;


	auto zetHoogteSchalingUniform = [&]()
	{
		float hoogteSchaling = float(afmetingen.x);
		glUniform1f(glGetUniformLocation(scherm.huidigProgramma(), "hoogteSchaling"), 		hoogteSchaling );//1.0 / (/*(rooster.schaling() * 1.0) */ 1.0 / float(afmetingen.x)));
		glUniform1f(glGetUniformLocation(scherm.huidigProgramma(), "hoogteSchalingInv"), 	1.0 / hoogteSchaling );
		glUniform1i(glGetUniformLocation(scherm.huidigProgramma(), "doeBron"),				int(doeBron));
		glUniform1i(glGetUniformLocation(scherm.huidigProgramma(), "doeSediment"),			int(doeSediment));
		glUniform1f(glGetUniformLocation(scherm.huidigProgramma(), "bronHoogte"), 			bronHoogte );

	};

	auto bindPlaatjes = [&]()
	{
		scherm.bindTextuurPlaatje("basis0", 	0	+		pingPong);
		scherm.bindTextuurPlaatje("basis1", 	0	+	(1-	pingPong));
		scherm.bindTextuurPlaatje("flux0", 		2	+		pingPong);
		scherm.bindTextuurPlaatje("flux1", 		2	+	(1-	pingPong));
		scherm.bindTextuurPlaatje("snelheid", 	4);
		scherm.bindTextuurPlaatje("droesem", 	5);

		zetHoogteSchalingUniform();
	};

	auto bindTexturen = [&]()
	{
		scherm.bindTextuur("basis0", 			0	+		pingPong);
		scherm.bindTextuur("basis1", 			0	+	(1-	pingPong));
		scherm.bindTextuur("flux0", 			2	+		pingPong);
		scherm.bindTextuur("flux1", 			2	+	(1-	pingPong));
		scherm.bindTextuur("snelheid", 			4);
		scherm.bindTextuur("droesem", 			5);

		zetHoogteSchalingUniform();
	};

	auto bindVoorStroming = [&]()
	{
		if(pingPong == 0)
		{
			scherm.bindTextuur(			"basis0", 0);
			scherm.bindTextuurPlaatje(	"basis1", 1);
		}
		else
		{
			scherm.bindTextuur(			"basis1", 0);
			scherm.bindTextuurPlaatje(	"basis0", 1);
		}
		scherm.bindTextuurPlaatje("snelheid", 	4);
		scherm.bindTextuurPlaatje("droesem", 	5);

		zetHoogteSchalingUniform();
	};

	scherm.doeRekenVerwerker("initialiseer", glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);

	glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);

	auto zetIsZand = [&](bool isZand) { glUniform1ui(glGetUniformLocation(scherm.huidigProgramma(), "isZand"), static_cast<uint>(isZand)); };

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_DEPTH_TEST);
	//glCullFace(GL_CCW);
	glEnable(GL_CULL_FACE);

	while(!scherm.stopGewenst())
	{
		scherm.doeRekenVerwerker("fluxen", 				glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);		glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);
		scherm.doeRekenVerwerker("waterHoogte", 		glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);		glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);
		//scherm.doeRekenVerwerker("sedimentStroming", 	glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);		glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);
		//scherm.doeRekenVerwerker("sedimentKopieren", 	glm::uvec3(afmetingen.x, afmetingen.y, 1), bindPlaatjes);		glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT);
		
		pingPong = 1 - pingPong;

		glDisable(GL_BLEND);
		scherm.bereidRenderVoor("toonRooster");
		bindTexturen();
		zetIsZand(true);
		rooster.tekenJezelfPatchy();

		glEnable(GL_BLEND);
		
		scherm.bereidRenderVoor("toonRooster", false);
		bindTexturen();
		zetIsZand(false);
		rooster.tekenJezelfPatchy();

		scherm.rondRenderAf();
	}
}