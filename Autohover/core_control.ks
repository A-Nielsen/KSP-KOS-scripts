RUN ONCE "utils.ks".

GLOBAL thrott TO 0.
LOCK THROTTLE TO thrott.


// Control limits
lock max_speed to 45.
lock max_pitch to 25.
lock max_yaw to 25.
lock max_roll to 10.    


// Control "strength"
lock auto_center_alpha to 0.9.
lock hover_alpha to 0.8.
lock pilot_alpha to 1.


// Control target
global tgt_roll to 0.
global tgt_pitch to 0.
global tgt_yaw to 0.
global tgt_height to SHIP:altitude.


// PID's
// Heading
global pi_roll to PIDLOOP(0.3, 0.01, 0.2, -1, 1).
set pi_roll:setpoint to tgt_roll.

// Hover
global pi_hover to PIDLOOP(0.3, 0.01, 0.3, 0, 1).
set pi_hover:SETPOINT to tgt_height.

// pitch
global pi_pitch to PIDLOOP(0.3, 0.01, 0.3, -1, 1).
set pi_pitch:SETPOINT to tgt_pitch.

// yaw
global pi_yaw to PIDLOOP(0.02, 0, 0.03, -1, 1).
set pi_yaw:SETPOINT to tgt_yaw.


function auto_center {
    set tgt_pitch to smooth(tgt_pitch, 0, auto_center_alpha).
    set tgt_yaw to smooth(tgt_yaw, 0, auto_center_alpha).
    set tgt_roll to smooth(tgt_roll, 0, auto_center_alpha).
}


function roll_guidance {
    set ship:control:roll to pi_roll:update(time:seconds, roll_speed).
}


function hover_guidance {
    SET thrott TO smooth(
        thrott,
        pi_hover:UPDATE(TIME:SECONDS, SHIP:altitude),
        hover_alpha
    ).
}


function pitch_guidance {
    set ship:control:pitch to pi_pitch:update(time:seconds, pitch).
}


function yaw_guidance {
    set ship:control:yaw to pi_yaw:update(time:seconds, yaw).
}


function dampen_velocity {
    // Calculate the magnitude of front and side
        // Based on the direction
}


function update_pids {
    set pi_roll:setpoint to tgt_roll.
    set pi_hover:setpoint to tgt_height.
    set pi_pitch:setpoint to tgt_pitch.
    set pi_yaw:setpoint to tgt_yaw.
}


function run_core_control {
    update_pids().
    hover_guidance().
    roll_guidance().
    pitch_guidance().
    yaw_guidance().
    auto_center().
   }