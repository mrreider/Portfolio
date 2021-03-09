/*
 * task_game.c
 *
 *  Created on: Dec 7, 2020
 *      Author: reidd
 */

#include "main.h"

TaskHandle_t Task_Game_Handle;
QueueHandle_t Queue_Scope;

//X and Y positions for bullet images
int bulletY = 121;
int bulletX3 = 107;
int bulletX2 = 116;
int bulletX1 = 125;

//X and Y start position for shot animation
int startX = 0;
int startY = 0;

uint16_t background_color = LCD_COLOR_BLACK;
uint16_t main_color = LCD_COLOR_RED;

void Task_Game_init(void)
{
    Queue_Scope = xQueueCreate(2, sizeof(CMD_t));

    Crystalfontz128x128_Init();
}

void Task_Game(void *pvParameters)
{

    uint8_t x = 64;
    uint8_t y = 64;

    int ammoCount = 3;

    lcd_draw_image(x, y, scopePaintWidthPixels, scopePaintHeightPixels,
                   scopePaintBitmaps, main_color, background_color);

    drawBullets(bulletX1, bulletY);
    drawBullets(bulletX2, bulletY);
    drawBullets(bulletX3, bulletY);

    while (1)
    {

        CMD_t currCmd;
        xQueueReceive(Queue_Scope, &currCmd, portMAX_DELAY);

        if (currCmd == CMD_LEFT)
        {
            if (x > 29)
                x--;
        }
        else if (currCmd == CMD_RIGHT)
        {
            if (x < 101)
                x++;
        }
        else if (currCmd == CMD_DOWN)
        {
            if (y < 86)
                y++;
        }
        else if (currCmd == CMD_UP)
        {
            if (y > 29)
                y--;
        }

        else if(currCmd == CMD_FIRE){
            if(ammoCount == 0){
                play_no_ammo();
            }
            else{
                play_fire();
                if(ammoCount == 3){
                    eraseBullet(bulletX3, bulletY);
                }
                else if(ammoCount == 2){
                    eraseBullet(bulletX2, bulletY);
                }
                else if(ammoCount == 1){
                    eraseBullet(bulletX1, bulletY);
                }
                startX = x;
                startY = y - (scopePaintHeightPixels/2);
                shotAnimation(startX, startY);
                ammoCount--;
            }
        }

        else if(currCmd == CMD_RELOAD){
            if(ammoCount == 0){
                drawBullets(bulletX1, bulletY);
                play_reload(7, 9);
                drawBullets(bulletX2, bulletY);
                play_reload(9, 11);
                drawBullets(bulletX3, bulletY);
                play_reload(11, 13);
                play_reload(13, 14);
                ammoCount = 3;
            }
        }

        if (brightLight){
            if (background_color != LCD_COLOR_BLACK){
                lcd_draw_rectangle(64, 64, LCD_HORIZONTAL_MAX, LCD_VERTICAL_MAX + 1, LCD_COLOR_BLACK);
                background_color = LCD_COLOR_BLACK;
                main_color = LCD_COLOR_RED;
                if (ammoCount >= 1)drawBullets(bulletX1,bulletY);
                if (ammoCount >= 2)drawBullets(bulletX2,bulletY);
                if (ammoCount >= 3)drawBullets(bulletX3,bulletY);
            }
        }
        else{
            if (background_color != LCD_COLOR_GRAY){
                lcd_draw_rectangle(64, 64, LCD_HORIZONTAL_MAX, LCD_VERTICAL_MAX + 1, LCD_COLOR_GRAY);
                background_color = LCD_COLOR_GRAY;
                main_color = LCD_COLOR_BLUE;
                if (ammoCount >= 1)drawBullets(bulletX1,bulletY);
                if (ammoCount >= 2)drawBullets(bulletX2,bulletY);
                if (ammoCount >= 3)drawBullets(bulletX3,bulletY);
            }
        }

        lcd_draw_image(x, y, scopePaintWidthPixels, scopePaintHeightPixels,
                       scopePaintBitmaps, main_color, background_color);

        vTaskDelay(pdMS_TO_TICKS(.5));
    }
}

void drawBullets(x, y){

    lcd_draw_image(x, y, bulletWidthPixels, bulletHeightPixels,
                   bulletBitmaps, main_color, background_color);
}

void eraseBullet(x, y){
    lcd_draw_image(x, y, bulletWidthPixels, bulletHeightPixels, bulletBitmaps,
                   background_color, background_color);
}

void shotAnimation(x, y){

    int shotEnd = y+5;

    while(shotEnd != 0){
        lcd_draw_image(x, y, shotWidthPixels, shotHeightPixels, shotBitmaps,
                       main_color, background_color);
        y--;
        shotEnd--;
        vTaskDelay(10);
    }

}
