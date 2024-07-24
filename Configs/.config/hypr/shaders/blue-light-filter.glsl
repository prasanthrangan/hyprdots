https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437
precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

const float temperature = 2600.0;
const float temperatureStrength = 1.0;

vec3 colorTemperatureToRGB(float temperature) {
    mat3 m = (temperature <= 6500.0) 
        ? mat3(vec3(0.0, -2902.2, -8257.8),
               vec3(0.0, 1669.6, 2575.3),
               vec3(1.0, 1.33, 1.9))
        : mat3(vec3(1745.0, 1216.6, -8257.8),
               vec3(-2666.3, -2173.1, 2575.3),
               vec3(0.56, 0.7, 1.9));
    return mix(
        clamp(vec3(m[0] / (vec3(clamp(temperature, 1000.0, 40000.0)) + m[1]) + m[2]), vec3(0.0), vec3(1.0)),
        vec3(1.0),
        smoothstep(1000.0, 0.0, temperature)
    );
}

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    vec3 color = pixColor.rgb;
    color *= mix(1.0, dot(color, vec3(0.2126, 0.7152, 0.0722)) / max(dot(color, vec3(0.2126, 0.7152, 0.0722)), 1e-5), 1.0);
    color = mix(color, color * colorTemperatureToRGB(temperature), temperatureStrength);
    gl_FragColor = vec4(color, pixColor.a);
}
