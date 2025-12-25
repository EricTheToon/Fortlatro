#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 shockwaved;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01;

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
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

// GPU-optimized hash function for pseudo-random patterns
float hash(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

// GPU-optimized noise function
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

	number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
	number delta = high - low;

	number saturation_fac = 1. - max(0., 0.05*(1.1-delta));

	vec4 hsl = HSL(vec4(tex.r*saturation_fac, tex.g*saturation_fac, tex.b, tex.a));

	float t = shockwaved.y * 2.5 + mod(time, 1.);
	vec2 floored_uv = (floor((uv*texture_details.ba)))/texture_details.ba;
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 50.;

	// Optimized field calculation
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;

    float base_wave = (.5 + .5* cos( (shockwaved.x) * 2.612 + ( field + -.5 ) *3.14));
	
	// GPU-optimized lightning using analytical functions instead of loops
	vec2 lightning_uv = floored_uv * vec2(15., 12.);
	
	// Multiple diagonal lightning bolts using noise-based approach
	float lightning = 0.0;
	float angle1 = -0.3 + sin(time * 0.8) * 0.4;
	float angle2 = -0.3 + sin(time * 0.8 + 1.0) * 0.4;
	float angle3 = -0.3 + sin(time * 0.8 + 2.0) * 0.4;
	
	// Bolt 1
	vec2 rot1 = vec2(lightning_uv.x * cos(angle1) - lightning_uv.y * sin(angle1),
	                  lightning_uv.x * sin(angle1) + lightning_uv.y * cos(angle1));
	float noise1 = sin(rot1.x * 2.3 + time * 3.0) * 0.8 + sin(rot1.x * 4.7 - time * 2.0) * 0.4;
	float dist1 = abs(rot1.y - noise1 + shockwaved.x * 2.5);
	lightning += smoothstep(0.15, 0.0, dist1) + smoothstep(0.5, 0.0, dist1) * 0.6;
	
	// Bolt 2
	vec2 rot2 = vec2(lightning_uv.x * cos(angle2) - lightning_uv.y * sin(angle2),
	                  lightning_uv.x * sin(angle2) + lightning_uv.y * cos(angle2));
	float noise2 = sin(rot2.x * 2.3 + time * 3.0 + 1.0) * 0.8 + sin(rot2.x * 4.7 - time * 2.0 + 1.3) * 0.4;
	float dist2 = abs(rot2.y - noise2 + 0.7 + shockwaved.x * 2.5);
	lightning += (smoothstep(0.15, 0.0, dist2) + smoothstep(0.5, 0.0, dist2) * 0.6) * 0.88;
	
	// Bolt 3
	vec2 rot3 = vec2(lightning_uv.x * cos(angle3) - lightning_uv.y * sin(angle3),
	                  lightning_uv.x * sin(angle3) + lightning_uv.y * cos(angle3));
	float noise3 = sin(rot3.x * 2.3 + time * 3.0 + 2.0) * 0.8 + sin(rot3.x * 4.7 - time * 2.0 + 2.6) * 0.4;
	float dist3 = abs(rot3.y - noise3 + 1.4 + shockwaved.x * 2.5);
	lightning += (smoothstep(0.15, 0.0, dist3) + smoothstep(0.5, 0.0, dist3) * 0.6) * 0.76;
	
	// GPU-optimized electrical crackles using noise
	vec2 crackle_uv = floored_uv * 25.;
	float crackle_t = time * 4.0 + shockwaved.x * 3.0;
	
	// Multi-frequency crackle pattern
	vec2 crackle_pos = crackle_uv + vec2(sin(crackle_t * 0.7), cos(crackle_t * 0.9)) * 3.;
	float crackle_pattern1 = sin(crackle_pos.x * 1.5 + crackle_t) * cos(crackle_pos.y * 1.3 - crackle_t * 0.8);
	crackle_pattern1 += sin(crackle_pos.x * 3.2 - crackle_t * 1.2) * cos(crackle_pos.y * 2.8 + crackle_t * 0.6);
	
	vec2 crackle_pos2 = crackle_uv + vec2(sin(crackle_t * 0.7 + 1.5), cos(crackle_t * 0.9 + 1.5)) * 3.;
	float crackle_pattern2 = sin(crackle_pos2.x * 1.5 + crackle_t + 1.5) * cos(crackle_pos2.y * 1.3 - crackle_t * 0.8 + 1.5);
	
	float crackle = smoothstep(0.88, 0.95, (crackle_pattern1 + 1.) * 0.5) 
	              + smoothstep(0.88, 0.95, (crackle_pattern2 + 1.) * 0.5) * 0.8;
	
	float total_lightning = clamp(lightning + crackle * 0.4, 0., 1.);
	
	// Edge glow
	float edge_dist = min(min(floored_uv.x, 1. - floored_uv.x), min(floored_uv.y, 1. - floored_uv.y));
	float edge_glow = smoothstep(0.15, 0.0, edge_dist) * (0.5 + sin(time * 2.0 + shockwaved.x * 4.0) * 0.3);
	
	// Purple base with white lightning
	hsl.x = 0.78 + sin(time * 1.5) * 0.03;
	hsl.y = 0.95;
	hsl.z = hsl.z * 0.25 + 0.45 + base_wave * 0.1 + edge_glow * 0.25;
	
	// Apply white lightning
	float lightning_strength = step(0.05, total_lightning);
	hsl.y = mix(hsl.y, mix(0.95, 0.1, total_lightning), lightning_strength);
	hsl.z = mix(hsl.z, mix(hsl.z, 0.98, total_lightning * 0.9), lightning_strength);
	
	// Pure white for strongest
	float strong_lightning = step(0.7, total_lightning);
	hsl.y = mix(hsl.y, 0.05, strong_lightning);
	hsl.z = mix(hsl.z, 0.99, strong_lightning);

    tex.rgb = RGB(hsl).rgb;

	// Alpha adjustments for glow - reduced for transparency
	if (tex[3] < 0.7)
		tex[3] = tex[3]/5.;
	
	// Boost alpha for lightning but keep it transparent
	if (total_lightning > 0.1) {
		tex.a = max(tex.a, 0.4 + total_lightning * 0.15);
	}
	
	// Reduce overall opacity to see cards behind
	tex.a = tex.a * 0.5;
	
	return dissolve_mask(tex*colour, texture_coords, uv);
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