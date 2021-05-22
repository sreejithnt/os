void main(){
	// point to the memory location corresponding to the
	// address mapped to VGA
	char* video_memory  = (char*)0xb8000;
	*video_memory = 'X'
}