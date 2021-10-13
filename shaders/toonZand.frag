#version 440

out vec4 col;

in vec2 tex;

void main()
{
	col = vec4(tex, 0, 1);
}