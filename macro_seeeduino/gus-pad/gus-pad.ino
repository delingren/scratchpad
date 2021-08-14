#include "HID-Project.h"
#include <Encoder.h>

byte rowPins[] = {5, 9, 8};
byte colPins[] = {4, 1, 0};

const int rowCount = sizeof(rowPins) / sizeof(rowPins[0]);
const int colCount = sizeof(colPins) / sizeof(colPins[0]);

byte statusMatrix[rowCount][colCount];

KeyboardKeycode keyKeycodes[rowCount][colCount] = {
  {KEY_MUTE, KEY_ESC, KEY_RESERVED},
  {KEY_F7, KEY_F8, KEY_F9},
  {KEY_F10, KEY_F11, KEY_F12},
};

Encoder encoder(2, 3);
KeyboardKeycode encoderKeycodes[] = {KEY_VOLUME_UP, KEY_VOLUME_DOWN};
long encoderSensitivity = 3;
long encoderPosition = 0;

void setup() {
  Serial.begin(9600);

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
  encoderPosition = encoder.read();
}

void readMatrix() {
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
  long newPosition = encoder.read();
  if (newPosition - encoderPosition >= encoderSensitivity) {
    Serial.println("Encoder +");
    Keyboard.write(encoderKeycodes[0]);
  } else if (newPosition - encoderPosition <= - encoderSensitivity) {
    Keyboard.write(encoderKeycodes[1]);
    Serial.println("Encoder -");
  }
  encoderPosition = newPosition;
}

void printMatrix() {
  for (int r = 0; r < rowCount; r ++) {
    for (int c = 0; c < colCount; c ++) {
      Serial.print(statusMatrix[r][c]);
    }
    Serial.println("");
  }
}

void loop() {
  readMatrix();
  readEncoder();
  // printMatrix();
  // Poor man's debouncing
  delay(100);
}
