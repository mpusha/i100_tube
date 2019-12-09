#include <stdint.h>
#include <sys/io.h>
#include <stdio.h>
#include "summa.h"

uint8_t waitk(void)
{
  uint8_t tmp=inb(adrqx);
  if((tmp&0x08)==0) return(4);  
  for(int i=0;i<10;i++){
    tmp=inb(adrqx); 
    if((tmp&0x04)==0){ 
      if((tmp&0x01)==0) {
        if((tmp&0x02)==0) return(0); else return(3);
      }
      else {
        return(2);
      }
    }
  }
  return(1);
}

void wcnaf(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr)
{
  uint8_t tmp;
  outb(cr,adrc); 
  tmp=((nr&0x0f)<<4)|(ar&0x0f);
  outb(tmp,adran); 
  tmp=((nr&0x10)>>4)|((fr&0x1f)<<1);
  outb(tmp,adrf); 
}

// set crate
void setcr(uint8_t cr)
{
  outb(cr,adrc); 
}

uint8_t instrc(void)
{
  outb(0,adran); 
  outb(0x80,adrf); 
  uint8_t tmp=waitk();
  return(tmp);
}

uint8_t instrz(void)
{
  outb(0,adran); 
  outb(0x40,adrf); 
  uint8_t tmp=waitk();
  return(tmp);
}

uint8_t rcam16(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr,uint16_t *res)
{
  wcnaf(cr,nr,ar,fr);
  uint8_t tmp=waitk(); 
  if(tmp) return tmp;
  *res=(inb(ainf2)<<8) | inb(ainf1); 
  return(0);  
}
uint8_t wcam16(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr, uint16_t data)
{
  outb((uint8_t)(data&0xff),ainf1);
  outb((uint8_t)((data>>8)&0xff),ainf1+1);
  wcnaf(cr,nr,ar,fr);
  return(waitk()); 
  
}

uint8_t ccamac(uint8_t cr,uint8_t nr,uint8_t ar,uint8_t fr)
{
  wcnaf(cr,nr,ar,fr);
  return(waitk()); 
}


