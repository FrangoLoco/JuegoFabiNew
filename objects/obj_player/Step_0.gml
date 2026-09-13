// --- ACTUALIZACION DE VARIABLES ---
// Use a custom variable for vertical speed, NOT built-in 'vspeed'
// Make sure to define 'v_velocidad = 0;' in your Create Event!
var derecha = keyboard_check(vk_right) || keyboard_check(ord("D"));
var izquierda = keyboard_check(vk_left) || keyboard_check(ord("A"));
var arriba = keyboard_check(vk_up) || keyboard_check(ord("W"));
var atacar = keyboard_check_pressed(vk_space);

// Calculate horizontal input (1, -1, or 0)
var h_input = derecha - izquierda; 

// --- MOVIMIENTOS CON SWITCH (Logic & State) ---
switch(mov) {
    case "frontal":
        sprite_index = spr_tai_frontal;
        v_velocidad = 0; // Reset vertical speed if standing still (optional)
        
        if (h_input != 0) mov = "caminar";
		if (atacar) {
	    mov = "ataque";
	    image_index = 0;   // Start animation from beginning
	    golpe_dado = false; // Reset hit tracker
	    sprite_index = Spr_tai_golpe;
}
        
        // SALTO
        if (arriba && place_meeting(x, y+1, Obj_Solido)) {
            v_velocidad = jump_speed; // jump_speed should be negative (e.g., -10)
            mov = "salto";
        }
        break;
        
    case "caminar":
        sprite_index = spr_tai_caminar;
        
        // Orientation
        if (h_input != 0) image_xscale = h_input;

        // Change State
        if (h_input == 0) mov = "frontal";
		if (atacar) {
	    mov = "ataque";
	    image_index = 0;   // Start animation from beginning
	    golpe_dado = false; // Reset hit tracker
	    sprite_index = Spr_tai_golpe;
}
        
        // SALTO
        if (arriba && place_meeting(x, y+1, Obj_Solido)) {
            v_velocidad = jump_speed;
            mov = "salto";
        }
        break;
        
    case "salto":
        sprite_index = spr_tai_salto;
        
        // Mid-air control
        if (h_input != 0) image_xscale = h_input;
        
        // Landed?
        if (place_meeting(x, y+1, Obj_Solido)) mov = "frontal";
        break;
		
		case "herido":
        sprite_index = spr_tai_salto; // Use jump or hurt sprite
        
        // 1. Apply Gravity (So you fall)
        v_velocidad += gravedad;
        
        // 2. Apply Friction to the horizontal knockback (Slow down over time)
        h_knockback = lerp(h_knockback, 0, 0.05); // 0.05 is the friction amount
        
        // 3. Horizontal Collision for Knockback
        if (place_meeting(x + h_knockback, y, Obj_Solido)) {
            while (!place_meeting(x + sign(h_knockback), y, Obj_Solido)) {
                x += sign(h_knockback);
            }
            h_knockback = 0;
        }
        x += h_knockback;
        
        // 4. Vertical Collision
        if (place_meeting(x, y + v_velocidad, Obj_Solido)) {
            while (!place_meeting(x, y + sign(v_velocidad), Obj_Solido)) {
                y += sign(v_velocidad);
            }
            v_velocidad = 0;
            
            // 5. RECOVERY: If we hit the floor and are moving slowly, recover
            if (abs(h_knockback) < 1) {
                mov = "frontal"; // Return to normal control
                invencible = true;      // Keep flashing/invincible for a bit longer
                alarm[0] = 60;          // Reset invincibility timer
            }
        }
        y += v_velocidad;
        break;
case "ataque":
        sprite_index = Spr_tai_golpe;
        v_velocidad += gravedad; 
        
        // STOP MOVEMENT
        if (place_meeting(x, y + 1, Obj_Solido)) {
             // Optional friction
        }
        
        // --- NEW HITBOX LOGIC ---
        // Hit on Frame 1 or later
        if (image_index >= 1 && golpe_dado == false) 
        {
            golpe_dado = true; // Mark as done
            
            // 1. Calculate Hit Position (50 pixels in front of center)
            var punch_x = x + (10 * image_xscale);
            var punch_y = y; // Since Origin is Middle Center, 'y' is chest height
            
            // 2. Check for Enemy in a CIRCLE (Radius 30)
            // This is much more forgiving than instance_place
            var hit_enemy = collision_circle(punch_x, punch_y, 30, Obj_Rata, false, true);
            
            // 3. If we hit something...
            if (hit_enemy != noone) 
            {
                // Kill the Rat
                instance_destroy(hit_enemy);
                
                // Optional: Create a "Hit" effect or play sound
            }
        }
        break;
}


// --- FÍSICA Y COLISIONES (The Fix) ---

// 1. Apply Gravity to our CUSTOM variable
v_velocidad += gravedad;

// 2. Horizontal Movement & Collision
// We calculate where we WANT to go
var h_move = h_input * velocidad;

if (place_meeting(x + h_move, y, Obj_Solido)) {
    // If we are about to hit a wall, move 1 pixel at a time until we touch it
    while (!place_meeting(x + sign(h_move), y, Obj_Solido)) {
        x += sign(h_move);
    }
    h_move = 0; // Stop moving because we hit the wall
}
x += h_move; // Apply the final safe movement

// 3. Vertical Movement & Collision
if (place_meeting(x, y + v_velocidad, Obj_Solido)) {
    // If we are about to hit the floor/ceiling
    while (!place_meeting(x, y + sign(v_velocidad), Obj_Solido)) {
        y += sign(v_velocidad);
    }
    v_velocidad = 0; // Stop falling/rising
}
y += v_velocidad; // Apply the final safe movement*

if (invencible == true) {
    image_alpha = 0.5; // Make player semi-transparent
} else {
    image_alpha = 1;   // Normal
}