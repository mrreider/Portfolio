/*
 * music.c
 *
 *  Created on: Dec 7, 2020
 *      Author: Paul Bartlett
 */

#include "main.h"

Note_t Game_Sounds[] =
{

    //FIRE
    {NOTE_3,ONE_TWELFTH,true},  // Tone, Time, Delay
    {NOTE_4,ONE_HALF,true},
    {NOTE_0,ONE_HALF,true},

    //NO AMMO
    {NOTE_1,ONE_QUARTER,true},
    {NOTE_1,ONE_QUARTER,true},
    {NOTE_1,ONE_QUARTER,true},
    {NOTE_0,ONE_HALF,true},

    //RELOAD
    {NOTE_2,ONE_QUARTER,true},
    {NOTE_0,ONE_QUARTER,true},
    {NOTE_2,ONE_QUARTER,true},
    {NOTE_0,ONE_QUARTER,true},
    {NOTE_2,ONE_QUARTER,true},
    {NOTE_0,ONE_QUARTER,true},
    {NOTE_4,ONE_HALF,true},
    {NOTE_0,ONE_HALF,true},

};

//plays notes for the fire sound
void play_fire(){

    int i;
    for (i = 0; i < 2; i++)
    {
        music_play_note(i);
    }
}

//plays notes for no ammo sound
void play_no_ammo(){

    int i;
    for (i = 3; i < 6; i++)
    {
        music_play_note(i);
    }
}

//plays notes for reload sound
void play_reload(int start, int stop){

    int i;
    for (i = start; i < stop; i++)
    {
        music_play_note(i);
    }
}

void sound_init(){
    //Initialize TimerA with no period and duty cycle
    P2->DIR |= BIT7;
    //the TIMERA PWM controller will control the buzzer on the MKII
    P2->SEL0 |= BIT7;
    P2->SEL1 &= ~BIT7;
    //Turn off TA0
    TIMER_A0->CTL = 0;
    //Configure TA0.4 for Reset/Set Mode
    TIMER_A0->CCTL[4] = TIMER_A_CCTLN_OUTMOD_7;
    //Select the master clock as the timer source
    TIMER_A0->CTL = TIMER_A_CTL_SSEL__SMCLK;
}

//***************************************************************
// This function returns how long an individual  notes is played
//***************************************************************
uint32_t music_get_time_delay(measure_time_t time)
{
    uint32_t time_return = 0;

    time_return = MEASURE_DURATION * MEASURE_RATIO;

    switch (time)
    {
    case ONE_QUARTER:
    {
        time_return = time_return / 4;
        break;
    }
    case ONE_HALF:
    {
        time_return = time_return / 2;
        break;
    }
    case ONE_TWELFTH:
    {
        time_return = time_return / 12;
        break;
    }
    default:
    {
        break;
    }
    }

    return time_return - DELAY_AMOUNT;

}

void music_play_note(uint16_t note_index)
{
    //Set Duty cycle of TimerA to period
    TIMER_A0->CCR[4] = (Game_Sounds[note_index].period / 2) - 1;

    //Turn on Buzzer
    ece353_MKII_Buzzer_On(Game_Sounds[note_index].period);

    //Determine amount of time Timer32 needs to wait
    ece353_T32_1_wait_clk(music_get_time_delay(Game_Sounds[note_index].time));

    //Turn off buzzer
    TIMER_A0->CTL &= ~TIMER_A_CTL_MC_MASK;

    //Check if a delay is needed
    if (Game_Sounds[note_index].delay)
    {
        ece353_T32_1_wait_clk(DELAY_AMOUNT);
    }
}


