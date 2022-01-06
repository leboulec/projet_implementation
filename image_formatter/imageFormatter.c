#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "imageFormatter.h"

double return_max( int N , int array[N] ){

	int max = array[0];

	for (int i = 1; i < N; ++i){
		
		if( array[i] > max ){
			max = array[i];
		}
	}
	return max;
}

double return_min( int N , int array[N] ){

	int min = array[0];

	for (int i = 1; i < N; ++i){
		
		if( array[i] < min ){
			min = array[i];
		}
	}
	return min;
}

void normalize( int N, int array[N] , double min ){

	int gap = ( RESOLUTION_X - N ) / 2;
	if( gap < 0 ){
		for (int i = 0; i < abs(gap); ++i){
			array[i] = 0;
		}
		for (int i = N - abs(gap); i < N; ++i){
			array[i] = 0;
		}
	}

	for (int i = 0; i < N; ++i){
		array[i] += fabs(min);
	}	

	double max_norm = return_max( N , array );
	double min_norm = return_min( N, array );
	double scale = SCALING_FACTOR * (double) (max_norm - min_norm) / RESOLUTION_Y;
	if (scale == 0)
		return;

	for (int i = 0; i < N; ++i){
		array[i] /= scale;
	}
}

void setPixels( int N , int array[N] , rgb_t pixels[RESOLUTION_X][RESOLUTION_Y], int isSignal ){

	int gap, offset;

	gap = ( RESOLUTION_X - N ) / 2;

	if (isSignal)
		offset = 0;
	else
		offset = RESOLUTION_Y / 2 + 1;

	for (int i = abs(gap); i < RESOLUTION_X - abs(gap); i++) {
		int tmp = array[i - gap];
		pixels[i][tmp + offset].r = 15;
		pixels[i][tmp + offset].g = 15;
		pixels[i][tmp + offset].b = 15;
	}
}

void image_formatter( int N , int array[N] , rgb_t pixels[RESOLUTION_X][RESOLUTION_Y], int isSignal ){

	double min = return_min( N , array );
	normalize( N , array , min);
	setPixels( N , array , pixels , isSignal );
}

void init_image( rgb_t pixels[RESOLUTION_X][RESOLUTION_Y] ){

	for (int i = 0; i < RESOLUTION_X; ++i) {
		for (int j = 0; j < RESOLUTION_Y; ++j){
			pixels[i][j].r = 0;
			pixels[i][j].g = 0;
			pixels[i][j].b = 0;
		}
	}

	//Central horizontal bar
	for (int i = 0; i < RESOLUTION_X; ++i){
		pixels[i][RESOLUTION_Y / 2].r = 15;
		pixels[i][RESOLUTION_Y / 2].g = 15;
		pixels[i][RESOLUTION_Y / 2].b = 15;
	}
}

void get_fft_data(int* result_buf)
{
	// *** Local variables ***
	int ii;
	signed int xk_re, xk_im;

	for (ii = 0; ii < FFT_LENGTH; ii++)
	{
		// Grab output values
		xk_re = result_buf[ii] & XK_RE_MASK;         // Lower bits
		//xk_im = (result_buf[ii] & XK_IM_MASK) >> 16; // Upper bits

		// Sign extend output values
		if (xk_re & SIGN_TEST_MASK)
			xk_re += SIGN_EXTEND_MASK;
		//if (xk_im & SIGN_TEST_MASK)
		//	xk_im += SIGN_EXTEND_MASK;

		result_buf[ii] = xk_re;
	}
}

int main(){

	rgb_t pixels[RESOLUTION_X][RESOLUTION_Y];
	int fft[FFT_LENGTH] = {0};
	int signal[SIGNAL_LENGTH] = {0};

	init_image(pixels);
	get_fft_data(fft);

	image_formatter(FFT_LENGTH, fft, pixels, FFT );
	image_formatter(SIGNAL_LENGTH, signal, pixels, SIGNAL );

	return 0;
}