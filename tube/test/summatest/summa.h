#include <stdint.h>
#include <sys/io.h>
#include <stdio.h>

#define basaddr      0x360
#define ainf1        basaddr
#define ainf2        basaddr+1
#define ainf3        basaddr+2
#define adrqx        basaddr+3
#define adran        basaddr+3
#define adrf         basaddr+4
#define adrc         basaddr+5
#define adrl1        basaddr+6
#define adrl2        basaddr+7


uint8_t waitk(void);
void wcnaf(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr);

void setcr(uint8_t cr);
uint8_t instrc(void);
uint8_t instrz(void);
uint8_t rcam16(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr,uint16_t *res);
uint8_t wcam16(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr, uint16_t data);
uint8_t ccamac(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr);


