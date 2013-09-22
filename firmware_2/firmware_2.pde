#include <CapSense.h>

#include "notes.h"

// currently spec'd for attiny84
#define SPEAKER_PIN 9
#define LIGHT_PIN 10
#define CAP_SENSOR_SEND_PIN 3
#define CAP_SENSOR_RECEIVE_PIN 2

int threshold = 200;
unsigned int pressCount = 0;

int coin_sound_num_notes = 2;
int coin_sound_notes[] = {
  NOTE_D6, NOTE_G6};
int coin_sound_note_durations[] = {
  16, 2};

int oneup_sound_num_notes = 6;
int oneup_sound_notes[] = {
  NOTE_E6, NOTE_G6, NOTE_E7, NOTE_C7, NOTE_D7, NOTE_G7};
int oneup_sound_note_durations[] = {
  8, 8, 8, 8, 8, 8};

int startheme_sound_num_notes = 20;
int startheme_sound_notes[] = {
  NOTE_C7, NOTE_C7, NOTE_C7, NOTE_D6, NOTE_C7, NOTE_C7, NOTE_D6, NOTE_C7, NOTE_D6, NOTE_C7, 
  NOTE_B6, NOTE_B6, NOTE_B6, NOTE_C6, NOTE_B6, NOTE_B6, NOTE_C6, NOTE_B6, NOTE_C6, NOTE_B6};
int startheme_sound_note_durations[] = {
  6, 6, 6, 12,6,6,12,12,12,6,6,6, 6, 12,6,6,12,12,12,6};

CapSense cs_4_2 = CapSense(CAP_SENSOR_SEND_PIN, CAP_SENSOR_RECEIVE_PIN);

void setup() {
  digitalWrite(LIGHT_PIN, LOW);
  pinMode(LIGHT_PIN, OUTPUT);
  digitalWrite(SPEAKER_PIN, LOW);
  pinMode(SPEAKER_PIN, OUTPUT);
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

boolean checkSensor() {
  int readValue = cs_4_2.capSense(30);
  return readValue > threshold;
}

void loop() {
  if (checkSensor()) {
    // the sensor was touched! increment the press count
    pressCount++;

    // toggle the light state
    if (pressCount % 2 == 0) {
      digitalWrite(LIGHT_PIN, LOW);
    } else {
      digitalWrite(LIGHT_PIN, HIGH);
    }

    // if this is the 8th touch, then play the "one up" sound
    if (pressCount % 8 == 0) {
      if (pressCount % 56 == 0) {
        // star theme, plays twice, lights flash on and off
        for(int i=0;i<2;i++){
          for(int StarCounter = 0; StarCounter < startheme_sound_num_notes; StarCounter++){
            if (StarCounter % 2 == 0) {
              digitalWrite(LIGHT_PIN, LOW);
            } else {
              digitalWrite(LIGHT_PIN, HIGH);
            }
            playSound(SPEAKER_PIN, 1, &startheme_sound_notes[StarCounter], &startheme_sound_note_durations[StarCounter]);
          }
        }
        delay(1000/startheme_sound_note_durations[startheme_sound_num_notes-1] * 1.3);
        digitalWrite(LIGHT_PIN, LOW);
      } else {
        playSound(SPEAKER_PIN, oneup_sound_num_notes, oneup_sound_notes, oneup_sound_note_durations);
      }
    } else {
      // always play the "coin" sound
      playSound(SPEAKER_PIN, coin_sound_num_notes, coin_sound_notes, coin_sound_note_durations);
    }  
    while (checkSensor()) {
      delay(25);
    }
  }
}

