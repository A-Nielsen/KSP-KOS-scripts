function cal_col {
    SET parts TO 0.
    SET vec_col TO V(0,0,0).
    FOR p IN SHIP:PARTS {
        IF p:HASMODULE("ModuleLiftingSurface") {
            SET PARTS TO PARTS + 1.
            // Attempt to get lift coefficient from the module
            SET WING TO SHIP:FACING:INVERSE * (p:POSITION - SHIP:POSITION).
            SET vec_col TO vec_col + WING.
        }
    }
    SET vec_col TO vec_col/parts.

    return vec_col.
}.

DECLARE trimmer TO SHIP:PARTSDUBBED("trimmer")[0]:GETMODULE("ModuleRoboticServoHinge").
trimmer:SETFIELD("Target Angle", 0).

function cal_diff {
    SET vec_col TO cal_col().
    SET vec_com TO V(0,0,0).
    return vec_com - vec_col.
}

set start_diff to cal_diff().

UNTIL false {
    SET raw_diff TO cal_diff() - start_diff.
    SET local_diff TO raw_diff * SHIP:FACING:INVERSE.
    print(local_diff:z).
    SET angle TO (150+abs((local_diff:Z*18))).
    IF angle > 180{
        SET angle TO 180.
    }
    trimmer:SETFIELD("Target Angle", angle).
    print(angle).
    wait 0.1.
}
