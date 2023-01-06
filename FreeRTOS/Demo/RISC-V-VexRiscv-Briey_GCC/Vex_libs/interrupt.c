#include "gpio.h"
#include "interrupt.h"
void interruptCtrl_init(InterruptCtrl_Reg* reg){
	reg->MASKS = 0;
	reg->PENDINGS = 0xFFFFFFFF;
}