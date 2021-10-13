#version 440

layout(binding = 0)	uniform sampler2D basis0;

out vec4 col;

in vec2 texFrag;

void main()
{
	col = texture(basis0, texFrag);
}