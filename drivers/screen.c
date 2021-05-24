#include "ports.h"
#include "screen.h"

// a useful default function
// that rights to start of the screen
void print(char* s){
	print_str_at(s, -1, -1)
}


// now extending the printing of single char
// to a char array
void print_str_at(char* s, int col, int row){
	if(col >= 0 && row >= 0){
		set_cursor(get_screen_offset(row, col));
	} 
	int i = 0;
	while(s[i] != 0){
		print_char(s[i++], col, row, WHITE_ON_BLACK)
	}
}

// print a char on the screen at col and row, or at the cursor 
// position with the given attributes
void print_char(char c, int col, int row, char attr_byte){

	unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

	// if attributes are not supplied, use the default attributes
	if(!attr_byte){
		attr_byte = WHITE_ON_BLACK;
	}

	int offset;

	// if col and row are given, compute and offset
	// based on that 
	if(col >= 0 && row >= 0){
		offset = get_screen_offset(row, col);
	} else {
		offset = get_cursor_offset();
	}

	// advance cursor offset to beginning of next line
	if(c == '\n'){
		// find the current row, since row starts at zero
		// just need to devide by 2 * MAX_COLS
		// always remember that each cell is 2 bytes
		// and hence multiplied by 2
		int current_row = offset/ (2 * MAX_COLS);

		// ** why do we need to subtract 1 from MAX_COLS
		// ** try it and find out what actually happens
		offset = get_screen_offset(current_row, (MAX_COLS - 1));
	} else {
		vidmem[offset] = c;
		vidmem[offset + 1] = attr_byte;
	}

	// update offset to next cell, that is two bytes away
	offset += 2

	//handle scrolling, if the viewport is at the last row
	//offset = handle_scrolling(offset)

	// update the VGA cursor position using the port registers
	set_cursor(offset)
}

int get_screen_offset(int row, int col){
	// assume that row index starts at zero
	// each row contains MAX_COLS cells
	// finally it is multiplied by 2 since each is 
	// 2 bytes
	return (row * MAX_COLS + col) * 2
}

int set_cursor(int offset){
	// to get the position, devide by 2
	// as original offset is position * 2 (since one position is two bytes)
	offset = offset/2

	port_byte_out(REG_SCREEN_CTRL, 14);
	// get the high bytes of offset
	port_byte_in(REG_SCREEN_DATA, (offset >> 8))
	port_byte_out(REG_SCREEN_CTRL, 15);
	// get the low bytes of the offset
	port_byte_in(REG_SCREEN_DATA, (offset & 0xff))
}

int get_cursor_offset(){
	/* 
	* Use VGA ports to get the current cursor offset
	* 1. Ask for high byte of the cursor offset, this will
	* be available once we pass '14' to control register port and 
	* get the content from data register port
	*/
	port_byte_out(REG_SCREEN_CTRL, 14);

	// ** dint understand why we are shifting 
	// ** once we get the data from screen control register
	// is it because, it is the high byte that we are left shifting
	// before we add with the low byte?
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;

	/*
	* 2. Ask for low byte of the cursor offset, this will
	* be available once we pass '15' to control register port and 
	* get the content from data register port
	*/
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);


	return offset * 2

}

int get_offset(int col, int row) {
	// assume that row index starts at zero
	// for each row there are MAX_COLS number of columns
	// each cell is two bytes that is why a multiplication
	// by 2
	return 2 * (row * MAX_COLS + col); 
}