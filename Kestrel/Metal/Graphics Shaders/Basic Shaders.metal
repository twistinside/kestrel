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

[[fragment]]
float4 mono_fragment(VertexOut vertex_out [[stage_in]]) {
    float brightness = (vertex_out.color.r + vertex_out.color.g + vertex_out.color.z) / 3;
    float3 mono_rgb = float3(brightness);
    return float4(mono_rgb, 1);
}

[[fragment]]
float4 weighted_mono_fragment(VertexOut vertex_out [[stage_in]]) {
    float r = 0.299 * vertex_out.color.r;
    float g = 0.587 * vertex_out.color.g;
    float b = 0.114 * vertex_out.color.b;
    float brightness = r + g + b;
    float3 mono_rgb = float3(brightness);
    return float4(mono_rgb, 1);
}

[[fragment]]
float4 weighted_mono_red_only_fragment(VertexOut vertex_out [[stage_in]]) {
    float r = 0.299 * vertex_out.color.r;
    float g = 0.587 * vertex_out.color.g;
    float b = 0.114 * vertex_out.color.b;
    float brightness = r + g + b;
    if (vertex_out.color.r > brightness) {
        return float4(vertex_out.color.r, brightness, brightness, 1);
    } else {
        return float4(float3(brightness), 1);
    }
}

[[fragment]]
float4 weighted_mono_green_only_fragment(VertexOut vertex_out [[stage_in]]) {
    float r = 0.299 * vertex_out.color.r;
    float g = 0.587 * vertex_out.color.g;
    float b = 0.114 * vertex_out.color.b;
    float brightness = r + g + b;
    if (vertex_out.color.g > brightness) {
        return float4(brightness, vertex_out.color.g, brightness, 1);
    } else {
        return float4(float3(brightness), 1);
    }
}

[[fragment]]
float4 weighted_mono_blue_only_fragment(VertexOut vertex_out [[stage_in]]) {
    float r = 0.299 * vertex_out.color.r;
    float g = 0.587 * vertex_out.color.g;
    float b = 0.114 * vertex_out.color.b;
    float brightness = r + g + b;
    if (vertex_out.color.b > brightness) {
        return float4(brightness, brightness, vertex_out.color.b, 1);
    } else {
        return float4(float3(brightness), 1);
    }
}
