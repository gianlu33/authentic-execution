//@ sm_output(toggle_led)
//@ sm_output(increment_presses)

//@sm_input
pub fn button_pressed(_data : &[u8]) {
    info!("Remote button has been pressed");

    // toggle LED
    toggle_led(&[]);

    // increment occurrences on db
    increment_presses(&[]);
}
