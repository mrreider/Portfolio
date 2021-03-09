/*
 * task_led.c
 *
 *  Created on: Oct 19, 2020
 *      Author: Reid Brostoff
 */

#include <main.h>


TaskHandle_t Task_Joystick_Handle;
TaskHandle_t Task_Joystick_Timer_Handle;

volatile uint32_t JOYSTICK_X_DIR = 0;
volatile uint32_t JOYSTICK_Y_DIR = 0;
volatile uint32_t ACCELEROMETER_Y_DIR = 0;

/******************************************************************************
 * This function will run the same configuration code that you would have
 * written for HW02.
 ******************************************************************************/
void Task_Joystick_Init(void)
{
    // Configure the Y direction as an analog input pin for joystick.
    P6->SEL0 |= BIT0;
    P6->SEL1 |= BIT0;

    //Configure the X direction as an analog input pin for joystick.
    P4->SEL0 |= BIT4;
    P4->SEL1 |= BIT4;

    //Configure the Y direction as an analog input pin for accelerometer
    P4->SEL0 |= BIT0;
    P4->SEL0 |= BIT0;

    // Configure CTL0 to sample 16-times in pulsed sample mode.
    // NEW -- Indicate that this is a sequence of samples.
    ADC14->CTL0 = ADC14_CTL0_SHT0_2 | ADC14_CTL0_SHP | ADC14_CTL0_CONSEQ_1;

    // Configure CTL1 to return 12-bit values
    ADC14->CTL1 = ADC14_CTL1_RES_2; // Use sampling timer, 12-bit conversion results

    // Associate the X direction analog signal with MEM[0]
    ADC14->MCTL[0] |= ADC14_MCTLN_INCH_15;

    // Associate the Y direction analog joystick signal with MEM[1]
    // NEW -- Make sure to indicate this is the end of a sequence.
    ADC14->MCTL[1] |= ADC14_MCTLN_INCH_9;

    //Associate Y direction accelerometer with MCTL2
    ADC14->MCTL[2] |= ADC14_MCTLN_INCH_13 | ADC14_MCTLN_EOS;

    // Enable interrupts AFTER a value is written into MEM[1].
    ADC14->IER0 |= ADC14_IER0_IE1;


    // Enable ADC Interrupt
    NVIC_EnableIRQ(ADC14_IRQn);

    // Interrupt priorities must NOT be set to 0.  It is preferred if they are set to a value that is > than 1 too.
    NVIC_SetPriority(ADC14_IRQn, 2);

    // Turn ADC ON
    ADC14->CTL0 |= ADC14_CTL0_ON;

}

/******************************************************************************
 * Used to start an ADC14 Conversion
 ******************************************************************************/
void Task_Joystick_Timer(void *pvParameters)
{

    while(1)
         {
             /*
              * Start the ADC conversion
              */
             ADC14->CTL0 |= ADC14_CTL0_SC | ADC14_CTL0_ENC;
             /*
              * Delay 50mS
              */
             vTaskDelay(pdMS_TO_TICKS(5));

         }
}

/******************************************************************************
 * Bottom Half Task.  Examines the ADC data from the joy stick on the MKII
 ******************************************************************************/
void Task_Joystick_Bottom_Half(void *pvParameters)
{

    CMD_t input;

    while (1)
    {

        ulTaskNotifyTake(pdTRUE, portMAX_DELAY);

        if (JOYSTICK_X_DIR < VOLT_0P85)
        {
            input = CMD_LEFT;
        }
        else if (JOYSTICK_X_DIR > VOLT_2P50)
        {
            input = CMD_RIGHT;
        }
        else if (JOYSTICK_Y_DIR < VOLT_0P85)
        {
            input = CMD_DOWN;
        }
        else if (JOYSTICK_Y_DIR > VOLT_2P50)
        {
            input = CMD_UP;
        }
        else
        {
            input = CMD_CENTER;
        }

        if (ACCELEROMETER_Y_DIR > 2600){
            input = CMD_FIRE;
            vTaskDelay(pdMS_TO_TICKS(200));
        }

        if (input != CMD_CENTER)
        {
            xQueueSendToBack(Queue_Scope, &input, portMAX_DELAY); //need to create queue here.
        }
    }
}

/******************************************************************************
 * Top Half of ADC14 Handler.
 ******************************************************************************/
void ADC14_IRQHandler(void)
{
    JOYSTICK_X_DIR = ADC14->MEM[0];
    JOYSTICK_Y_DIR = ADC14->MEM[1];
    ACCELEROMETER_Y_DIR = ADC14->MEM[2];

    vTaskNotifyGiveFromISR(Task_Joystick_Handle, pdFALSE);
}

