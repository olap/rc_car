require 'rubygems'
require 'cwiid'

puts "Press 1+2 now"
wiimote = WiiMote.new
wiimote.rpt_mode = WiiMote::RPT_BTN | WiiMote::RPT_ACC

def check_button(btns, btn)
  btns[Math.log(btn,2).to_i] == 1
end

acc = wiimote.acc
exit = false
led = 1
led_out = 1 
state = wiimote.get_state
wiimote.rumble = false
wiimote.led = led
buttons = wiimote.buttons
pressed = Array.new

until exit
  sleep 0.05
  state = wiimote.get_state

  old_acc = acc
  acc = wiimote.acc
  #puts acc.inspect if acc != old_acc

  old_buttons = buttons
  buttons = wiimote.buttons
  #puts buttons.inspect if old_buttons != buttons

  led += 1
  led = led % 128
  led_old_out = led_out
  led_out = 2 ** ((led/32).floor)
  #puts [led, led_out, led_old_out].inspect
  wiimote.led = led_out if (led_out != led_old_out)

  old_pressed = pressed.dup
  pressed.clear
  [[WiiMote::BTN_PLUS, '+'],
   [WiiMote::BTN_MINUS, '-'],
   [WiiMote::BTN_HOME, 'home'],
   [WiiMote::BTN_1, '1'],
   [WiiMote::BTN_2, '2'],
   [WiiMote::BTN_UP, 'up'],
   [WiiMote::BTN_DOWN, 'down'],
   [WiiMote::BTN_LEFT, 'left'],
   [WiiMote::BTN_RIGHT, 'right'],
   [WiiMote::BTN_A, 'A'],
   [WiiMote::BTN_B, 'B']].each do |button_set|
     if check_button(buttons, button_set[0])
       pressed << button_set[1]
     end
  end
  #puts [pressed, old_pressed].inspect
  pressed << "none" if pressed.empty?
  puts "Button #{pressed.join(',')} pressed" if (old_pressed != pressed)

  exit = true if pressed == ['home'] 
end
