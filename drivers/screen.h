#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

// default color scheme
#define WHITE_ON_BLACK 0x0f

//Screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

/* publicly exposed functions */
void print(char *s);
void print_at(char *s, int col, int row);
