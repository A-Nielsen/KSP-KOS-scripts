RUN ONCE "utils.ks".
RUN ONCE "pilot_control.ks".

// Orientation vectors
global forward_vec to v(0,0,0).
global forward_vec_hor to v(0,0,0).
global side_vec to v(0,0,0).

// Orientation values
global pitch to 0.
global yaw to 0.
global roll_speed to 0.

// Orientation limits
lock max_pitch to 25.
lock max_yaw to 25.
lock max_roll to 10.    

// Smoothing/control alphas
global auto_center_alpha to 0.9.
global pilot_alpha to 1.
global hover_alpha to 0.8.

// Target orentiation values
global tgt_roll to 0.
global tgt_pitch to 0.
global tgt_yaw to 0.
global tgt_height to SHIP:altitude.

// Time-dimensional values
global prev_forward_vec_hor to forward_vec_hor.
global prev_time to time:seconds.

// Throttle control override
GLOBAL thrott TO 0.
LOCK THROTTLE TO thrott.






RUN ONCE "autohover.ks".