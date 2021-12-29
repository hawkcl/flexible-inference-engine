#ifndef IMAGE_H
#define IMAGE_H
//#define OPENCV

#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <string.h>
#include <math.h>
#ifdef OPENCV
#include "opencv2/highgui/highgui_c.h"
#include "opencv2/imgproc/imgproc_c.h"
#include "opencv2/core/version.hpp"
#if CV_MAJOR_VERSION == 3
#include "opencv2/videoio/videoio_c.h"
#include "opencv2/imgcodecs/imgcodecs_c.h"
#endif
#endif
#include "box.h"
typedef struct image{
	int w;
	int h;
	int c;
	float *data;
} image;




#ifdef OPENCV
void *open_video_stream(const char *f, int c, int w, int h, int fps);
image get_image_from_stream(void *p);
image load_image_cv(char *filename, int channels);
void ipl_into_image(IplImage* src, image im);
int fill_image_from_stream(CvCapture *cap, image im);
void show_image_cv(image p, const char *name, IplImage *disp);
#endif

image load_image(char *filename, int w, int h, int c);
float get_color(int c, int x, int max);
void draw_box(image a, int x1, int y1, int x2, int y2, float r, float g, float b);
void draw_bbox(image a, box bbox, int w, float r, float g, float b);
void write_label(image a, int r, int c, image *characters, char *string, float *rgb);
image image_distance(image a, image b);
void scale_image(image m, float s);
image rotate_crop_image(image im, float rad, float s, int w, int h, float dx, float dy, float aspect);
image random_crop_image(image im, int w, int h);
void letterbox_image_into(image im, int w, int h, image boxed);
image resize_max(image im, int max);
void translate_image(image m, float s);
void embed_image(image source, image dest, int dx, int dy);
void place_image(image im, int w, int h, int dx, int dy, image canvas);
void saturate_image(image im, float sat);
void exposure_image(image im, float sat);
void distort_image(image im, float hue, float sat, float val);
void saturate_exposure_image(image im, float sat, float exposure);
void rgb_to_hsv(image im);
void hsv_to_rgb(image im);
void yuv_to_rgb(image im);
void rgb_to_yuv(image im);
image make_image(int w, int h, int c);
image copy_image(image p);
void free_image(image m);
image load_image_color(char *filename, int w, int h);
image float_to_image(int w, int h, int c, float *data);
image resize_image(image im, int w, int h);
image threshold_image(image im, float thresh);
image load_image(char *filename, int w, int h, int c);
image load_image(char *filename, int w, int h, int c);
void save_image(image im, const char *name);
image crop_image(image im, int dx, int dy, int w, int h);
void fill_cpu(int N, float ALPHA, float *X, int INCX);
void axpy_cpu(int N, float ALPHA, float *X, int INCX, float *Y, int INCY);

image border_image(image a, int border);
image get_label(image **characters, char *string, int size);
image **load_alphabet();
image letterbox_image(image im, int w, int h);
void draw_detections(image im, detection *dets, int num, float thresh, char **names, image **alphabet, int classes);

image collapse_image_layers(image source, int border);
image collapse_images_horz(image *ims, int n);
image collapse_images_vert(image *ims, int n);

void show_image_normalized(image im, const char *name);
void show_images(image *ims, int n, char *window);
void show_image_layers(image p, char *name);
void show_image_collapsed(image p, char *name);

void print_image(image m);

image make_empty_image(int w, int h, int c);
void copy_image_into(image src, image dest);

image get_image_layer(image m, int l);




#endif

