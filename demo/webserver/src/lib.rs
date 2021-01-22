use std::thread;
use std::sync::Mutex;
use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write};

lazy_static! {
    static ref INIT: Mutex<bool> = {
        Mutex::new(false)
    };
}

//@ sm_request(get_presses)

//@ sm_input
pub fn init(data : &[u8]) {
    let mut is_init = INIT.lock().unwrap();

    if *is_init {
        error!("init input was already called");
        return;
    }

    if data.len() != 2 {
        error!("wrong data received (expecting 2 bytes for port)");
        return;
    }

    let port = authentic_execution::data_to_u16(data);
    let host = format!("0.0.0.0:{}", port);

    let listener = match TcpListener::bind(host) {
        Ok(l)   => l,
        Err(e)  => {
            error!(&format!("Fatal error: {}", e));
            return;
        }
    };

    info!(&format!("Web server listening on 0.0.0.0:{}", port));
    thread::spawn(move || { start_server(listener) });
    *is_init = true;
}

fn start_server(listener : TcpListener) {
    for stream in listener.incoming() {
        if let Ok(s) = stream {
            if let Err(_) = handle_client(s) {
                warning!("Network error while serving client");
            }
        }
    }
}

fn handle_client(mut stream: TcpStream) -> Result<(), std::io::Error> {
    // just assume the request is a HTTP GET
    let mut buffer = [0; 1024];
    stream.read(&mut buffer)?;

    let response = match get_presses(&[]) {
        Ok(r) if r.len() == 4   => {
            let num_presses = authentic_execution::data_to_u32(&r);
            format!("HTTP/1.1 200 OK\r\n\r\n{}\n", num_presses)
        },
        _                       => {
            "HTTP/1.1 500 Internal Server Error\r\n\r\n".to_string()
        }
    };

    stream.write(response.as_bytes())?;
    stream.flush()?;

    Ok(())
}
