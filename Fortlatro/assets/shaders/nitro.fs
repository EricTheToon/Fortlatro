#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 nitro;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

// Noise function for flame movement
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec4 flame_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01;

	float t = time * 8.0 + 1500.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.8 * max(texture_details.b, texture_details.a);

    // Create flame-like movement with multiple noise layers
	vec2 flame_offset1 = uv_scaled_centered + vec2(sin(-t / 120.0) * 30.0, cos(-t / 80.0) * 15.0);
	vec2 flame_offset2 = uv_scaled_centered + vec2(cos(t / 90.0) * 25.0, sin(t / 110.0) * 20.0);
	vec2 flame_offset3 = uv_scaled_centered + vec2(sin(-t / 75.0) * 35.0, cos(-t / 95.0) * 12.0);

    // Generate flame field using noise and time
    float flame_noise1 = fbm(flame_offset1 * 0.05 + vec2(0.0, t * 0.02));
    float flame_noise2 = fbm(flame_offset2 * 0.08 + vec2(t * 0.015, 0.0));
    float flame_noise3 = fbm(flame_offset3 * 0.06 + vec2(0.0, -t * 0.025));

    float field = (flame_noise1 + flame_noise2 * 0.7 + flame_noise3 * 0.5) / 2.2;
    
    // Add upward flame movement
    float upward_bias = 1.0 - smoothstep(0.0, 1.0, floored_uv.y);
    field *= upward_bias;
    
    vec2 borders = vec2(0.15, 0.85);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 75.0 + ( field + -.3 ) * 4.2))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(6. + 4.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(6. + 4.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(6. + 4.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(6. + 4.*dissolve) : 0.)*(dissolve);

    // Apply flame colors based on intensity
    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.9*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        float flame_strength = smoothstep(adjusted_dissolve, adjusted_dissolve + 0.3, res);
        if (!shadow && res < adjusted_dissolve + 0.4*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = mix(burn_colour_1.rgba, burn_colour_2.rgba, flame_strength);
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

	number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
	number delta = high - low;

	number saturation_fac = 1. - max(0., 0.03*(1.2-delta));

	vec4 hsl = HSL(vec4(tex.r*saturation_fac, tex.g*saturation_fac, tex.b, tex.a));

	float t = mod(time*1.5, 1.);
	vec2 floored_uv = (floor((uv*texture_details.ba)))/texture_details.ba;
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 45.;

    // Create animated flame distortion
	vec2 flame_field1 = uv_scaled_centered + 40.*vec2(sin(-t / 95.0), cos(-t / 70.0));
	vec2 flame_field2 = uv_scaled_centered + 40.*vec2(cos(t / 45.0), sin(t / 55.0));
	vec2 flame_field3 = uv_scaled_centered + 40.*vec2(sin(-t / 65.0), cos(-t / 85.0));

    // Generate flame field with noise
    float field = (1.+ (
        cos(length(flame_field1) / 22.0) + sin(length(flame_field2) / 28.0) * cos(flame_field2.y / 18.0) +
        cos(length(flame_field3) / 25.0) * sin(flame_field3.x / 20.0) +
        fbm(uv_scaled_centered * 0.08 + vec2(0.0, t * 0.3)) * 0.6
        ))/2.5;

    // Add flickering effect
    float flicker = sin(time * 15.0 + uv.y * 10.0) * 0.1 + sin(time * 25.0) * 0.05;
    field += flicker;

    float res = (.5 + .5* cos( (time * 0.5) * 2.8 + ( field + -.4 ) *3.8));
    
    // Set orange flame colors
	hsl.x = 0.08 + sin(res * 6.28 + time * 2.0) * 0.03 + nitro.x * 0.00001;  // Orange hue with slight variation
	hsl.y = hsl.y * 0.95 + 0.4; // High saturation for vivid flames
	hsl.z = hsl.z * 0.3 + 0.45 * sin(hsl.z/2.2 - res/3.5 + sin(time * 2.0)/6. + 0.6)/1.1; // Dynamic lightness

    tex.rgb = RGB(hsl).rgb;

    // Add flame transparency effects
	if (tex[3] < 0.8)
		tex[3] = tex[3]/2.5;
		
    // Enhance flame edges
    float edge_glow = smoothstep(0.2, 0.8, res);
    tex.rgb *= (1.0 + edge_glow * 0.3);
    
	return flame_mask(tex*colour, texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif