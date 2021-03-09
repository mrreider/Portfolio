/*
 * light.h
 *
 *  Created on: Dec 8, 2020
 *      Author: reidd
 */

#ifndef TASK_LIGHT_H_
#define TASK_LIGHT_H_
#include "main.h"

extern TaskHandle_t Task_Light_Handle;
extern volatile bool brightLight;

void light_init(void);
double read_light(void);
void task_light(void *pvParameters);

//Slave Address for I2C
#define SLAVE_DEVICE_ADDRESS 0x44

//Register Addresses for slave
#define SENSOR_AMBIENT_LIGHT 0x00
#define SENSOR_CONFIG 0x01
#define SENSOR_RST 0xC400


#endif /* TASK_LIGHT_H_ */
