texture tex;

sampler Sampler0 = sampler_state
{
	Texture = (tex);
};

float4 xform;
float limit = 1.0f;
float intensity = 1.0f;
float passes = 1.0f;

struct PixelShaderInput
{
	float3 TexCoord0 : TEXCOORD0;
};

float4 pixel_shader(PixelShaderInput input) : COLOR
{
	float2 uv = input.TexCoord0.xy;

	uv = uv * xform.zw + xform.xy;

	float4 result = tex2D(Sampler0, uv);

	result += saturate(result * 2.0f - float4(1.0f, 1.0f, 1.0f, 1.0f) * limit) * intensity * passes;
	result.a = 1.0f;

	return result;
}

technique radiosity
{
	pass p0
	{
		PixelShader = compile ps_2_0 pixel_shader();
	}
}
