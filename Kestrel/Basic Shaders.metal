//
//  Basic Shaders.metal
//  Kestrel
//
//  Created by Karl Groff on 2/21/22.
//

#include <metal_stdlib>
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
VertexOut basic_vertex(const VertexIn vertex_in [[stage_in]]) {
    VertexOut vertexOut;
    vertexOut.position = vertex_in.position;
    vertexOut.color = vertex_in.normal;
    return vertexOut;
}

[[fragment]]
float4 basic_fragment(VertexOut vertex_out [[stage_in]]) {
    return float4(vertex_out.color, 1);
}
