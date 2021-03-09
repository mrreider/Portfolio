/*
 * light.c
 *
 *  Created on: Dec 8, 2020
 *      Author: reidd
 */
#include "main.h"

TaskHandle_t Task_Light_Handle;
volatile bool brightLight;


void light_init(void){
    i2c_write_16(SLAVE_DEVICE_ADDRESS, SENSOR_CONFIG, SENSOR_RST);
}

double read_light(void){
    uint16_t initialLight;
    initialLight = i2c_read_16(SLAVE_DEVICE_ADDRESS, SENSOR_AMBIENT_LIGHT);
    double lightValue = .01 * pow(2.0, initialLight>>12) * ((initialLight<<4)>>4);
    return lightValue;
}

void task_light(void *pvParameters){
    while(1){
        double value = read_light();
        if (value > 10){
            brightLight = true;
        }
        else{
            brightLight = false;
        }
        vTaskDelay(pdMS_TO_TICKS(3000));
    }
}

