	.org 0 ;		Program starts at address 0
	la r31,TOP ;		r31 holds the loop address
	la r30,MYD ;		r30 points to the output data array
	la r1,0 ;		Initialize difference engine coefficients
	lar r2,999999
	la r3,-10
	la r4,-30
	la r5,-24
TOP:	st r1,0(r30) ;		Store a value of F(x)
	addi r30,r30,4 ;	Point to next element of the output array
	add r1,r1,r2 ;		Update the difference engine values
	add r2,r2,r3
	add r3,r3,r4
	add r4,r4,r5
	brpl r31,r2 ;		Branch conditionally to TOP
	st r1,0(r30) ;		Store the last value of F(x)
	stop ;			Stop
	.org 4096 ;		The output array is located at address 4096
MYD:	.dw 256
