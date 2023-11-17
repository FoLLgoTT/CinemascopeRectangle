static const float targetAspectRatioLarge = 2.4;  			// aspect ratio for vertical lines
static const float targetAspectRatioSmall = 16.0 / 9.0;		// aspect ratio for horizontal lines inside the vertical lines
static const bool showVertical = true; 					// show vertical lines

SamplerState samp : register(s0);

float4 p0 : register(c0);
#define width  (p0[0])
#define height (p0[1])

static const float sourceAspectRatio = width / height;
static const float heightLimited = sourceAspectRatio / targetAspectRatioLarge;
static const float widthLimited = targetAspectRatioSmall / targetAspectRatioLarge;

float4 main(float2 uv : TEXCOORD0) : COLOR
{	
	float yTop = (1.0 - heightLimited) / 2.0;
	float yBottom = heightLimited + yTop;	
	
	if(uv.y >= yTop - 0.002 && uv.y < yTop || uv.y > yBottom && uv.y <= yBottom + 0.002)
		return float4(1.0, 0, 0, 1.0);
	
	if(showVertical)
	{
		float xLeft = (1.0 - widthLimited) / 2.0;
		float xRight = widthLimited + xLeft;
		
		if(uv.y > yTop && uv.y < yBottom &&
			(uv.x >= xLeft - 0.001 && uv.x < xLeft || uv.x > xRight && uv.x <= xRight + 0.001))
			return float4(1.0, 1.0, 0, 1.0);
	}
	
	return float4(tex2D(samp, uv).rgb, 1.0);
}