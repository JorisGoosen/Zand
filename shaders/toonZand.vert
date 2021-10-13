#version 440

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec2 vTex;

uniform mat4 projectie;
uniform mat4 modelView;

out vec2 tex;

void main()
{
	tex 		= vTex;
	gl_Position = projectie * modelView * vec4(vPos, 1.0);
}