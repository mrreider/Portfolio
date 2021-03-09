/*
 * task_print1.h
 *
 *  Created on: Oct 19, 2020
 *      Author: Reid Brostoff
 */

#ifndef TASK_JOYSTICK_H_
#define TASK_JOYSTICK_H_

#include "main.h"

#define VOLT_0P85  1056      // 0.85 /(3.3/4096)
#define VOLT_2P50  3103      // 2.50 /(3.3/4096)

typedef enum {
    JOYSTICK_DIR_CENTER,
    JOYSTICK_DIR_LEFT,
    JOYSTICK_DIR_RIGHT,
    JOYSTICK_DIR_UP,
    JOYSTICK_DIR_DOWN,
} JOYSTICK_DIR_t;

typedef enum {
    CMD_LEFT,
    CMD_RIGHT,
    CMD_UP,
    CMD_DOWN,
    CMD_CENTER,
    CMD_SPEED,
    CMD_FIRE,
    CMD_RELOAD
} CMD_t;

extern TaskHandle_t Task_Joystick_Handle;
extern TaskHandle_t Task_Joystick_Timer_Handle;

/******************************************************************************
* Configure the IO pins for BOTH the X and Y directions of the analog
* joystick.  The X direction should be configured to place the results in
* MEM[0].  The Y direction should be configured to place the results in MEM[1].
*
* After BOTH analog signals have finished being converted, a SINGLE interrupt
* should be generated.
*
* Parameters
*      None
* Returns
*      None
******************************************************************************/
 void Task_Joystick_Init(void);

/******************************************************************************
* Used to start an ADC14 Conversion
******************************************************************************/
void Task_Joystick_Timer(void *pvParameters);


/******************************************************************************
* Examines the ADC data from the joystick on the MKII
******************************************************************************/
void Task_Joystick_Bottom_Half(void *pvParameters);



#endif /* TASK_JOYSTICK_H_ */
