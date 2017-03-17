// Input.
struct GSInput
{
    float4 position : SV_POSITION;
    float4 velocity : VELOCITY;
    float4 color : COLOR;
    float4 scale : SCALE;
};

// Output.
struct GSOutput
{
    float4 position : SV_POSITION;
    float3 color : COLOR;
    float2 uv : UV;
};

// Meta data.
struct MetaData
{
    float4x4 vpMatrix;
    float3 lensPosition;
    float3 lensUpDirection;
    float pad[6];
};
// Meta buffer.
StructuredBuffer<MetaData> g_MetaBuffer : register(t0);

[maxvertexcount(4)]
void main(point GSInput input[1], inout TriangleStream<GSOutput> TriStream)
{
    GSOutput output;

    MetaData metaData = g_MetaBuffer[0];
    float4x4 vpMatrix = metaData.vpMatrix;
    float3 lensPosition = metaData.lensPosition;
    float3 lensUpDirection = metaData.lensUpDirection;

    float3 inPosition = input[0].position.xyz;
    float4 inColor = input[0].color;

    for (uint i = 0; i < 4; ++i)
    {
        float x = i == 1 || i == 3;
        float y = i == 0 || i == 1;

        output.position = float4(inPosition.x + x, inPosition.y + y, 0.f, 1.f);
        output.color = inColor;
        output.uv = float2(x, 1.f - y);

        TriStream.Append(output);
    }
}
