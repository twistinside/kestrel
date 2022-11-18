#include <metal_stdlib>
#include <simd/simd.h>
#include "../../Application/Common.h"

using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal   [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 color;
};

[[vertex]]
VertexOut basic_vertex(const    VertexIn          vertex_in   [[stage_in]],
                       constant matrix_float4x4 & modelMatrix [[buffer(1)]]) {
    VertexOut vertexOut;
    vertexOut.position = modelMatrix * vertex_in.position;
    vertexOut.color = vertex_in.normal;
    return vertexOut;
}

[[fragment]]
float4 basic_fragment(VertexOut vertex_out [[stage_in]]) {
    return float4(vertex_out.color, 1);
}
