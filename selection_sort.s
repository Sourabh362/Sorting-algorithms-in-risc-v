#Selection sort
.data
arr:.word 54,-58,0,47,8,9
.text

la x5,arr
li x6,0 #index
li x7,5 #end index
loop1:
    bgt x6,x7,exit1
    slli x8,x6,2
    add x9,x5,x8
    
    
    addi x11,x6,1
    loop2:
        bgt x11,x7,exit2
        slli x12,x11,2
        add x13,x5,x12
        lw x10,0(x9)
        lw x14,0(x13)
        
        bgt x14,x10,skip
        sw x14,0(x9)
        sw x10,0(x13)
        skip:
        addi x11,x11,1
        
        beq x0,x0,loop2
        exit2:
        addi x6,x6,1
    beq x0,x0,loop1
exit1:
    nop
        
        
    