var ncsDvisualizer=(()=>{var e,t,r,o=Object.create,a=Object.defineProperty,n=Object.getOwnPropertyDescriptor,u=Object.getOwnPropertyNames,f=Object.getOwnPropertySymbols,i=Object.getPrototypeOf,d=Object.prototype.hasOwnProperty,m=Object.prototype.propertyIsEnumerable,g=(e,t,r)=>t in e?a(e,t,{enumerable:!0,configurable:!0,writable:!0,value:r}):e[t]=r,l=(t,r,o,i)=>{if(r&&"object"==typeof r||"function"==typeof r)for(let e of u(r))d.call(t,e)||e===o||a(t,e,{get:()=>r[e],enumerable:!(i=n(r,e))||i.enumerable});return t},s=(e,t,r)=>(r=null!=e?o(i(e)):{},l(!t&&e&&e.__esModule?r:a(r,"default",{value:e,enumerable:!0}),e)),c=(e={"external-global-plugin:react"(e,t){t.exports=Spicetify.React}},function(){return t||(0,e[u(e)[0]])((t={exports:{}}).exports,t),t.exports}),p={},E=p,v={default:()=>function(){return P.default.createElement(U,null)}};for(r in v)a(E,r,{get:v[r],enumerable:!0});var x=s(c()),R={container:"app-module__container___thHYo_ncsDvisualizer",unavailable_message:"app-module__unavailable_message___HYGlM_ncsDvisualizer"},T=s(c());function h(){return T.default.createElement("svg",{width:"100px",height:"100px",viewBox:"0 0 100 100",preserveAspectRatio:"xMidYMid"},T.default.createElement("circle",{cx:"50",cy:"50",r:"0",fill:"none",stroke:"currentColor","stroke-width":"2"},T.default.createElement("animate",{attributeName:"r",repeatCount:"indefinite",dur:"1s",values:"0;40",keyTimes:"0;1",keySplines:"0 0.2 0.8 1",calcMode:"spline",begin:"0s"}),T.default.createElement("animate",{attributeName:"opacity",repeatCount:"indefinite",dur:"1s",values:"1;0",keyTimes:"0;1",keySplines:"0.2 0 0.8 1",calcMode:"spline",begin:"0s"})),T.default.createElement("circle",{cx:"50",cy:"50",r:"0",fill:"none",stroke:"currentColor","stroke-width":"2"},T.default.createElement("animate",{attributeName:"r",repeatCount:"indefinite",dur:"1s",values:"0;40",keyTimes:"0;1",keySplines:"0 0.2 0.8 1",calcMode:"spline",begin:"-0.5s"}),T.default.createElement("animate",{attributeName:"opacity",repeatCount:"indefinite",dur:"1s",values:"1;0",keyTimes:"0;1",keySplines:"0.2 0 0.8 1",calcMode:"spline",begin:"-0.5s"})))}var y=s(c()),b=s(c());function C(e){const{onInit:o,onResize:i,onRender:a,data:n,isEnabled:t}=e,u=(0,b.useRef)(null),[l,s]=(0,b.useState)(null),c=(0,b.useCallback)(e=>{var t=Math.min(e.clientWidth,e.clientHeight),t=Math.round(t*window.devicePixelRatio);e.width===t&&e.height===t||(e.width=e.height=t)},[]);return(0,b.useEffect)(()=>{if(o){var e,t,r=u.current;if(r)return e=r.getContext("webgl2"),t=o(e),c(r),i(e,t),s(t),()=>s(null)}},[o]),(0,b.useEffect)(()=>{if(t&&l&&a){var e=u.current;if(e){const r=e.getContext("webgl2");let t=0;const o=e=>{l&&(a(r,n,l,e),t=requestAnimationFrame(o))};return t=requestAnimationFrame(o),()=>{t&&cancelAnimationFrame(t)}}}},[a,n,l,t]),(0,b.useEffect)(()=>{if(u.current){const e=new ResizeObserver(()=>{var e=u.current;e&&(c(e),e=e.getContext("webgl2"))&&l&&i(e,l)});return e.observe(u.current),()=>e.disconnect()}},[i,l]),b.default.createElement("canvas",{ref:u,style:((e,t)=>{for(var r in t=t||{})d.call(t,r)&&g(e,r,t[r]);if(f)for(var r of f(t))m.call(t,r)&&g(e,r,t[r]);return e})({width:"100%",height:"100%",objectFit:"contain"},t?{}:{visibility:"hidden"})})}function A(e,t){let r=0,o=e.length;for(;1<o-r;){var i=Math.floor((o+r)/2);e[i].x<=t?r=i:o=i}return r}function S(e){return Math.pow(10,e/20)}function L(e,t,r,o,i){return e=(e=(e-t)/(r-t))*(i-o)+o}function _(e,t){return-.5*(e.x-t.x)*(e.y+t.y)}function D(o,e,t){if(0==t)return i=A(r=o,a=e),n=r[i],i>r.length-2?n.y:(r=r[i+1],L(a,n.x,r.x,n.y,r.y));var r,i=e-t/2,a=e+t/2,n=A(o,i),u=A(o,a);let l=0;if(n==u)return r=o[n],n>o.length-2?r.y:(e=o[n+1],(L(i,r.x,e.x,r.y,e.y)+L(a,r.x,e.x,r.y,e.y))/2);{let t=o[n],r=o[n+1];e={x:i,y:L(i,t.x,r.x,t.y,r.y)};l=_(e,r);for(let e=n+1;e<u;e++)t=r,r=o[e+1],l+=_(t,r);t=r,u>o.length-2?l+=t.y*(a-t.x):(r=o[u+1],e={x:a,y:L(a,t.x,r.x,t.y,r.y)},l+=_(t,e))}return l/t}var N=`#version 300 es

uniform float uScaledTime;
uniform float uAmplitude;
uniform int uSeed;

uniform int uDotCount;
uniform float uDotRadius;
uniform float uDotRadiusPX;

uniform float uDotSpacing;
uniform float uDotOffset;

uniform float uSphereRadius;
uniform float uFeather;

uniform float uNoiseFrequency;
uniform float uNoiseAmplitude;

in vec2 inPosition;

out vec2 fragUV;
out float fragDotRadiusPX;

// https://github.com/Auburn/FastNoiseLite

const float FREQUENCY = 0.01;

const float GAIN = 0.5;
const float LACUNARITY = 1.5;
const float FRACTAL_BOUNDING = 1.0 / 1.75;

const ivec3 PRIMES = ivec3(501125321, 1136930381, 1720413743);

const float GRADIENTS_3D[] = float[](
    0., 1., 1., 0.,  0.,-1., 1., 0.,  0., 1.,-1., 0.,  0.,-1.,-1., 0.,
    1., 0., 1., 0., -1., 0., 1., 0.,  1., 0.,-1., 0., -1., 0.,-1., 0.,
    1., 1., 0., 0., -1., 1., 0., 0.,  1.,-1., 0., 0., -1.,-1., 0., 0.,
    0., 1., 1., 0.,  0.,-1., 1., 0.,  0., 1.,-1., 0.,  0.,-1.,-1., 0.,
    1., 0., 1., 0., -1., 0., 1., 0.,  1., 0.,-1., 0., -1., 0.,-1., 0.,
    1., 1., 0., 0., -1., 1., 0., 0.,  1.,-1., 0., 0., -1.,-1., 0., 0.,
    0., 1., 1., 0.,  0.,-1., 1., 0.,  0., 1.,-1., 0.,  0.,-1.,-1., 0.,
    1., 0., 1., 0., -1., 0., 1., 0.,  1., 0.,-1., 0., -1., 0.,-1., 0.,
    1., 1., 0., 0., -1., 1., 0., 0.,  1.,-1., 0., 0., -1.,-1., 0., 0.,
    0., 1., 1., 0.,  0.,-1., 1., 0.,  0., 1.,-1., 0.,  0.,-1.,-1., 0.,
    1., 0., 1., 0., -1., 0., 1., 0.,  1., 0.,-1., 0., -1., 0.,-1., 0.,
    1., 1., 0., 0., -1., 1., 0., 0.,  1.,-1., 0., 0., -1.,-1., 0., 0.,
    0., 1., 1., 0.,  0.,-1., 1., 0.,  0., 1.,-1., 0.,  0.,-1.,-1., 0.,
    1., 0., 1., 0., -1., 0., 1., 0.,  1., 0.,-1., 0., -1., 0.,-1., 0.,
    1., 1., 0., 0., -1., 1., 0., 0.,  1.,-1., 0., 0., -1.,-1., 0., 0.,
    1., 1., 0., 0.,  0.,-1., 1., 0., -1., 1., 0., 0.,  0.,-1.,-1., 0.
);

float smootherStep(float t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}
vec3 smootherStep(vec3 coord) {
    return vec3(smootherStep(coord.x), smootherStep(coord.y), smootherStep(coord.z));
}

int hash(int seed, ivec3 primed) {
    return (seed ^ primed.x ^ primed.y ^ primed.z) * 0x27d4eb2d;
}

float gradCoord(int seed, ivec3 primed, vec3 d) {
    int hash = hash(seed, primed);
    hash ^= hash >> 15;
    hash &= 63 << 2;
    return d.x * GRADIENTS_3D[hash] + d.y * GRADIENTS_3D[hash | 1] + d.z * GRADIENTS_3D[hash | 2];
}

float perlinSingle(int seed, vec3 coord) {
    ivec3 coord0 = ivec3(floor(coord));
    vec3 d0 = coord - vec3(coord0);
    vec3 d1 = d0 - 1.0;
    vec3 s = smootherStep(d0);
    coord0 *= PRIMES;
    ivec3 coord1 = coord0 + PRIMES;
    float xf00 = mix(gradCoord(seed,                              coord0,                     d0), gradCoord(seed,          ivec3(coord1.x, coord0.yz),      vec3(d1.x, d0.yz)), s.x);
    float xf10 = mix(gradCoord(seed, ivec3(coord0.x, coord1.y, coord0.z), vec3(d0.x, d1.y, d0.z)), gradCoord(seed,          ivec3(coord1.xy, coord0.z),      vec3(d1.xy, d0.z)), s.x);
    float xf01 = mix(gradCoord(seed,          ivec3(coord0.xy, coord1.z),      vec3(d0.xy, d1.z)), gradCoord(seed, ivec3(coord1.x, coord0.y, coord1.z), vec3(d1.x, d0.y, d1.z)), s.x);
    float xf11 = mix(gradCoord(seed,          ivec3(coord0.x, coord1.yz),      vec3(d0.x, d1.yz)), gradCoord(seed,                              coord1,                     d1), s.x);
    float yf0 = mix(xf00, xf10, s.y);
    float yf1 = mix(xf01, xf11, s.y);
    return mix(yf0, yf1, s.z) * 0.964921414852142333984375f;
}

float fractalNoise(vec3 coord) {
    return perlinSingle(uSeed, coord) * FRACTAL_BOUNDING
        + perlinSingle(uSeed + 1, coord * LACUNARITY) * FRACTAL_BOUNDING * GAIN
        + perlinSingle(uSeed + 2, coord * LACUNARITY * LACUNARITY) * FRACTAL_BOUNDING * GAIN * GAIN;
}

void main() {
    vec2 dotPos = vec2(float(gl_InstanceID % uDotCount), float(gl_InstanceID / uDotCount));
    float noise = fractalNoise(vec3(dotPos * uNoiseFrequency, uScaledTime)) * uNoiseAmplitude;

    vec3 dotCenter = vec3(dotPos * uDotSpacing + uDotOffset + noise, (noise + 0.5 * uNoiseAmplitude) * uAmplitude);
    
    float distanceFromCenter = length(dotCenter);
    dotCenter /= distanceFromCenter;
    distanceFromCenter = min(uSphereRadius, distanceFromCenter);
    dotCenter *= distanceFromCenter;

    float featherRadius = uSphereRadius - uFeather;
    float featherStrength = 1.0 - clamp((distanceFromCenter - featherRadius) / uFeather, 0.0, 1.0);
    dotCenter *= featherStrength * (uSphereRadius / distanceFromCenter - 1.0) + 1.0;

    dotCenter.y *= -1.0;

    gl_Position = vec4(dotCenter.xy + inPosition * uDotRadius * (1.0 + 1.0 / uDotRadiusPX), 0.0, 1.0);
    fragUV = inPosition;
    fragDotRadiusPX = uDotRadiusPX + 1.0;
}
`,B=`#version 300 es
precision highp float;

in vec2 fragUV;
in float fragDotRadiusPX;
out float outColor;

void main() {
    float t = clamp((1.0 - length(fragUV)) * fragDotRadiusPX, 0.0, 1.0);
    outColor = t;
}
`,I=`#version 300 es

uniform float uBlurRadius;
uniform vec2 uBlurDirection;

in vec2 inPosition;

out vec2 fragUV;
flat out vec2 fragBlurDirection;
flat out int fragSupport;
flat out vec3 fragGaussCoefficients;

float calculateGaussianTotal(int support, vec3 fragGaussCoefficients) {
    float total = fragGaussCoefficients.x;
    for (int i = 1; i < support; i++) {
        fragGaussCoefficients.xy *= fragGaussCoefficients.yz;
        total += 2.0 * fragGaussCoefficients.x;
    }
    return total;
}

void main() {
    fragSupport = int(ceil(1.5 * uBlurRadius)) * 2;
    fragGaussCoefficients = vec3(1.0 / (sqrt(2.0 * 3.14159265) * uBlurRadius), exp(-0.5 / (uBlurRadius * uBlurRadius)), 0.0);
    fragGaussCoefficients.z = fragGaussCoefficients.y * fragGaussCoefficients.y;
    fragGaussCoefficients.x /= calculateGaussianTotal(fragSupport, fragGaussCoefficients);

    gl_Position = vec4(inPosition, 0.0, 1.0);
    fragUV = (inPosition + 1.0) / 2.0;
    fragBlurDirection = uBlurDirection;
}
`,O=`#version 300 es
precision highp float;

uniform sampler2D uInputTexture;

in vec2 fragUV;
flat in vec2 fragBlurDirection;
flat in int fragSupport;
flat in vec3 fragGaussCoefficients;

out float outColor;

void main() {
    vec3 gaussCoefficients = fragGaussCoefficients;
    outColor = gaussCoefficients.x * texture(uInputTexture, fragUV).r;

    for (int i = 1; i < fragSupport; i += 2) {
        gaussCoefficients.xy *= gaussCoefficients.yz;
        float coefficientSum = gaussCoefficients.x;
        gaussCoefficients.xy *= gaussCoefficients.yz;
        coefficientSum += gaussCoefficients.x;

        float pixelRatio = gaussCoefficients.x / coefficientSum;
        vec2 offset = (float(i) + pixelRatio) * fragBlurDirection;

        outColor += coefficientSum * (texture(uInputTexture, fragUV + offset).r + texture(uInputTexture, fragUV - offset).r);
    }
}
`,z=`#version 300 es

uniform vec3 uOutputColor;
in vec2 inPosition;

out vec2 fragUV;
out vec3 fragOutputColor;

void main() {
    gl_Position = vec4(inPosition, 0.0, 1.0);
    fragUV = (inPosition + 1.0) / 2.0;
    fragOutputColor = uOutputColor;
}
`,G=`#version 300 es
precision highp float;

uniform sampler2D uBlurredTexture;
uniform sampler2D uOriginalTexture;

in vec2 fragUV;
in vec3 fragOutputColor;

out vec4 outColor;

void main() {
    float value = max(texture(uBlurredTexture, fragUV).r, texture(uOriginalTexture, fragUV).r);
    outColor = vec4(fragOutputColor * value, value);
}
`;function F(P){var e=(0,y.useMemo)(()=>{var e,t;return P.audioAnalysis?(e=(t=P.audioAnalysis.segments).flatMap(e=>e.loudness_max_time?[{x:e.start,y:S(e.loudness_start)},{x:e.start+e.loudness_max_time,y:S(e.loudness_max)}]:[{x:e.start,y:S(e.loudness_start)}]),t.length&&(t=t[t.length-1],e.push({x:t.start+t.duration,y:S(t.loudness_end)})),e):[{x:0,y:0}]},[P.audioAnalysis]),t=null!=(t=null==(t=P.audioAnalysis)?void 0:t.meta.timestamp)?t:0,r=(0,y.useCallback)(i=>{{var e,t,r,o,a,n,u,l,s,c,f,d,m,g,p,E,v,x,R,T,h,y,b,C,A,S,L,_,D,F,U;if(i)return T=(e,t,r)=>{var o=i.createProgram();return i.attachShader(o,e),i.attachShader(o,t),i.linkProgram(o),i.getProgramParameter(o,i.LINK_STATUS)||i.isContextLost()?o:(e=`Error: Failed to link ${r} shader`,t=i.getProgramInfoLog(o),console.error(e,t),P.onError(e),null)},D=e=>{var t=i.createFramebuffer(),r=(i.bindFramebuffer(i.FRAMEBUFFER,t),i.createTexture());return i.bindTexture(i.TEXTURE_2D,r),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_WRAP_S,i.CLAMP_TO_EDGE),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_WRAP_T,i.CLAMP_TO_EDGE),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_MIN_FILTER,e),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_MAG_FILTER,e),i.framebufferTexture2D(i.FRAMEBUFFER,i.COLOR_ATTACHMENT0,i.TEXTURE_2D,r,0),{framebuffer:t,texture:r}},(e=(y=(e,t,r)=>{e=i.createShader(e);return i.shaderSource(e,t),i.compileShader(e),i.getShaderParameter(e,i.COMPILE_STATUS)||i.isContextLost()?e:(t=`Error: Failed to compile ${r} shader`,r=i.getShaderInfoLog(e),console.error(t,r),P.onError(t),null)})(i.VERTEX_SHADER,N,"particle vertex"))&&(t=y(i.FRAGMENT_SHADER,B,"particle fragment"))&&(e=T(e,t,"particle"))&&(t=i.getAttribLocation(e,"inPosition"),r=i.getUniformLocation(e,"uScaledTime"),o=i.getUniformLocation(e,"uAmplitude"),a=i.getUniformLocation(e,"uSeed"),n=i.getUniformLocation(e,"uDotCount"),u=i.getUniformLocation(e,"uDotRadius"),l=i.getUniformLocation(e,"uDotRadiusPX"),s=i.getUniformLocation(e,"uDotSpacing"),c=i.getUniformLocation(e,"uDotOffset"),f=i.getUniformLocation(e,"uSphereRadius"),d=i.getUniformLocation(e,"uFeather"),m=i.getUniformLocation(e,"uNoiseFrequency"),g=i.getUniformLocation(e,"uNoiseAmplitude"),p=y(i.VERTEX_SHADER,I,"blur vertex"))&&(E=y(i.FRAGMENT_SHADER,O,"blur fragment"))&&(p=T(p,E,"blur"))&&(E=i.getAttribLocation(p,"inPosition"),v=i.getUniformLocation(p,"uBlurRadius"),x=i.getUniformLocation(p,"uBlurDirection"),R=i.getUniformLocation(p,"uInputTexture"),h=y(i.VERTEX_SHADER,z,"finalize vertex"))&&(y=y(i.FRAGMENT_SHADER,G,"finalize fragment"))&&(T=T(h,y,"finalize"))?(h=i.getAttribLocation(T,"inPosition"),y=i.getUniformLocation(T,"uOutputColor"),b=i.getUniformLocation(T,"uBlurredTexture"),C=i.getUniformLocation(T,"uOriginalTexture"),{framebuffer:A,texture:S}=D(i.LINEAR),{framebuffer:L,texture:_}=D(i.LINEAR),{framebuffer:D,texture:F}=D(i.NEAREST),U=i.createBuffer(),i.bindBuffer(i.ARRAY_BUFFER,U),i.bufferData(i.ARRAY_BUFFER,new Float32Array([-1,-1,-1,1,1,1,1,-1]),i.STATIC_DRAW),i.enable(i.BLEND),i.blendEquation(i.MAX),{isError:!1,particleShader:e,blurShader:p,finalizeShader:T,viewportSize:0,inPositionLoc:t,inPositionLocBlur:E,inPositionLocFinalize:h,uScaledTimeLoc:r,uAmplitudeLoc:o,uSeedLoc:a,uDotCountLoc:n,uDotRadiusLoc:u,uDotRadiusPXLoc:l,uDotSpacingLoc:s,uDotOffsetLoc:c,uSphereRadiusLoc:f,uFeatherLoc:d,uNoiseFrequencyLoc:m,uNoiseAmplitudeLoc:g,uBlurRadiusLoc:v,uBlurDirectionLoc:x,uBlurInputTextureLoc:R,uOutputColorLoc:y,uBlurredTextureLoc:b,uOriginalTextureLoc:C,quadBuffer:U,particleFramebuffer:A,particleTexture:S,blurXFramebuffer:L,blurXTexture:_,blurYFramebuffer:D,blurYTexture:F}):{isError:!0}}return P.onError("Error: WebGL2 is not supported"),{isError:!0}},[]),o=(0,y.useCallback)((e,t)=>{!t.isError&&e&&(t.viewportSize=Math.min(e.canvas.width,e.canvas.height),e.viewport(0,0,e.canvas.width,e.canvas.height),e.bindTexture(e.TEXTURE_2D,t.particleTexture),e.texImage2D(e.TEXTURE_2D,0,e.R8,t.viewportSize,t.viewportSize,0,e.RED,e.UNSIGNED_BYTE,null),e.bindTexture(e.TEXTURE_2D,t.blurXTexture),e.texImage2D(e.TEXTURE_2D,0,e.R8,t.viewportSize,t.viewportSize,0,e.RED,e.UNSIGNED_BYTE,null),e.bindTexture(e.TEXTURE_2D,t.blurYTexture),e.texImage2D(e.TEXTURE_2D,0,e.R8,t.viewportSize,t.viewportSize,0,e.RED,e.UNSIGNED_BYTE,null))},[]),i=(0,y.useCallback)((e,t,r)=>{var o,i,a,n,u,l;!r.isError&&e&&(e.bindFramebuffer(e.FRAMEBUFFER,r.particleFramebuffer),e.clearColor(0,0,0,0),e.clear(e.COLOR_BUFFER_BIT),o=Spicetify.Player.getProgress()/1e3*75*.01,i=D(t.amplitudeCurve,Spicetify.Player.getProgress()/1e3,.15),a=t.seed,n=.9/100*.5*r.viewportSize,u=L(i,0,1,.675,.9),l=Math.pow(i+3,2)*(45/1568),e.useProgram(r.particleShader),e.uniform1f(r.uScaledTimeLoc,o),e.uniform1f(r.uAmplitudeLoc,i),e.uniform1i(r.uSeedLoc,a),e.uniform1i(r.uDotCountLoc,100),e.uniform1f(r.uDotRadiusLoc,.9/100),e.uniform1f(r.uDotRadiusPXLoc,n),e.uniform1f(r.uDotSpacingLoc,.9/99),e.uniform1f(r.uDotOffsetLoc,-.45),e.uniform1f(r.uSphereRadiusLoc,u),e.uniform1f(r.uFeatherLoc,l),e.uniform1f(r.uNoiseFrequencyLoc,.04),e.uniform1f(r.uNoiseAmplitudeLoc,.2*.9),e.bindBuffer(e.ARRAY_BUFFER,r.quadBuffer),e.enableVertexAttribArray(r.inPositionLoc),e.vertexAttribPointer(r.inPositionLoc,2,e.FLOAT,!1,0,0),e.drawArraysInstanced(e.TRIANGLE_FAN,0,4,1e4),e.bindTexture(e.TEXTURE_2D,r.particleTexture),e.bindFramebuffer(e.FRAMEBUFFER,r.blurXFramebuffer),e.clearColor(0,0,0,0),e.clear(e.COLOR_BUFFER_BIT),e.useProgram(r.blurShader),e.uniform1f(r.uBlurRadiusLoc,.01*r.viewportSize),e.uniform2f(r.uBlurDirectionLoc,1/r.viewportSize,0),e.uniform1i(r.uBlurInputTextureLoc,0),e.activeTexture(e.TEXTURE0),e.bindTexture(e.TEXTURE_2D,r.particleTexture),e.bindBuffer(e.ARRAY_BUFFER,r.quadBuffer),e.enableVertexAttribArray(r.inPositionLocBlur),e.vertexAttribPointer(r.inPositionLocBlur,2,e.FLOAT,!1,0,0),e.drawArrays(e.TRIANGLE_FAN,0,4),e.bindFramebuffer(e.FRAMEBUFFER,r.blurYFramebuffer),e.clearColor(0,0,0,0),e.clear(e.COLOR_BUFFER_BIT),e.uniform2f(r.uBlurDirectionLoc,0,1/r.viewportSize),e.bindTexture(e.TEXTURE_2D,r.blurXTexture),e.drawArrays(e.TRIANGLE_FAN,0,4),e.bindFramebuffer(e.FRAMEBUFFER,null),e.clearColor(0,0,0,0),e.clear(e.COLOR_BUFFER_BIT),e.useProgram(r.finalizeShader),e.uniform3f(r.uOutputColorLoc,t.themeColor.rgb.r/255,t.themeColor.rgb.g/255,t.themeColor.rgb.b/255),e.uniform1i(r.uBlurredTextureLoc,0),e.uniform1i(r.uOriginalTextureLoc,1),e.activeTexture(e.TEXTURE0),e.bindTexture(e.TEXTURE_2D,r.blurYTexture),e.activeTexture(e.TEXTURE1),e.bindTexture(e.TEXTURE_2D,r.particleTexture),e.bindBuffer(e.ARRAY_BUFFER,r.quadBuffer),e.enableVertexAttribArray(r.inPositionLocFinalize),e.vertexAttribPointer(r.inPositionLocFinalize,2,e.FLOAT,!1,0,0),e.drawArrays(e.TRIANGLE_FAN,0,4))},[]);return y.default.createElement(C,{isEnabled:P.isEnabled,data:{themeColor:P.themeColor,seed:t,amplitudeCurve:e},onInit:r,onResize:o,onRender:i})}function U(){const[e,r]=(0,x.useState)(0),[t,o]=(0,x.useState)(""),[i,a]=(0,x.useState)({themeColor:Spicetify.Color.fromHex("#535353")}),n=((0,x.useEffect)(()=>{const t=async e=>{var t,e=null==e?void 0:e.item;e?(t=Spicetify.URI.fromString(e.uri)).type!==Spicetify.URI.Type.TRACK?r(3):(r(0),t=`https://spclient.wg.spotify.com/audio-attributes/v1/audio-analysis/${t.id}?format=json`,[t,e]=await Promise.all([Spicetify.CosmosAsync.get(t).catch(console.error),Spicetify.extractColorPreset(e.metadata.image_url).then(e=>e[0].colorLight)]),t?t.error?n(`Error ${t.error.status}: `+t.error.message):(a({audioAnalysis:t,themeColor:e}),r(1)):r(4)):r(2)},e=e=>{null!=e&&e.data&&t(e.data)};return Spicetify.Player.addEventListener("songchange",e),t(Spicetify.Player.data),()=>Spicetify.Player.removeEventListener("songchange",e)},[]),(0,x.useCallback)(e=>{o(e),r(5)},[]));return x.default.createElement("div",{className:R.container},x.default.createElement(F,{isEnabled:1==e,onError:n,audioAnalysis:i.audioAnalysis,themeColor:i.themeColor}),0==e?x.default.createElement(h,null):2==e?x.default.createElement("div",{className:R.unavailable_message},"Start playing a song to see the visualization!"):3==e?x.default.createElement("div",{className:R.unavailable_message},"Error: The type of track you're listening to is currently not supported"):4==e?x.default.createElement("div",{className:R.unavailable_message},"Error: The audio analysis could not be loaded, please check your internet connection"):5==e?x.default.createElement("div",{className:R.unavailable_message},t):null)}var P=s(c());return s=p,l(a({},"__esModule",{value:!0}),s)})();const render=()=>ncsDvisualizer.default();