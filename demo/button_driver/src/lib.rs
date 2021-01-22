//@ sm_output(button_pressed)

//@sm_input
pub fn trigger_button_press(_data : &[u8]) {
    info!("Button has been pressed, sending output");

    button_pressed(&[]);
}
