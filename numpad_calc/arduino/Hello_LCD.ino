#include <stdlib.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Adafruit_Keypad.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // set the LCD address to 0x27 for a 16 chars and 2 line display

const byte ROWS = 4;
const byte COLS = 4;

char keys[ROWS][COLS] = {
  {'1', '2', '3', '+'},
  {'4', '5', '6', '/'},
  {'7', '8', '9', '#'},
  {'.', '0', '#', '='}
};
byte rowPins[ROWS] = {13, 12, 11, 10};
byte colPins[COLS] = {5, 4, 3, 2};

Adafruit_Keypad customKeypad = Adafruit_Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS);

#define NUM_DIGITS 8
// these 3 variables tracks the current status of the number being entered
uint8_t input[NUM_DIGITS]; // array storing the digits
uint8_t digits; // number of entered digits in the input array
uint8_t decimalPlace; // position of the decimal point, 0 if none

// the result of the last operation; initially 0.
double lastResult;

// these two variables record the last operator and the operand following it
// if a '=' is tapped before an operand is entered, we repeat the last operation
// with the last operand.
// E.g. 1 '+' (store lastOperator) 2 '=' (store lastOperand) '=' -> 5
// if the last input is an operator, however, we will use the last result as the operand, and update lastOperand
// E.g.
// 1 '+' 2 '+' (lastOperator <- '+', clear lastOperand) '=' (lastOperand <- lastResult) -> 6
// 1 '+' 2 '+' '=' (lastOperand: 3) '=' (lastOperator: +, lastOperand: 3) -> 9
double lastOperand;
byte lastOperator;

// restore the initial state
void clear() {
  input[0] = 0;
  digits = 0;
  decimalPlace = 0;

  lastResult = 0;
  lastOperand = NAN;
  lastOperator = 0;

  displayResult();
}

double executeOperation(double operand1, byte op, double operand2) {
  switch (op) {
    case '+':
      return operand1 + operand2;
    case '-':
      return operand1 - operand2;
    case '*':
      return operand1 * operand2;
    case '/':
      return operand1 / operand2;
    default:
      return NAN;
  }
}

void displayInput() {
  char display[NUM_DIGITS + 1]; // extra character for decimal point
  int j = 0;
  for (int i = 0; i < digits; i++) {
    display[j++] = input[i] + '0';
    if (decimalPlace != 0 && i == decimalPlace - 1) {
      display[j++] = '.';
    }
  }
  display[j] = 0;

  lcd.clear();
  lcd.print(display);
}

void displayResult() {
  char buffer[NUM_DIGITS * 2];

  // TODO: try to trim down to NUM_DIGITS
  // TODO: if the integer part exceeds NUM_DIGITS, display error
  
  // Arduino does not implement %f. I hope gcc-avr does though
  // otherwise, I need to implement my own
  // sprintf(buffer, "%.*G", NUM_DIGITS, lastResult);

  dtostrf(lastResult, 0, NUM_DIGITS, buffer);
  Serial.println(buffer);

  lcd.clear();
  lcd.print(buffer);  
}

// called when a key is tapped
void keyTapped(byte key) {
  if (key == '#') {
    clear();
    return;
  }

  if (key == '.') {
    if (digits == 0) {
      input[0] = 0;
      digits = 1;
      decimalPlace = 1;
    } else if (decimalPlace == 0) {
      decimalPlace = digits;
    }
    displayInput();
    return;
  }

  if (isdigit(key)) {
    if (digits < NUM_DIGITS) {
      input[digits++] = key - '0';
      displayInput();
    }
    return;
  }

  // +, -, *, /, =
  if (digits == 0) {
    if (key != '=') {
      // no operand has been entered. update the last operator.
      lastOperator = key;
      return;
    } else {
      // '=' is tapped, but no operand has been entered.
      if (isnan(lastOperand)) {
        // use the last result as the operand.
        lastOperand = lastResult;
      }
      // repeat last operation
      if (lastOperator != 0) {
        lastResult = executeOperation(lastResult, lastOperator, lastOperand);
        displayResult();
      }
      return;
    }
  }

  // convert current operand to a double number
  double operand = 0;
  double fraction = 1;
  for (int i = 0; i < digits; i++) {
    if (decimalPlace > 0 && i >= decimalPlace) {
      fraction = fraction / 10;
      operand += input[i] * fraction;
    } else {
      operand = operand * 10 + input[i];
    }
  }

  if (lastOperator == 0) {
    // this is the first operator
    lastResult = operand;
  } else {
    // carry out the last operation, using the previous result as the first operand, the current input as the second operand
    lastResult = executeOperation(lastResult, lastOperator, operand);
    displayResult();
  }

  // get ready to accept next operand
  digits = 0;
  decimalPlace = 0;

  // if the key tapped is '=', save the last operand
  // otherwise, clear the last operand and update the last operator
  lastOperand = key == '=' ? operand : NAN;
  lastOperator = key == '=' ? lastOperator : key;
}

void setup()
{
  Serial.begin(9600);

  lcd.init();                      // initialize the lcd
  // Print a message to the LCD.
  lcd.backlight();
  lcd.clear();

  customKeypad.begin();
  clear();
}

void loop()
{
  customKeypad.tick();

  while (customKeypad.available()) {
    keypadEvent e = customKeypad.read();
    if (e.bit.EVENT == KEY_JUST_RELEASED) {
      Serial.write(e.bit.KEY);
      Serial.println();
      keyTapped(e.bit.KEY);
    }
  }

  delay(10);
}
