unsigned char port_byte_in(unsigned short port){
	// reads a byte from the specified port
	// loads edx with port
	// put the value of al register in variable result
	// once done
	unsigned char result;
	__asm__("in %%dx, %%al": "=a" (result) : "d" (port));
	return result;
}

unsigned char port_byte_out(unsigned short port, unsigned char data){
	// load the incoming data to al
	// load port to edx
	// finally output the data to port register pointed by edx
	__asm__("out %%al, %%dx": : "a" (data), "d" (port));
}

unsigned char port_word_in(unsigned short port){
	// same as port_byte - 
	// except we read the full word, so use ax
	unsigned char result;
	__asm__("in %%dx, %%ax": "=a" (result) : "d" (port));
	return result;
}

unsigned char port_word_out(unsigned short port, unsigned short data){
	// same as byte_out, here we use entire register ax
	// rather the lower byte alone
	__asm__("out %%ax, %%dx": : "a" (data),  "d" (port));
}
