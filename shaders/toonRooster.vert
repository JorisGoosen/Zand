#version 440

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec2 vTex;

out vec2 tex;

void main()
{
	tex 		= vTex;
	gl_Position = vec4(vPos, 1.0);
}