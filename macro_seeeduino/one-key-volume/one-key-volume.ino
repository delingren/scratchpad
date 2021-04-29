#include "HID-Project.h"
#include <Encoder.h>

byte rowPins[] = {8};
byte colPins[] = {10};

const int rowCount = sizeof(rowPins) / sizeof(rowPins[0]);
const int colCount = sizeof(colPins) / sizeof(colPins[0]);

byte statusMatrix[rowCount][colCount];

KeyboardKeycode keyKeycodes[rowCount][colCount] = {
  {KEY_MUTE},
};

Encoder encoder(5, 3);
KeyboardKeycode encoderKeycodes[] = {KEY_VOLUME_UP, KEY_VOLUME_DOWN};
long encoderSensitivity = 2;

void setup() {
  //  Serial.begin(9600);

  // Use pin 4 as a GND for the encoder
  pinMode(4, OUTPUT);
  digitalWrite(4, LOW);

  for (int x = 0; x < colCount; x++) {
    pinMode(colPins[x], INPUT);
  }

  for (int x = 0; x < colCount; x++) {
    pinMode(rowPins[x], INPUT_PULLUP);
  }

  for (int c = 0; c < colCount; c ++) {
    for (int r = 0; r < rowCount; r ++) {
      statusMatrix[r][c] = HIGH;
    }
  }

  Keyboard.begin();
}

void readMatrix() {
  static unsigned long timeLastScan = 0;

  unsigned long timeNow = millis();
  if (timeNow - timeLastScan < 200) {
    // This is a one-key pad. The only key is mute. 200ms is plenty generous.
    return;
  }

  for (int r = 0; r < rowCount; r++) {
    byte rowPin = rowPins[r];
    pinMode(rowPin, OUTPUT);
    digitalWrite(rowPin, LOW);

    for (int c = 0; c < colCount; c++) {
      byte colPin = colPins[c];
      pinMode(colPin, INPUT_PULLUP);
      byte status = digitalRead(colPin);
      pinMode(colPin, INPUT);

      if (status != statusMatrix[r][c]) {
        // the key has been either pressed or released since last scan
        KeyboardKeycode kc = keyKeycodes[r][c];
        if (status == LOW) {
          Serial.println("Key down");
          Keyboard.press(kc);
        }
        else
        {
          Serial.println("Key up");
          Keyboard.release(kc);
        }
      }
      statusMatrix[r][c] = status;
    }

    pinMode(rowPin, INPUT_PULLUP);
  }
}

void readEncoder() {
  static long lastPosition = encoder.read();
  static unsigned long timeLastRead = 0;

  unsigned long timeNow = millis();
  if (timeNow - timeLastRead < 80) {
    return;
  }

  long newPosition = encoder.read();
  //  if (newPosition != lastPosition) {
  //    Serial.println(newPosition);
  //  }

  if (newPosition - lastPosition >= encoderSensitivity) {
    //    Serial.println("Encoder +");
    Keyboard.write(encoderKeycodes[0]);
  } else if (newPosition - lastPosition <= - encoderSensitivity) {
    Keyboard.write(encoderKeycodes[1]);
    //    Serial.println("Encoder -");
  }
  lastPosition = newPosition;
  timeLastRead = timeNow;
}

void loop() {
  readMatrix();
  readEncoder();
}
