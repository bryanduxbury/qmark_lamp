#include <CapSense.h>

#include "notes.h"

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))

// currently spec'd for attiny84
#define SPEAKER_PIN 9
#define LIGHT_PIN 10
#define CAP_SENSOR_SEND_PIN 3
#define CAP_SENSOR_RECEIVE_PIN 2

//int threshold = 500;
//unsigned int pressCount = 0;
//
//int coin_sound_num_notes = 2;
//int coin_sound_notes[] = {NOTE_D6, NOTE_G6};
//int coin_sound_note_durations[] = {16, 2};
//
//int oneup_sound_num_notes = 6;
//int oneup_sound_notes[] = {NOTE_E6, NOTE_G6, NOTE_E7, NOTE_C7, NOTE_D7, NOTE_G7};
//int oneup_sound_note_durations[] = {8, 8, 8, 8, 8, 8};
//
//CapSense cs_4_2 = CapSense(CAP_SENSOR_SEND_PIN, CAP_SENSOR_RECEIVE_PIN);

// table of 256 sine values / one sine period / stored in flash memory
PROGMEM  prog_uchar sine256[]  = {
  127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,238,239,240,
  242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,223,
  221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78,
  76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,
  33,35,37,39,42,44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124

};

double dfreq;
//const double refclk = 31250; // = 8MHz / 256
const double refclk = 15686.2745;  // = 8MHz / 510
//const double refclk=31376.6;      // measured

// variables used inside interrupt service declared as voilatile
volatile byte icnt;              // var inside interrupt
volatile byte icnt1;             // var inside interrupt
volatile byte c4ms;              // counter incremented all 4ms
volatile unsigned long phaccu;   // pahse accumulator
volatile unsigned long tword_m;  // dds tuning word m

ISR(TIM1_OVF_vect) {
  cbi(PORTA, 1);
  
  phaccu=phaccu+tword_m; // soft DDS, phase accu with 32 bits
  icnt=phaccu >> 24;     // use upper 8 bits for phase accu as frequency information
                         // read value fron ROM sine table and send to PWM DAC
  OCR1B=pgm_read_byte_near(sine256 + icnt)/1;    

  if(icnt1++ == 125) {  // increment variable c4ms all 4 milliseconds
    c4ms++;
    icnt1=0;
  }   
  
  sbi(PORTA, 1);
}

void Setup_timer1() {
  // Timer1 Clock Prescaler to / 1
  sbi(TCCR1B, CS10);
  cbi(TCCR1B, CS11);
  cbi(TCCR1B, CS12);

  // Timer1 PWM Mode set to 8-bit Phase Correct PWM
  sbi (TCCR1A, WGM10);
  cbi (TCCR1A, WGM11);
  cbi (TCCR1B, WGM12);
  cbi (TCCR1B, WGM13);

//  // Timer1 PWM Mode set to Phase Correct PWM with TOP = OCR1A
//  sbi (TCCR1A, WGM10);
//  sbi (TCCR1A, WGM11);
//  cbi (TCCR1B, WGM12);
//  sbi (TCCR1B, WGM13);
//  OCR1A = 128;

  // set OC1B to clear Compare Match
  cbi (TCCR1A, COM1B0);
  sbi (TCCR1A, COM1B1);
  
    // set OC1B to clear Compare Match
  cbi (TCCR1A, COM1A0);
  sbi (TCCR1A, COM1A1);
}

void setup() {
//  OCR1B = 64;
  Setup_timer1();
//
//  // disable interrupts to avoid timing distortion
//  cbi (TIMSK0,TOIE0);              // disable Timer0 !!! delay() is now not available
  sbi (TIMSK1,TOIE1);              // enable Timer1 Interrupt
//
  dfreq=NOTE_G6;                    // initial output frequency = 1000.o Hz
  tword_m=pow(2,32)*dfreq/refclk;  // calulate DDS new tuning word 
  
  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(2, OUTPUT);
  
  digitalWrite(9, HIGH);
  
//  pinMode(LIGHT_PIN, OUTPUT);
//  digitalWrite(LIGHT_PIN, HIGH);
//  delay(1000);  
//  digitalWrite(LIGHT_PIN, LOW);
}

//void playSound(int speaker_pin, int num_notes, int notes[], int durations[]) {
//  // iterate over the notes of the melody:
//  for (int thisNote = 0; thisNote < num_notes; thisNote++) {
//    // to calculate the note duration, take one second 
//    // divided by the note type.
//    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
//    int noteDuration = 1000/durations[thisNote];
//    tone(speaker_pin, notes[thisNote], noteDuration);
//
//    // to distinguish the notes, set a minimum time between them.
//    // the note's duration + 30% seems to work well:
//    int pauseBetweenNotes = noteDuration * 1.30;
//    delay(pauseBetweenNotes);
//    // stop the tone playing:
//    noTone(speaker_pin);
//  }
//}
//
//boolean checkSensor() {
////  if (digitalRead(10) == HIGH) {
////    return true;
////  }
////  return false;
//  int readValue = cs_4_2.capSense(30);
//  if (readValue == -2) {
//    for (int i = 0; i < 2; i++) {
//      digitalWrite(LIGHT_PIN, HIGH);
//      delay(500);
//      digitalWrite(LIGHT_PIN, LOW);
//      delay(500);
//    }
//  }
//  return readValue > threshold;
//}

void loop() {
  sbi(PORTA,0);
  cbi(PORTA,0);
//  digitalWrite(9, HIGH);
//  digitalWrite(9, LOW);
//  if (checkSensor()) {
//    // the sensor was touched! increment the press count
//    pressCount++;
//    
//    // toggle the light state
//    if (pressCount % 2 == 0) {
//      digitalWrite(LIGHT_PIN, LOW);
//    } else {
//      digitalWrite(LIGHT_PIN, HIGH);
//    }
//
//    // if this is the 8th touch, then play the "one up" sound
//    if (pressCount % 8 == 0) {
//      playSound(SPEAKER_PIN, oneup_sound_num_notes, oneup_sound_notes, oneup_sound_note_durations);
//    } else {
//      // always play the "coin" sound
//      playSound(SPEAKER_PIN, coin_sound_num_notes, coin_sound_notes, coin_sound_note_durations);
//    }  
////    delay(100);
//    // to "de-bounce" the touch, don't loop around again until the sensor check returns false
////    int state = LOW;
//    while (checkSensor()) {
////      if (state == HIGH) {
////        state = LOW;
////      } else {
////        state = HIGH;
////      }
////      digitalWrite(LIGHT_PIN, state);
//      delay(25);
//    }
//  }
//  delay(25);
}
