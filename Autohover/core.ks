

function calc_forward_vector {
  return ship:facing:topvector.
}

function calc_foward_hor_vector {
  parameter in_forward_vec.
  return vxcl(up:vector, in_forward_vec).
}
 
 
function compute_turn_direction {
  // Returns -1 or 1 depending on direction
    parameter in_prev_forward_vec_hor, in_forward_vec_hor.
    set cross to vdot(up:vector, vcrs(in_prev_forward_vec_hor, in_forward_vec_hor)).

    if cross > 0 {
        return -1.
    }
    return 1.
}


// Previously calc_roll_speed
function calculate_vector_delta {
    parameter in_prev_vec, in_cur_vec, in_prev_time, in_current_time.

    if in_prev_time = in_current_time {
      return 0.
    }
    if in_prev_vec = in_cur_vec {
      return 0.
    }

    // Normalize to seconds
    local time_delta to (in_prev_time - in_current_time).
    local second_fraction to time_delta/1.

    local turn_dir to compute_turn_direction(in_prev_vec, in_cur_vec).
    
    return (arcCos(vdot(in_prev_vec:normalized, in_cur_vec:normalized)) / (time_delta)) * second_fraction * turn_dir.
}