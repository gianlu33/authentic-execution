#include <sancus/reactive.h>

#include <stdio.h>

SM_OUTPUT(button_driver, button_pressed);

SM_INPUT(button_driver, trigger_button_press, data, len) {
  puts("[button_driver] Button has been pressed, sending output");
  button_pressed(NULL, 0);
}
