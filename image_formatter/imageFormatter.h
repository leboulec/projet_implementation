#ifndef __IMAGE_FORMATTER_H__
#define __IMAGE_FORMATTER_H__

#define XK_RE_MASK         0x0000FFFF
#define XK_IM_MASK         0xFFFF0000
#define SIGN_TEST_MASK     0x00008000 // Testing for signedness. Used for sign extension
#define SIGN_EXTEND_MASK   0xFFFF0000

#define RESOLUTION_X 640
#define RESOLUTION_Y 480

#define FFT_LENGTH 128
#define SIGNAL_LENGTH 128

#define FFT 0
#define SIGNAL 1
#define SCALING_FACTOR 2.1

#define pi 3.1415926535

typedef struct rgb_s {
	unsigned int r: 4;
	unsigned int g: 4;
	unsigned int b: 4;
	unsigned int _padding: 4;
} rgb_t;

double return_max(int N, int array[N]);
double return_min(int N, int array[N]);
void normalize(int N, int array[N], double min);
void setPixels(int N, int array[N], rgb_t pixels[RESOLUTION_X][RESOLUTION_Y], 
							      int isSignal );
void image_formatter(int N, int array[N], rgb_t pixels[RESOLUTION_X][RESOLUTION_Y],
								     int isSignal);
void init_image(rgb_t pixels[RESOLUTION_X][RESOLUTION_Y]);
void get_fft_data(int* result_buf);

#endif