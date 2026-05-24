function smooth {
    parameter in_current, in_target, in_alpha.
    local smoothed_output to in_current + in_alpha * (in_target - in_current).
    if abs(smoothed_output) < 0.01 
    {
        set smoothed_output to 0.
    }
    return smoothed_output.
}
