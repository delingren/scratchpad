byte rows[] = {10};
const int rowCount = sizeof(rows)/sizeof(rows[0]);

byte cols[] = {8, 9};
const int colCount = sizeof(cols)/sizeof(cols[0]);
 
byte statusMatrix[colCount][rowCount];
 
void setup() {
    Serial.begin(9600);
    Serial.println("Hi, I am Teensy");
 
    for(int x=0; x<rowCount; x++) {
        pinMode(rows[x], INPUT);
    }
 
    for (int x=0; x<colCount; x++) {
        pinMode(cols[x], INPUT_PULLUP);
    }
    
         
}

void readMatrix() {
    for (int c=0; c < colCount; c++) {
        // col: set to output to low
        byte colPin = cols[c];
        pinMode(colPin, OUTPUT);
        digitalWrite(colPin, LOW);
 
        for (int r=0; r< rowCount; r++) {
            byte rowPin = rows[r];
            pinMode(rowPin, INPUT_PULLUP);
            byte status = digitalRead(rowPin);
            pinMode(rowPin, INPUT);
            if (status != statusMatrix[c][r]) {
              Serial.print("Status changed. ");
              Serial.print("Column: ");
              Serial.print(c);
              Serial.print(" Row: ");
              Serial.print(r);
              Serial.print(" New status:");
              Serial.println(status);
            }
            statusMatrix[c][r] = status;
        }
        // disable the column
        pinMode(colPin, INPUT);
    }
}

void loop() {
  // put your main code here, to run repeatedly:
  readMatrix();
  Serial.println("Still alive!");
  delay(50);
}
