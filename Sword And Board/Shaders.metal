//
//  Shaders.metal
//  MyFirstMetalGame
//
//  Created by Max Sonderegger on 9/25/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

#include <simd/simd.h>

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#import "ShaderTypes.h"

#include <metal_stdlib>

#define LIGHTCOUNT 3

using namespace metal;

struct VertexIn {
    float3 position     [[attribute(0)]];
    float3 normal       [[attribute(1)]];
    float2 texCoords    [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 worldNormal;
    float3 worldPosition;
    float2 texCoords;
};

struct OutColor {
    float4 firstColor   [[color(0)]];
    float4 secondColor  [[color(1)]];
};

struct Light {
    float3 worldPosition = float3(0, 0, 0);
    float3 color = float3(0, 0, 0);
};

struct VertexUniforms {
    float4x4 modelMatrix;
    float4x4 viewProjectionMatrix;
    float3x3 normalMatrix;
};

struct FragmentUniforms {
    float3 cameraWorldPosition;
    float3 ambientLightColor;
    float3 specularColor;
    float specularPower;
    Light lights[LIGHTCOUNT];
};

vertex VertexOut vertex_main(VertexIn vertexIn [[stage_in]], constant VertexUniforms &uniforms [[buffer(1)]]) {
    float4 worldPosition = uniforms.modelMatrix * float4(vertexIn.position, 1);
    VertexOut vertexOut;
    vertexOut.position = uniforms.viewProjectionMatrix * worldPosition;
    vertexOut.worldPosition = worldPosition.xyz;
    vertexOut.worldNormal = uniforms.normalMatrix * vertexIn.normal;
    vertexOut.texCoords = vertexIn.texCoords;
    return vertexOut;
}

fragment OutColor fragment_main(VertexOut fragmentIn [[stage_in]],
                                constant FragmentUniforms &uniforms [[buffer(0)]],
                                texture2d<float, access::sample> baseColorTexture [[texture(0)]],
                                sampler baseColorSampler [[sampler(0)]]) {
    OutColor colorOut;
    float3 baseColor = baseColorTexture.sample(baseColorSampler, fragmentIn.texCoords).rgb;
    float3 specularColor = uniforms.specularColor;
    float3 N = normalize(fragmentIn.worldNormal.xyz);
    float3 V = normalize(uniforms.cameraWorldPosition - fragmentIn.worldPosition);
    float3 finalColor(0, 0, 0);
    for (int i = 0; i < LIGHTCOUNT; ++i) {
        float3 L = normalize(uniforms.lights[i].worldPosition - fragmentIn.worldPosition.xyz);
        float3 diffuseIntensity = saturate(dot(N, L));
        float3 H = normalize(L + V);
        float specularBase = saturate(dot(N, H));
        float specularIntensity = powr(specularBase, uniforms.specularPower);
        float3 lightColor = uniforms.lights[i].color;
        finalColor += uniforms.ambientLightColor * baseColor +
        diffuseIntensity * lightColor * baseColor +
        specularIntensity * lightColor * specularColor;
    }
    colorOut.firstColor = float4(finalColor, 1);
    
    float luma = 0.299f*finalColor.r + 0.587*finalColor.g + 0.114*finalColor.b;
    if (luma > 0.8) {
        colorOut.secondColor = float4(finalColor * 0.8, 1);
    } else {
        colorOut.secondColor = float4(0, 0, 0, 1);
    }
    
    return colorOut;
}

kernel void compositionFilter(
                              texture2d<float, access::read> source [[ texture(0) ]],
                              texture2d<float, access::read> mask [[ texture(1) ]],
                              texture2d<float, access::write> dest [[ texture(2) ]],
                              uint2 gid [[ thread_position_in_grid ]])
{
    float4 source_color = source.read(gid);
    float4 mask_color = mask.read(gid);
    float4 result_color = source_color + mask_color;
    
    dest.write(result_color, gid);
}
