#ifndef BOX_H
#define BOX_H
typedef struct{
	float x, y, w, h;
} box;
typedef struct{
    float dx, dy, dw, dh;
} dbox;

typedef struct detection{
	box bbox;
	int classes;
	float prob[100];
	float *mask;
	float objectness;
	int sort_class;
} detection;

void do_nms_sort(detection *dets, int total, int classes, float thresh);
float box_rmse(box a, box b);
float box_iou(box a, box b);
dbox diou(box a, box b);
box decode_box(box b, box anchor);
box encode_box(box b, box anchor);

#endif
