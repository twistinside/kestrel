//
//  Basic Shaders.metal
//  Kestrel
//
//  Created by Karl Groff on 2/21/22.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[ attribute(0) ]];
};

vertex float4 basic_vertex(const VertexIn vertex_in [[ stage_in ]]) {
    return vertex_in.position;
}

fragment float4 basic_fragment() {
    return float4(1);
}
