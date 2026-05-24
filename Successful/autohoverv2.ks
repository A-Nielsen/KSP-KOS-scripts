set current_heading to 0.
LOCK east TO VCRS(up:vector, north:vector):direction.

global forward_vec to v(0,0,0).
global forward_vec_hor to v(0,0,0).
global side_vec to v(0,0,0).
global target_heading_delta to 0.
global pitch to 0.
global yaw to 0.
lock max_speed to 45.
lock max_pitch to 25.
lock max_yaw to 25.
lock speed to ship:groundspeed.

global auto_center_alpha to 0.9.
global pilot_alpha to 1.
global hover_alpha to 0.8.
global tgt_hdng to 90.
global tgt_pitch to 0.
global tgt_yaw to 0.
global tgt_height to SHIP:altitude.
//lock tgt_point to r(up:pitch + tgt_pitch, up:yaw + tgt_yaw, up:roll + tgt_hdng).

// Previous loop values
global prev_forward_vec_hor to forward_vec_hor.
global prev_time to time:seconds.
global rotation_speed to 0.

GLOBAL thrott TO 0.
LOCK THROTTLE TO thrott.


// PID's
// Heading
local Kp to 0.01.
local Ki to 0.05.
local Kd to 0.01.
global pi_roll to PIDLOOP(Kp, Ki, Kd, -1, 1).
set pi_roll:setpoint to 0.

// Rotation speed
local Kp to 0.01.
local Ki to 0.05.
local Kd to 0.01.
global pi_rotation to PIDLOOP(Kp, Ki, Kd, -1, 1).
set pi_rotation:setpoint to 0.

// Hover
local Kp to 0.3.
local Ki to 0.01.
local Kd to 0.3.
global pi_hover to PIDLOOP(Kp, Ki, Kd, 0, 1).
set pi_hover:SETPOINT to tgt_height.

// pitch
local Kp to 0.3.
local Ki to 0.01.
local Kd to 0.3.
global pi_pitch to PIDLOOP(Kp, Ki, Kd, -1, 1).
set pi_pitch:SETPOINT to tgt_pitch.

// yaw
local Kp to 0.02.
local Ki to 0.
local Kd to 0.03.
global pi_yaw to PIDLOOP(Kp, Ki, Kd, -1, 1).
set pi_yaw:SETPOINT to tgt_yaw.


// Utility
function smooth {
    parameter in_current, in_target, in_alpha.
    local smoothed_output to in_current + in_alpha * (in_target - in_current).
    if abs(smoothed_output) < 0.01 
    {
        set smoothed_output to 0.
    }
    return smoothed_output.
}


// Heading and rotation systems
function calc_heading{
    local north_angle is vAng(north:vector, forward_vec_hor).
    local east_angle is vang(east:vector, forward_vec_hor).
    log north to "debug/north.txt".
    log east to "debug/east.txt".

    if north_angle >= 0 and east_angle <= 90{
        set current_heading to north_angle.
    }
    else{
        set current_heading to 360-north_angle.
    }
}


function calc_forward_vectors {
    set forward_vec to ship:facing:topvector.
    set forward_vec_hor to vxcl(up:vector, forward_vec).
}


function calc_side_vector {
  set side_vec to VCRS(UP:VECTOR,forward_vec):NORMALIZED.
}


function calc_rotation_speed {
    set time_delta to (time:second - prev_time).
    set second_fraction to time_delta/1.
    set cross to vdot(up:vector, vcrs(prev_forward_vec_hor, forward_vec_hor)).
    if cross > 0 {
        set sign to -1.
    } else {
        set sign to 1.
    }

    set rotation_speed to (arcCos(vdot(prev_forward_vec_hor:normalized, forward_vec_hor:normalized)) / (time_delta)) * second_fraction*sign.
}


function calc_heading_delta {
    local heading_delta to mod((tgt_hdng - current_heading + 540), 360) -180.
    set target_heading_delta to heading_delta.
}


function heading_and_rotation_guidance {
    set counter_rotate to pi_rotation:update(time:seconds, rotation_speed).
    set rotate_to_heading to pi_roll:update(time:seconds, target_heading_delta).

    clearScreen.
    print(pi_roll) at (0,3).
    print(target_heading_delta) at (0,7).
    print(rotate_to_heading) at (0,8).
    if abs(rotation_speed) > 5 {
        SET SHIP:CONTROL:roll to counter_rotate.
        print("roll") at (0,9).
    } else {
        SET SHIP:CONTROL:roll to rotate_to_heading*5.
        print("heading") at (0,9).
    }
}


// Hover/thrust systems
function hover_guidance {
    SET thrott TO smooth(thrott, pi_hover:UPDATE(TIME:SECONDS, SHIP:altitude), hover_alpha).
}


// Pitch systems
function calc_pitch {
    set pitch to arcCos(vdot(forward_vec, up:vector))-90.
}


function pitch_guidance {
    set ship:control:pitch to pi_pitch:update(time:seconds, pitch).
}


// Yaw systems
function calc_yaw {
    set yaw to arcCos(vdot(ship:facing:starvector, up:vector))-90.
}


function yaw_guidance {
    set ship:control:yaw to pi_yaw:update(time:seconds, yaw).
}


function auto_center {
    set tgt_pitch to smooth(tgt_pitch, 0, auto_center_alpha).
    set tgt_yaw to smooth(tgt_yaw, 0, auto_center_alpha).
}


// Speed management systems
function calc_counter_force {
}



// pilot control
function pilot_control {
    // Hover
    if SHIP:CONTROL:pilottop > 0 {
        set tgt_height to tgt_height - 1.
    }
    if SHIP:CONTROL:pilottop < 0 {
        set tgt_height to tgt_height + 1.
    }
    set pi_hover:setpoint to tgt_height.

    // Pitch
    if SHIP:CONTROL:pilotpitch > 0 {
        set tgt_pitch to smooth(tgt_pitch, -max_pitch, pilot_alpha).
    }
    if SHIP:CONTROL:pilotpitch < 0 {
        set tgt_pitch to smooth(tgt_pitch, max_pitch, pilot_alpha).
    }
    set pi_pitch:setpoint to tgt_pitch.

    // Yaw
    if SHIP:CONTROL:pilotyaw > 0 {
        set tgt_yaw to smooth(tgt_yaw, -max_yaw, pilot_alpha).
    }
    if SHIP:CONTROL:pilotyaw < 0 {
        set tgt_yaw to smooth(tgt_yaw, max_yaw, pilot_alpha).
    }
    set pi_yaw:setpoint to tgt_yaw.

    // Heading
    if SHIP:CONTROL:pilotroll > 0 {
        set tgt_hdng to tgt_hdng + 1.
    }
    if SHIP:CONTROL:pilotroll < 0 {
        set tgt_hdng to tgt_hdng - 1.
    }
    if tgt_hdng > 360{
        set tgt_hdng to 0.
    }
    if tgt_hdng < 0 {
        set tgt_hdng to 359.9.
    }
}


// Run
function update_guidance_values{
    calc_forward_vectors().
    calc_side_vector().
    calc_heading().
    calc_rotation_speed().
    calc_heading_delta().
    calc_pitch().
    calc_yaw().
    calc_counter_force().

    set prev_forward_vec_hor to forward_vec_hor.
    set prev_time to time:seconds.
}

function run_guidance_systems {
    heading_and_rotation_guidance().
    hover_guidance().
    pitch_guidance().
    yaw_guidance().
    auto_center().
}

function debug {
    clearScreen.
    print("height: " + tgt_height) at (0,0).
    print("pitch: " + tgt_pitch) at (0,1).
    print("heading: " + tgt_hdng) at (0,2).

    print("pilot inputs:") at (0,4).
    print("height: " + SHIP:CONTROL:pilottop) at (0,5).
    print("pitch: " + SHIP:CONTROL:pilotpitch) at (0,6).
    print("heading: " + SHIP:CONTROL:roll) at (0,7).

    print("heading delta: " + target_heading_delta) at (0,9).

    set fore_vec_ren  to vecdraw(V(0,0 ,0), forward_vec, blue, "fore_vector", 2, true).
}

function start {
    clearScreen.
    set debug_value to false.
    until false {
        update_guidance_values().  
        run_guidance_systems().
        pilot_control().

        if debug_value {
            debug().
        }

        wait 0.01.
    }
}

start().

