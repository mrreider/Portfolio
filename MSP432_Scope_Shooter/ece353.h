/*
 * ece353.h
 *
 * Author: Reid Brostoff
 *
 */

#ifndef __ECE353_H__
#define __ECE353_H__

#include <stdbool.h>
#include <stdint.h>
#include "msp.h"

//Initialize hardware resources used to control LED1

void ece353_led_init1(void);

//Initialize hardware resources used to control Button1

void ece353_button1_init(void);

void ece353_T32_1_wait_clk(int clock_cycles);


//Turn LED ON/OFF. If true, turn LED ON

void ECE_353_led1(bool on);

//Returns if Button1 is currently pressed (true if pressed)

bool ECE_353_button1(void);

//****************************************************
//****************************************************
// 02-ICE-Code-Organization
//****************************************************
//****************************************************

/*****************************************************
 * Initialize hardware resources used to control RGBLED
 *****************************************************/
void ece353_rgb_init(void);

/*****************************************************
 * Turn RGBLED ON/Off.
 *
 * Parameters
 *  red_on      :   if true,  turn RGBLED.RED on
 *                  if false, turn RGBLED.RED off
 *  green_on    :   if true,  turn RGBLED.GREEN on
 *                  if false, turn RGBLED.GREEN off
 *  blue_on     :   if true,  turn RGBLED.BLUE on
 *                  if false, turn RGBLED.BLUE off
 *****************************************************/
void ece353_rgb(bool red_on, bool green_on, bool blue_on);

/*****************************************************
 * Initialize hardware resources used to control Button2
 *****************************************************/
void ece353_button2_init(void);

/*****************************************************
 * Returns if Button2 is currently pressed.
 *
 * Parameters
 *
 * Returns
 *      true    :   Button2 is pressed
 *      false   :   Button2 is NOT pressed
 *****************************************************/
bool ece353_button2(void);

//*****************************************************************************
//*****************************************************************************
// ICE 03 - Timer32_1 Push Button Detection
//*****************************************************************************
//*****************************************************************************

/*****************************************************
 * Busy waits for 100mS and then returns.
 *
 * Timer32_1 MUST be configured as a 16-bit timer.
 * Assume that the MCU clock runs at 3MHz.  You will
 * need to use a pre-scalar in order to achieve a delay
 * of 100mS.
 *
 * Parameters
 *      ticks   :   Number of ticks to wait
 * Returns
 *      None
 *****************************************************/
void ece353_T32_1_wait_10mS(void);


/*****************************************************
 * Debounces Button1 using Timer32_1.
 * This function does not return until Button 1 has
 * been pressed for a minimum of 5 seconds.
 *
 * Waiting 5 Seconds will require you to call
 * ece353_T32_1_wait_100mS multiple times.
 *
 * Parameters
 *      None
 * Returns
 *      None
 *****************************************************/
void ece353_button1_wait_for_press(void);

/*
 * Initialize hardware resources used to control S1 on the MKII
 */

void ece353_MKII_S1_Init(void);

/*
 * Initialize hardware resources used to control S2 on the MKII
 */

void ece353_MKII_S1_Init(void);

/*
 * Returns true if MKII.S1 is currently pressed
 */

bool ece353_MKII_S1(void);

/*
 * Returns true if MKII.S2 is currently pressed
 */

bool ece353_MKII_S2(void);

/*
 * Sets the PWM period of the Buzzer. Duty cycle will be set to 50%.
 */
void ece353_MKII_Buzzer_Init(uint16_t ticks_period);

/*
 * Turns the Buzzer on
 */

void ece353_MKII_Buzzer_On(int ticks_period);

/*
 * Turns the Buzzer off
 */

void ece353_MKII_Buzzer_Off(void);

/*
 * Checks buzzer run status, true if on.
 */

bool ece353_MKII_Buzzer_Run_Status(void);

//*****************************************************************************
//*****************************************************************************
// ICE 04 - PWMing MKII tri-color LED.
//*****************************************************************************
//*****************************************************************************

/*****************************************************
 * Initialize the 3 GPIO pins that control the RGB
 * LED on the MKII.
 *
 * Parameters
 *      en_primary_function  - If set to true, enable the primary function
 *
 * Returns
 *      None
 *****************************************************/
void ece353_MKII_RGB_IO_Init(bool en_primary_function);

/*****************************************************
 * Sets the PWM levels for the MKII RGBLED
 *
 * Parameters
 *      ticks_period    :   Period of PWM Pulse
 *      ticks_red_on    :   Number of Ticks RED is on
 *      ticks_green_on  :   Number of Ticks GREEN is on
 *      ticks_blue_on   :   Number of Ticks BLUE is on
 * Returns
 *      None
 *****************************************************/
void ece353_MKII_RGB_PWM(
        uint16_t ticks_period,
        uint16_t ticks_red_on,
        uint16_t ticks_green_on,
        uint16_t ticks_blue_on
);

//Configures Timer32_1 to generate a periodic interrupt
void ece353_T32_1_Interrupt_Ms(uint16_t ms);

void ece353_ADC14_PS2_X(void);

void ece353_MKII_RGB_LED(bool red, bool green, bool blue);

void ece353_ADC14_PS2_XY(void);

void ece353_ADC14_PS2_XY_COMP(void);

#endif
