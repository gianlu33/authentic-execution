use std::sync::Mutex;

lazy_static! {
    static ref LED_STATE: Mutex<bool> = {
        Mutex::new(false) // initially OFF
    };
}

//@sm_input
pub fn toggle_led(_data : &[u8]) {
    // toggling led
    let mut led = LED_STATE.lock().unwrap();
    *led = !(*led);

    info!(&format!("New LED state: {}", *led));
}
