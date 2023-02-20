#include <simd/simd.h>

#ifndef Common_h
#define Common_h

struct Uniforms {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 viewMatrix;
};

#endif /* Common_h */
