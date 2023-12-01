# quicksort(*array,first_ele,last_ele)
# a1 <- array -> a1    
# a2 <- low     saving in s2
# a3 <- high    saving in s3
# x1 <- return address

.data
    array: .word 5,1,3,7,9,8
    #array: .word 7,3,5,8,5,12,250,1,99,2,54,34,23,65,13,24,75,37,88,77
.text
    la a1,array            # a1 pointing to the array
    li a2, 0               # a2 a[0]
    li a3, 20              # a3 a[last_index  - 1]

    jal x1, Quicksort      # stroing the return address in x1
    beq x0,x0,done         # exiting after completion
   
Quicksort:
    blt a3, a2, exit      # if (lo >= hi) we just return
																			  
    addi sp, sp, -16      # Adjusting stack to hold 4 elements
    sw x1, 0(sp)
    sw s2, 4(sp)           # s2 is going to hold lo
    sw s3, 8(sp)           # s3 is going to hold hi
    sw s0, 12(sp)          # s0 is going to hold the pivot

    # hold lo and hi
    mv s2, a2          # saving low index to s2
    mv s3, a3          # saving high index to s3
    jal x1, partition  # call partition

    mv s0, a0    # save the pivot on s0

                            # recursively call quicksort on both subarx1ys
    addi a3, s0, -4         # high = pivot -1
    mv a2, s2               # low = low
    jal x1, Quicksort       # quicksort(a1*, low, pivot-1)

    addi a2, s0, 4          # low = pivot (+1)
    mv a3, s3               # high = high
    jal x1, Quicksort

    lw x1, 0(sp)           # load stuff back from the stack
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s0, 12(sp)
    addi sp, sp, 32
exit:                    # returning the pointer to other half of the aray
    ret

# partition(*arr, low, high) -> pivot(return value)
partition:
    # save stuff in the stack
    addi sp, sp, -24
    sw x1, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)

    # init pivot to high (a3)
    add t0, a1, a3
    lw t0, 0(t0)

    addi t2, a2, -4     # (i) index of the smaller element => t2 = low - 1
    mv t6, a2           # t6 = j = low
    addi t5, a3, -4     # t5 = high-1

loop:
    bgt t6, t5, end    # if t6 > t5 then partition_forloop_end
    add s3, a1, t6         # s3 = *arr[j]
    lw t1, 0(s3)           # t1 = *(arr[j])
        
    blt t1,t0,swap            # swappin if the element is lesser than pivot
	addi t6,t6,4
	j loop
	
swap: 
	 addi t2, t2, 4      # i++
	 add s2, a1, t2     # s2 = *arr[t2] = *arr[i]
	 lw t3, 0(s2)       # t3 = *(arr[i])
	 sw t3, 0(s3)       # arr[j] = t3
	 sw t1, 0(s2)       # arr[i] = t1
    addi t6,t6,4
	j loop
end:
    addi a0, t2, 4      # write return value as i+1

    # swap(&arr[i+1], &arr[high])
    add s2, a1, a0         # s2 = *arr[i+1]
    add s3, a1, a3         # s3 = *arr[high]
    lw t2, 0(s2)           # t2 = *s2
    lw t3, 0(s3)           # t3 = *s3
    sw t2, 0(s3)
    sw t3, 0(s2)

    lw x1, 0(sp)        # loading back values from the stack
    lw s2, 4(sp)
    lw s3, 8(sp)
    addi sp, sp, 24
return:
    ret
done: nop
