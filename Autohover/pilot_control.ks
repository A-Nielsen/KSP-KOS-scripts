RUN ONCE "utils.ks".


function pilot_altitude {
    parameter in_tgt_height.
    if SHIP:CONTROL:pilottop > 0 {
        return in_tgt_height - 1.
    }
    if SHIP:CONTROL:pilottop < 0 {
        return in_tgt_height + 1.
    }
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
        return smooth(in_tgt_roll, -in_max_roll, in_pilot_alpha).
    }
    if SHIP:CONTROL:pilotroll < 0 {
        return smooth(in_tgt_roll, in_max_roll, in_pilot_alpha).
    }
}