/*
 * task_game.h
 *
 *  Created on: Dec 7, 2020
 *      Author: reidd
 */

#ifndef TASK_GAME_H_
#define TASK_GAME_H_

#include "main.h"

extern TaskHandle_t Task_Game_Handle;
extern QueueHandle_t Queue_Scope;

void Task_Game_init(void);
void Task_Game(void *pvParameters);

#endif /* TASK_GAME_H_ */
