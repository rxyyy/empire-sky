texture src;
texture dst;

float srcAlpha = 1.0f;

sampler dstSample = sampler_state
{
	Texture = (dst);
};

sampler srcSample = sampler_state
{
	Texture = (src);
};

struct PixelShaderInput
{
	float3 TexCoord0 : TEXCOORD0;
};

float4 pixel_shader(PixelShaderInput input) : COLOR
{
	float4 dst = tex2D(dstSample, input.TexCoord0.xy);
	float4 src = tex2D(srcSample, input.TexCoord0.xy);

	dst.rgb = (src.rgb - dst.rgb) * srcAlpha + dst.rgb;

	return dst;
}

technique color_blending
{
	pass p0
	{
		PixelShader = compile ps_2_0 pixel_shader();
	}
}
