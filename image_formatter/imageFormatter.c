#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>

#define RESOLUTION_X 200 //640
#define RESOLUTION_Y 100 //480

#define FFT_LENGTH 128
#define SIGNAL_LENGTH 128

#define FFT false
#define SIGNAL true
#define SCALING_FACTOR 2.1

#define pi 3.1415926535

double return_max( int N , double array[N] ){

	double max = 0;

	for (int i = 0; i < N; ++i){
		
		if( array[i] > max ){
			max = array[i];
		}
	}

	return max;
}

double return_min( int N , double array[N] ){

	double min = 1;

	for (int i = 0; i < N; ++i){
		
		if( array[i] < min ){
			min = array[i];
		}
	}

	return min;
}

void normalize( int N ,double array[N] , double min ){

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

	for (int i = 0; i < N; ++i){
		array[i] /= scale;
	}
}

void setPixels( int N , double array[N] , int pixels[RESOLUTION_X][RESOLUTION_Y] , bool isSignal ){

	int gap , offset;

	gap = ( RESOLUTION_X - N ) / 2;	

	if (isSignal){
		offset = 0;
	}
	else{
		offset = RESOLUTION_Y / 2 + 1;
	}

	for (int i = abs(gap); i < RESOLUTION_X - abs(gap); i++) {
		int tmp = array[i - gap];
		pixels[i][tmp + offset] = 1;
	}
}

void print_image( int pixels[RESOLUTION_X][RESOLUTION_Y] ){

	for (int y = 0; y < RESOLUTION_Y; ++y){
		for (int x = 0; x < RESOLUTION_X; ++x){
			printf("%c", pixels[x][y] == 1 ? '*' : ' ' );
		}
		printf("\n");
	}		
}

void fill_array_with_sin( int N , double array[N] ){

	for (int i = 0; i < N; ++i){
		double k = (double) i / (double) N;
		array[i] = sin(2.0 * pi * k );
	}
}

void fill_array_with_triangle( int N , double array[N] ){

	int offset = N / 2;

	for (int i = 0; i < N; ++i){
		array[i] = abs( i - offset );
	}
}

void image_formatter( int N , double array[N] , int pixels[RESOLUTION_X][RESOLUTION_Y], bool isSignal ){

	double min = return_min( N , array );
	normalize( N , array , min);
	setPixels( N , array , pixels , isSignal );
}

void init_image( int pixels[RESOLUTION_X][RESOLUTION_Y] ){

	for (int i = 0; i < RESOLUTION_X; ++i) {
		for (int j = 0; j < RESOLUTION_Y; ++j){
			pixels[i][j] = 0;
		}
	}

	//Central horizontal bar
	for (int i = 0; i < RESOLUTION_X; ++i){
		pixels[i][RESOLUTION_Y / 2] = 1;
	}
}

void fill_array_with_random( int N , double array[N] ){

	srand( time( NULL ) );

	for (int i = 0; i < N; ++i){
		double x = (double)rand() / (double)(RAND_MAX / 100); //random float between 0 and 100
		if( rand() == 0 ){
			x = -x;
		}
		array[i] = x;
	}	
}

int main(){

	int pixels[RESOLUTION_X][RESOLUTION_Y];
	double fft[FFT_LENGTH];
	double signal[SIGNAL_LENGTH];

	init_image(pixels);

	fill_array_with_sin(FFT_LENGTH , fft);
	fill_array_with_triangle(SIGNAL_LENGTH , signal );
	//fill_array_with_random(FFT_LENGTH , fft);
	//fill_array_with_random(SIGNAL_LENGTH , signal);

	image_formatter(FFT_LENGTH, fft, pixels, FFT );
	image_formatter(SIGNAL_LENGTH, signal, pixels, SIGNAL );

	print_image(pixels);

	return 0;
}

