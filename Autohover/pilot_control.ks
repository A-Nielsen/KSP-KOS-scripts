RUN ONCE "utils.ks".


function pilot_altitude {
    parameter in_tgt_height.
    if SHIP:CONTROL:pilottop > 0 {
        return in_tgt_height - 1.
    }
    if SHIP:CONTROL:pilottop < 0 {
        return in_tgt_height + 1.
    }
    return in_tgt_height.
}


function pilot_pitch {
    parameter in_tgt_pitch, in_max_pitch, in_pilot_alpha.
    if SHIP:CONTROL:pilotpitch > 0 {
        return smooth(in_tgt_pitch, -in_max_pitch, in_pilot_alpha).
    }
    if SHIP:CONTROL:pilotpitch < 0 {
        return smooth(in_tgt_pitch, in_max_pitch, in_pilot_alpha).
    }
}


function pilot_yaw {
    parameter in_tgt_yaw, in_max_yaw, in_pilot_alpha.
    if SHIP:CONTROL:pilotyaw > 0 {
        return smooth(in_tgt_yaw, -in_max_yaw, in_pilot_alpha).
    }
    if SHIP:CONTROL:pilotyaw < 0 {
        return smooth(in_tgt_yaw, in_max_yaw, in_pilot_alpha).
    }
}


function pilot_roll {
    parameter in_tgt_roll, in_max_roll, in_pilot_alpha.
    if SHIP:CONTROL:pilotroll > 0 {
        return smooth(in_tgt_roll, -max_roll, pilot_alpha).
    }
    if SHIP:CONTROL:pilotroll < 0 {
        return smooth(in_tgt_roll, in_max_roll, in_pilot_alpha).
    }
}


function run_pilot_control {
    set tgt_height to pilot_altitude(tgt_height).
    set tgt_pitch to pilot_pitch(tgt_pitch, max_pitch, pilot_alpha).
    set tgt_yaw to pilot_yaw(tgt_yaw, max_yaw, pilot_alpha).
    set tgt_roll to pilot_roll(tgt_roll, max_roll, pilot_alpha).
}