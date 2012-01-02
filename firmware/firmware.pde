#include <CapSense.h>


#include "notes.h"

#define SPEAKER_PIN 0
#define LIGHT_PIN 1
#define CAP_SENSOR_SEND_PIN 2
#define CAP_SENSOR_RECEIVE_PIN 4

int threshold = 200;
int pressCount = 0;

int coin_sound_num_notes = 2;
int coin_sound_notes[] = {NOTE_D6, NOTE_G6};
int coin_sound_note_durations[] = {16, 2};

int oneup_sound_num_notes = 6;
int oneup_sound_notes[] = {NOTE_E6, NOTE_G6, NOTE_E7, NOTE_C7, NOTE_D7, NOTE_G7};
int oneup_sound_note_durations[] = {8, 8, 8, 8, 8, 8};

CapSense   cs_4_2 = CapSense(CAP_SENSOR_SEND_PIN, CAP_SENSOR_RECEIVE_PIN);

void setTouchThreshold() {
  for (int i = 0; i < 10; i++) {
    int thisRead = cs_4_2.capSense(30);
//    Serial.print("candidate:");
//    Serial.println(thisRead);
    if (thisRead > threshold) {
      threshold = thisRead;
    }
    delay(100);
  }
//  Serial.print(" thresh: ");
//  Serial.println(threshold);
}

void setup() {
//  Serial.begin(9600);
  pinMode(LIGHT_PIN, OUTPUT);
  digitalWrite(LIGHT_PIN, HIGH);
  delay(1000);
  
//      // always play the "coin" sound
//    playSound(SPEAKER_PIN, coin_sound_num_notes, coin_sound_notes, coin_sound_note_durations);
////    
//    // if this is the 8th touch, then play the "one up" sound
//      playSound(SPEAKER_PIN, oneup_sound_num_notes, oneup_sound_notes, oneup_sound_note_durations);
  
  digitalWrite(LIGHT_PIN, LOW);
}

void playSound(int speaker_pin, int num_notes, int notes[], int durations[]) {
  // iterate over the notes of the melody:
  for (int thisNote = 0; thisNote < num_notes; thisNote++) {
    // to calculate the note duration, take one second 
    // divided by the note type.
    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
    int noteDuration = 1000/durations[thisNote];
    tone(speaker_pin, notes[thisNote], noteDuration);

    // to distinguish the notes, set a minimum time between them.
    // the note's duration + 30% seems to work well:
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
    // stop the tone playing:
    noTone(speaker_pin);
  }
}

//boolean checkSensor() {
//  // to call it a touch, we're looking for a drop at least 10% below the threshold for 100ms
//  for (int i = 0; i < 10; i++) {
//    if (analogRead(CAP_SENSOR_PIN) >= threshold * 0.9) {
//      // if the sensor value is above the threshold, then we're not meeting the press criteria. exit.
//      return false;
//    }
//    delay(10);
//  }
//  // if we've made it here, then we had the touch condition we were looking for!
//  return true;
//}

//boolean checkSensor() {
//  // to call it a touch, we're looking for a drop at least 10% below the threshold for 100ms
//  for (int i = 0; i < 10; i++) {
//    if (cs_4_2.capSense(30) < threshold * 1.1) {
//      // if the sensor value is above the threshold, then we're not meeting the press criteria. exit.
//      return false;
//    }
//    delay(10);
//  }
//  // if we've made it here, then we had the touch condition we were looking for!
//  return true;
//}

boolean checkSensor() {
  int readValue = cs_4_2.capSense(30);
  if (readValue == -2) {
    for (int i = 0; i < 2; i++) {
      digitalWrite(LIGHT_PIN, HIGH);
      delay(500);
      digitalWrite(LIGHT_PIN, LOW);
      delay(500);
    }
  }
//  Serial.println(readValue);
  return  readValue > threshold;
}

void loop() {
  if (threshold < 1) {
    setTouchThreshold();
  }
//  Serial.println(cs_4_2.capSense(30));

  if (checkSensor()) {
    // the sensor was touched! increment the press count
    pressCount++;
    
    // toggle the light state
    if (pressCount % 2 == 0) {
      digitalWrite(LIGHT_PIN, LOW);
    } else {
      digitalWrite(LIGHT_PIN, HIGH);
    }
    
    // always play the "coin" sound
    playSound(SPEAKER_PIN, coin_sound_num_notes, coin_sound_notes, coin_sound_note_durations);
    
    // if this is the 8th touch, then play the "one up" sound
    if (pressCount % 8 == 0) {
      playSound(SPEAKER_PIN, oneup_sound_num_notes, oneup_sound_notes, oneup_sound_note_durations);
    }
    
    // to "de-bounce" the touch, don't loop around again until the sensor check returns false
    while (checkSensor()) {}
  }
  delay(25);
}
