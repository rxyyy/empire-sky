texture tex;

float4 redGrade;
float4 greenGrade;
float4 blueGrade;

sampler Sampler0 = sampler_state
{
	Texture = (tex);
};

struct PixelShaderInput
{
	float3 TexCoord0 : TEXCOORD0;
};

float4 pixel_shader(PixelShaderInput input) : COLOR
{
	float4 color = tex2D(Sampler0, input.TexCoord0.xy);

	color.a = 1.0f;

	float4 result = float4(dot(redGrade, color), dot(greenGrade, color), dot(blueGrade, color), 1.0f);

	return result;
}

technique color_grading
{
	pass p0
	{
		PixelShader = compile ps_2_0 pixel_shader();
	}
}
