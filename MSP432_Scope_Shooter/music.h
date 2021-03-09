/*
 * music.h
 *
 *      Author: <Paul Bartlett>
 */

#ifndef MUSIC_H_
#define MUSIC_H_

#include <stdint.h>
#include <stdbool.h>
#include "msp.h"
#include "ece353.h"

//*****************************************************************************
// You will need to determine the number of SMCLKs it will
// take for the following notes and their associated frequencies.
//
// Assume that your MCU is running at 24MHz.
//*****************************************************************************
#define NOTE_1          30000
#define NOTE_2          28000
#define NOTE_3          20000
#define NOTE_4          15000
#define NOTE_5          10000
#define NOTE_0          0


//*****************************************************************************
// DO NOT MODIFY ANYTHING BELOW
//*****************************************************************************
#define MEASURE_DURATION 12000000    // 500 milliseconds
#define MEASURE_RATIO           2    // 2/4 time
#define DELAY_AMOUNT       240000    // 10  milliseconds
#define FIRE_NOTES 2
#define NO_AMMO_NOTES 3
#define RELOAD_NOTES 7

typedef enum measure_time_t {
    ONE_QUARTER,
    ONE_HALF,
    ONE_TWELFTH
} measure_time_t;

typedef struct{
    uint32_t period;
    measure_time_t time;
    bool delay;
}Note_t;

//***************************************************************
//***************************************************************
void sound_init(void);

void play_fire();
void play_no_ammo();
void play_reload();


#endif /* MUSIC_H_ */
