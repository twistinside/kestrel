#ifndef Common_h
#define Common_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 viewMatrix;
} Uniforms;

#endif /* Common_h */
