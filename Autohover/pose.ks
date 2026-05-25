global forward_vec to v(0,0,0).
global prev_forward_vec_hor to v(0,0,0).
global forward_vec_hor to v(0,0,0).
global prev_time to 0.
global cur_time to 0.
global roll_speed to 0.
global surf_speed to 0.


global pitch to 0.
global yaw to 0.
global roll_speed to 0.


function calc_pitch {
    set pitch to arcCos(vdot(forward_vec, up:vector))-90.
}


function calc_yaw {
    set yaw to arcCos(vdot(ship:facing:starvector, up:vector))-90.
}


function update_pose {
    clearscreen.
    set prev_time to cur_time.
    set cur_time to time:seconds.

    set prev_forward_vec_hor to forward_vec_hor.
    set forward_vec to calc_forward_vector().
    set forward_vec_hor to calc_foward_hor_vector(forward_vec).

    set roll_speed to calculate_vector_delta(
        prev_forward_vec_hor,
        forward_vec_hor,
        prev_time,
        cur_time
    ).

    set surf_speed to ship:groundspeed.

    calc_pitch().
    calc_yaw().
}

