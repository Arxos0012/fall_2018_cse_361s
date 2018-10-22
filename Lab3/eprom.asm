	.org 0
	la r31,LOOP
        la r29,TOP
	la r1,0
TOP:	la r30,-1
	shl r30,r30,21
LOOP:	st r1,0(r30)
	addi r30,r30,4
	brnz r31,r30
	addi r1,r1,1
        br r29
	stop

	.org 4096 ;
MYD:	.dw 1024

	.org 4292870144
MYVGA:	.dw 524288
