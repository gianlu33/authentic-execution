use std::sync::Mutex;

lazy_static! {
    static ref BUTTON_PRESSES: Mutex<u32> = {
        Mutex::new(0) // initially zero
    };
}

//@sm_input
pub fn increment_presses(_data : &[u8]) {
    let mut occ = BUTTON_PRESSES.lock().unwrap();
    *occ += 1;
}

//@ sm_handler
pub fn get_presses(_data : &[u8]) -> Vec<u8> {
    info!("Retrieving number of button presses");
    let occ = BUTTON_PRESSES.lock().unwrap();
    (*occ).to_be_bytes().to_vec()
}
