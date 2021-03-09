/*
 * task_s1.c
 *
 *  Created on: Dec 7, 2020
 *      Author: Paul Bartlett
 */

#include "main.h"

TaskHandle_t Task_s2_Handle = NULL;

void task_mkII_s2(void *pvParameters)
{

    // Declare a uint8_t variable that will be used to de-bounce S1
    uint8_t debounce_state = 0x00;

    while (1)
    {

        CMD_t cmd;

        // Shift the de-bounce variable to the right
        debounce_state = (debounce_state << 1);

        // If S1 is being pressed, set the LSBit of debounce_state to a 1;
        if (ece353_MKII_S2())
        {
            debounce_state = debounce_state |= BIT0;
        }

        // If the de-bounce variable is equal to 0x7F, change the color of the tri-color LED.
        if (debounce_state == 0x7F)
        {
            cmd = CMD_RELOAD;
            xQueueSendToBack(Queue_Scope, &cmd, portMAX_DELAY);
        }

        // Delay for 10mS using vTaskDelay
        vTaskDelay(pdMS_TO_TICKS(10));
    }

}

