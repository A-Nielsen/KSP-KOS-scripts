RUN ONCE "core.ks".
RUN ONCE "pose.ks".
RUN ONCE "core_control.ks".
RUN ONCE "pilot_control.ks".


until false {
    update_pose().
    run_pilot_control().
    run_core_control().
}

