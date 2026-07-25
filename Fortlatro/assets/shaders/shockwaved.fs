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

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01 + (shockwaved.x * 0.00001);

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

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

	number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
	number delta = high - low;

	number saturation_fac = 1. - max(0., 0.05*(1.1-delta));

	vec4 hsl = HSL(vec4(tex.r*saturation_fac, tex.g*saturation_fac, tex.b, tex.a));

	// Animated lightning effect
	float t = time * 3.0 + shockwaved.x * 3.0;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/texture_details.ba;
    vec2 uv_centered = floored_uv - 0.5;
	
	// Distance and angle from center for radial explosion
	float dist_from_center = length(uv_centered) * 2.0;
	float angle = atan(uv_centered.y, uv_centered.x);
	
	// Removed white core - just gentle glow now
	float core_glow = smoothstep(0.25, 0.0, dist_from_center) * 2.5;
	
	// Main animated lightning rays - moving and flowing
	float lightning_rays = 0.0;
	for(float i = 0.; i < 24.; i++) {
		float ray_angle = i * 0.261799388 + time * 0.3; // Rotate rays over time
		
		// Animated jagged lightning pattern
		float jagged_offset = 0.0;
		jagged_offset += sin(dist_from_center * 8.0 + i * 2.3 + time * 2.5) * 0.25;
		jagged_offset += sin(dist_from_center * 16.0 + i * 1.7 - time * 3.5) * 0.15;
		jagged_offset += sin(dist_from_center * 32.0 + i * 3.1 + time * 5.0) * 0.08;
		
		float angle_diff = abs(mod(angle - ray_angle + jagged_offset + 3.14159265, 6.28318531) - 3.14159265);
		
		// Animated ray width
		float ray_width = 0.03 + sin(dist_from_center * 4.0 + i * 1.5 + time * 2.0) * 0.015;
		float ray_core = smoothstep(ray_width, 0.0, angle_diff);
		float ray_glow = smoothstep(ray_width * 4.0, 0.0, angle_diff) * 0.5;
		
		// Animated distance fade
		float ray_length = 0.9 + sin(i * 0.7 + time * 1.5) * 0.3;
		float distance_fade = smoothstep(ray_length, 0.1, dist_from_center);
		
		// Pulsing intensity per ray
		float ray_intensity = 0.8 + sin(i * 2.1 + time * 1.8) * 0.2;
		
		lightning_rays += (ray_core * 3.0 + ray_glow) * distance_fade * ray_intensity;
	}
	
	// Animated lightning branches
	float lightning_branches = 0.0;
	for(float j = 0.; j < 18.; j++) {
		float branch_angle = j * 0.349065850 + 0.174532925 + time * 0.5; // Move branches
		
		// Flowing jagged pattern
		float branch_jagged = 0.0;
		branch_jagged += sin(dist_from_center * 12.0 + j * 3.2 - time * 3.0) * 0.3;
		branch_jagged += sin(dist_from_center * 24.0 + j * 2.1 + time * 4.5) * 0.2;
		
		float branch_angle_diff = abs(mod(angle - branch_angle + branch_jagged + 3.14159265, 6.28318531) - 3.14159265);
		
		float branch_width = 0.02;
		float branch = smoothstep(branch_width * 2.0, 0.0, branch_angle_diff);
		
		// Animated fade
		float branch_length = 0.6 + sin(j * 1.3 + time * 1.2) * 0.2;
		float branch_fade = smoothstep(branch_length, 0.15, dist_from_center);
		
		lightning_branches += branch * branch_fade * 0.8;
	}
	
	// Animated burst particles
	float burst_particles = 0.0;
	for(float k = 0.; k < 32.; k++) {
		float particle_angle = k * 0.19634954 + time * 0.8; // Rotate particles
		float particle_offset = sin(k * 4.5 + time * 3.5) * 0.4;
		
		float particle_angle_diff = abs(mod(angle - particle_angle + particle_offset + 3.14159265, 6.28318531) - 3.14159265);
		
		float particle = smoothstep(0.015, 0.0, particle_angle_diff);
		
		// Pulsing outer edge
		float pulse = 0.5 + 0.5 * sin(time * 2.5 + k * 0.5);
		float particle_range = smoothstep(0.4, 0.6, dist_from_center) * smoothstep(1.1, 0.8, dist_from_center) * pulse;
		
		burst_particles += particle * particle_range * 0.6;
	}
	
	// Combine all lightning effects
	float total_energy = clamp(
		lightning_rays * 2.0 + 
		lightning_branches * 1.5 + 
		burst_particles * 1.2 +
		core_glow * 2.0,
		0., 6.0
	);
	
	// Color scheme: Magenta-pink-purple gradient (no white)
	if (total_energy > 0.1) {
		// Bright pink-magenta energy (Highest energy core - made much lighter/closer to white-pink)
		if (total_energy > 3.0) {
			hsl.x = 0.88; 
			hsl.y = 0.65; // Dropped saturation slightly to make it look brighter
			hsl.z = 0.88 + (total_energy - 3.0) * 0.04; // Increased lightness base from 0.75 to 0.88
		}
		// Medium pink-magenta
		else if (total_energy > 1.5) {
			hsl.x = 0.85; 
			hsl.y = 0.75;
			hsl.z = 0.80 + (total_energy - 1.5) * 0.05; // Increased lightness base from 0.65 to 0.80
		}
		// Medium purple-magenta
		else if (total_energy > 0.8) {
			hsl.x = 0.82; 
			hsl.y = 0.80;
			hsl.z = 0.70 + total_energy * 0.08; // Increased lightness base from 0.55 to 0.70
		}
		// Outer purple glow
		else {
			hsl.x = 0.78; 
			hsl.y = 0.75;
			hsl.z = 0.58 + total_energy * 0.10; // Increased lightness base from 0.45 to 0.58
		}
	} else {
		// Lighter purple background
		hsl.x = 0.77;
		hsl.y = 0.70;
		hsl.z = 0.65; 
	}

    tex.rgb = RGB(hsl).rgb;

	// Dynamic alpha based on energy
	if (tex[3] < 0.7)
		tex[3] = tex[3]/5.;
	
	if (total_energy > 0.15) {
		tex.a = max(tex.a, 0.4 + total_energy * 0.22);
	}
	
	tex.a = tex.a * 0.72;
	
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