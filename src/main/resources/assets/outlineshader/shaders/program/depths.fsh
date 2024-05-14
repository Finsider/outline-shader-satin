#version 130

uniform sampler2D DiffuseSampler;
uniform sampler2D ParticlesDepthSampler;
uniform sampler2D TranslucentSampler;

in vec2 texCoord;
in vec2 oneTexel;
uniform vec2 InSize;
out vec4 fragColor;

void main(){
    vec2 uv1 = texCoord.xy / InSize.xy;
    float valor = 1.0 - length(uv1);
    float linewidth = valor / 800.0;

    vec2 uv = texCoord;
    vec2 uv_b = vec2(uv.x, uv.y + linewidth);
    vec2 uv_l = vec2(uv.x + linewidth, uv.y);
    vec2 uv_r = vec2(uv.x - linewidth, uv.y);
    vec2 uv_u = vec2(uv.x, uv.y - linewidth);

    vec4 center = texture(DiffuseSampler, texCoord.st);

    float near = 0.04;
    float far = 9;

    vec4 depthSample = texture(ParticlesDepthSampler, uv);
    vec4 depthSample_b = texture(ParticlesDepthSampler, uv_b);
    vec4 depthSample_l = texture(ParticlesDepthSampler, uv_l);
    vec4 depthSample_r = texture(ParticlesDepthSampler, uv_r);
    vec4 depthSample_u = texture(ParticlesDepthSampler, uv_u);

    float d1 = 1.0 - 2.0 * near * far / (far + near - (2.0 * depthSample.x - 1.0) * (far - near)) / far;
    float d2 = 1.0 - 2.0 * near * far / (far + near - (2.0 * depthSample_b.x - 1.0) * (far - near)) / far;
    float d3 = 1.0 - 2.0 * near * far / (far + near - (2.0 * depthSample_u.x - 1.0) * (far - near)) / far;
    float d4 = 1.0 - 2.0 * near * far / (far + near - (2.0 * depthSample_l.x - 1.0) * (far - near)) / far;
    float d5 = 1.0 - 2.0 * near * far / (far + near - (2.0 * depthSample_r.x - 1.0) * (far - near)) / far;

    float translucent = dot(texture(TranslucentSampler, uv).rgb, vec3(0.333));

    float alldif = 4.0 * d1 - 20.0 * translucent - d2- d3- d4- d5;

    fragColor = vec4(center.rgb + center.rgb * clamp(alldif * 20.0, 0.0, 1.0) * d1, center.a);
}
