#Insertion sort

.data
arr:.word 12,23,45,51,19,8
.text

la x5,arr
li x6,5 # maximum index
li x7,1  # current index

loop1:
    bgt x7,x6,exit1
    addi x8,x7,-1
    slli x9,x7,2
    add x15,x9,x5
    lw x11,0(x15)
    
    
    addi x12,x7,0
    
    loop2:
        blt x8,x0,exit2
        slli x10,x8,2
        add x16,x10,x5
        lw x13,0(x16)
        blt x13,x11,exit2
        slli x14,x12,2
        add x17,x14,x5
        sw x13,0(x17)
        addi x12,x12,-1
        addi x8,x8,-1
        
        beq x0,x0,loop2
    exit2:
        slli x18,x12,2
        add x19,x18,x5
        sw x11,0(x19)
        addi x7,x7,1
        beq x0,x0,loop1
    exit1:
        nop
        