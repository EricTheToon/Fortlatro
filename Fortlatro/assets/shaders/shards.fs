#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 shards;
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

// Hash functions for random shard generation
vec2 hash22(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Jagged triangle distance function
float jaggedTriangleDist(vec2 p, float size, float rotation, float seed) {
    float c = cos(rotation);
    float s = sin(rotation);
    p = vec2(c * p.x - s * p.y, s * p.x + c * p.y);
    
    // Base triangle shape
    float k = sqrt(3.0);
    vec2 q = p;
    q.x = abs(q.x) - size;
    q.y = q.y + size / k;
    if (q.x + k * q.y > 0.0) {
        q = vec2(q.x - k * q.y, -k * q.x - q.y) / 2.0;
    }
    q.x -= clamp(q.x, -2.0 * size, 0.0);
    float baseDist = -length(q) * sign(q.y);
    
    // Add jagged edges using noise based on angle
    float angle = atan(p.y, p.x);
    float jag = 0.0;
    jag += sin(angle * 5.0 + seed * 30.0) * 0.04 * size;
    jag += sin(angle * 9.0 - seed * 20.0) * 0.03 * size;
    jag += sin(angle * 17.0 + seed * 50.0) * 0.025 * size;
    
    return baseDist - jag;
}

// Create scattered jagged triangular shards - RANDOM ALL OVER
float shardPattern(vec2 uv, float t) {
    float scale = 8.0; // Higher scale = more cells = more shards scattered everywhere
    vec2 cell_uv = uv * scale;
    vec2 i_st = floor(cell_uv);
    vec2 f_st = fract(cell_uv);
    
    float shard = 0.0;
    
    // Check neighboring cells for overlapping shards
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 cell_id = i_st + neighbor;
            
            // Random values for this cell
            float cell_rand = hash21(cell_id);
            vec2 cell_offset = hash22(cell_id);
            
            // ~70% of cells have shards - lots of random shards everywhere
            if (cell_rand > 0.3) {
                // Random shard position within cell
                vec2 shard_pos = neighbor + cell_offset * 0.8 + 0.1;
                vec2 p = f_st - shard_pos;
                
                // Larger varied sizes
                float size = 0.35 + cell_rand * 0.45;
                float rotation = cell_rand * 6.2831 + cell_offset.x * 4.0;
                
                // Get jagged triangle distance
                float d = jaggedTriangleDist(p, size, rotation, cell_rand);
                
                // Sharp edges
                float tri = 1.0 - smoothstep(-0.01, 0.01, d);
                
                if (tri > shard) {
                    shard = tri;
                }
            }
        }
    }
    
    return shard;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
    vec4 original_tex = tex;
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

	number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
	number delta = high - low;

	number saturation_fac = 1. - max(0., 0.05*(1.1-delta));
	vec4 hsl = HSL(vec4(tex.r*saturation_fac, tex.g*saturation_fac, tex.b, tex.a));

	float t = shards.y*2.221 + time;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/texture_details.ba;
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 50.;

    // Get shard mask - determines where shardss appear
    float shard_mask = shardPattern(floored_uv, t);
    shard_mask = clamp(shard_mask, 0.0, 1.0);
    
    // Only apply effect where shards exist
    if (shard_mask > 0.1) {
        // Rainbow shimmer field for the shards
        vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
        vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
        vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

        float field = (1.+ (
            cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
            cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
        float res = (.5 + .5* cos( (shards.x) * 2.612 + ( field + -.5 ) *3.14));
        
        // Rainbow hue shift based on position and time
        float rainbow_hue = res + floored_uv.x * 0.3 + floored_uv.y * 0.2 + sin(t * 0.5) * 0.1;
        
        // Apply rainbow effect only to shard areas
        hsl.x = rainbow_hue + shards.y * 0.04;
        hsl.y = min(1.0, hsl.y + 0.7); // High saturation for vivid colors
        hsl.z = hsl.z * 0.6 + 0.4 + shard_mask * 0.15; // Bright shards
        
        vec4 shard_color = RGB(hsl);
        
        // Blend shard color with original based on mask intensity
        tex.rgb = mix(original_tex.rgb, shard_color.rgb, shard_mask * 0.45);
    }

	if (tex[3] < 0.7)
		tex[3] = tex[3]/3.;

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
