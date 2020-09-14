/************************************************************************
 *							SDRAM Write / Read							*
 ************************************************************************/
#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"

#include <io.h>
#include <string.h>
#include <stdlib.h>
#include "sys/alt_stdio.h"

int main()
{
	unsigned int address = NEW_SDRAM_CONTROLLER_0_BASE;
	unsigned int shift = NEW_SDRAM_CONTROLLER_0_SPAN - 512000; //800x640;
	alt_u16 pattern = 0x1DCE; // RGB565 -->
		/* Perform a walking write from the given address */
	for (int pixel = shift; pixel < NEW_SDRAM_CONTROLLER_0_SPAN; ++pixel)
	  {
	    /* Write the pattern */
	    IOWR_32DIRECT(address, pixel, pattern);
	    /* Read it back (immediately is okay for this test) */
	    if (IORD_32DIRECT(address, pixel) != pattern)
	    {
	    	printf("Pattern mismatch\n", pixel);
	    	break;
	    }
	    else {IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, pattern);}
	  }

	printf("Nios II ready!\n"); // ready evidence

  return 0;
}
