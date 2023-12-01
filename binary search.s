.data
arr: .word 2,3,4,6,7,8,9,11,12,100
.text

la x5,arr

li x6,2100 # target
li x7,0 #low
li x8,9 #high

loop:
    bgt x7,x8,exit
    add x9,x7,x8
    srli x9,x9,1 #mid
    slli x10,x9,2
    add x11,x5,x10

    lw x12,0(x11)

    beq x6,x12,exit
    bgt x6,x12,then
    blt x6,x12,else

    then:
        addi x7,x9,1
        beq x0,x0,loop

    else:
        addi x8,x9,-1
        beq x0,x0,loop

exit:
    slli x13,x9,2
    add x14,x5,x13
    lw x15,0(x14)
    bne x15,x6,set0
    addi x16,x0,1
    set0:
        addi x16,x16,0
         
