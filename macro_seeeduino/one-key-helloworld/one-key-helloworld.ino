/*
  Keyboard Message test

  For the Arduino Leonardo and Micro.

  Sends a text string when a button is pressed.

  The circuit:
  - pushbutton attached from pin 4 to +5V
  - 10 kilohm resistor attached from pin 4 to ground

  created 24 Oct 2011
  modified 27 Mar 2012
  by Tom Igoe
  modified 11 Nov 2013
  by Scott Fitzgerald

  This example code is in the public domain.

  http://www.arduino.cc/en/Tutorial/KeyboardMessage
*/

#include "Keyboard.h"

const int buttonPin = 8;          // input pin for pushbutton
int previousButtonState = HIGH;   // for checking the state of a pushButton

unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers

void setup() {
  // make the pushButton pin an input:
  pinMode(buttonPin, INPUT_PULLUP);
  // initialize control over the keyboard:
  Keyboard.begin();
}

void loop() {
  // read the pushbutton:
  int buttonState = digitalRead(buttonPin);
  unsigned long time = millis();

  if (buttonState != previousButtonState) {
    Serial.println(buttonState);
    Serial.println(lastDebounceTime);

    if (time - lastDebounceTime > debounceDelay) {
      if (buttonState == HIGH) {
        Keyboard.println("hello world!!!");
      }
    }

    previousButtonState = buttonState;
    lastDebounceTime = time;

  }
}
