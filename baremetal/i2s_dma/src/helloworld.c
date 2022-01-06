/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>

#include "platform.h"
#include "xaxidma.h"

#include "xscugic.h"
#include "xuartps_hw.h"

#include "dma.h"
#include "stim.h"

XAxiDma axi_dma;
XScuGic axi_intc;

extern int stim_buf[MAX_FFT_LENGTH]; // FFT input data

// ***** Global variables *****
int s2mm_done; // Flags which get set by ISR
int mm2s_done; // if in interrupt mode
int dma_err;

unsigned int i2s_in;

int main()
{
    // ***** Local variables *****
    int status = 0;

    // Setup UART and enable caching
    init_platform();
    
    xil_printf("\fHello World!\n\r");

    // ***** Initialize drivers *****
    status = init_drivers();
    if (status != XST_SUCCESS)
    {
        xil_printf("Driver initialization failed!\n\r");
        return XST_FAILURE;
    }


    int status = 0;
    xil_printf("Transferring data...\n\r");

    // Flush cache
    Xil_DCacheFlushRange((u32)&i2s_in, 4);
    //Xil_DCacheFlushRange((u32)mm2s_buf, 4096);

    while (1)
    {


        s2mm_done = 0; // Initialize flags which get set by ISR
        mm2s_done = 0;
        dma_err   = 0;
        printf("i2s_in0 addr : %d \n\r",i2s_in );
        printf("i2s_in0 : %d \n\r",*i2s_in );
        // Kick off S2MM transfer
        status = XAxiDma_SimpleTransfer(&axi_dma, (u32)&i2s_in, 4, XAXIDMA_DEVICE_TO_DMA);
        if (status != XST_SUCCESS)
        {
            xil_printf("ERROR! Failed to kick off S2MM transfer!\n\r");
            return XST_FAILURE;
        }
        printf("i2s_in1 : %d \n\r",*i2s_in );
        // Kick off MM2S transfer
        status = XAxiDma_SimpleTransfer(&axi_dma, (u32)&i2s_in, 4, XAXIDMA_DMA_TO_DEVICE);
        if (status != XST_SUCCESS)
        {
            xil_printf("ERROR! Failed to kick off MM2S transfer!\n\r");
            return XST_FAILURE;
        }
        printf("i2s_in2 : %d \n\r",*i2s_in );
        // Wait for transfers to complete
        while (!(s2mm_done && mm2s_done) && !dma_err)
        {
                // Do nothing
        }

        // Check if DMA controller threw an error
        if (dma_err)
        {
            xil_printf("ERROR! DMA device threw an error!");
            return XST_FAILURE;
        }

        xil_printf("DMA transfer complete!\n\r");

        /*int status = 0;

        xil_printf("Performing DMA Transfer...\n\r");

        // Kick off DMA transfers
        status = dma_xfer(&i2s_in, &i2s_in);
        printf("i2s_in : %d \n\r",i2s_in );
        if (status != XST_SUCCESS)
        {
            xil_printf("ERROR! Failed to kick off dma transfer.\r\n", status);
            return status;
        }

        xil_printf("DMA Transfer completed successfully!\n\r\n\r");*/

        //sleep(1);
    }

    return 0;
}
