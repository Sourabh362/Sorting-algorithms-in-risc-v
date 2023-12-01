.data
    arr: .word  55, 1, 80, 100, 70
.text

    la a0, arr           	 # Load arr address  in a0
    li t0, 20                    # Load the array lenght
    add a1, a0, t0               # Calculate the last array element address
    jal x1, mergesort            # Call mergesort

    beq x0,x0,done
##
# MERGESORT(*arr, first, last)
# pax1m a0 -> first element address
# pax1m a1 -> last element address
## 
mergesort:

   # Stack management
   addi sp, sp, -32              # Adjust stack pointer
   sw x1, 0(sp)                  # Load return address
   sw a0, 4(sp)                  # Load first element address
   sw a1, 8(sp)                  # Load last element address

   
   # Base case
   li t1, 4                      # Size of one element
   sub t0, a1, a0                # Calculate number of elements
   ble t0, t1, mergesort_end     # If only one element remains in the array, return

   srli  t0, t0, 2               # Divide array size to get half of the element
   srli  t0, t0, 1
   slli  t0, t0, 2
   
   add a1, a0, t0                # Calculate array midpoint address
   sw a1, 12(sp)                 # Store it on the stack

   jal mergesort                 # Recursive call on first half of the array

   lw a0, 12(sp)                 # Load midpoint back from the stack
   lw a1, 8(sp)                  # Load last element address back from the stack

   jal mergesort                 # Recursive call on second half of the array

   lw a0, 4(sp)                  # Load first element address back from the stack
   lw a1, 12(sp)                 # Load midpoint address back form the stack
   lw a2, 8(sp)                  # Load last element address back from the stack

   jal merge                     # Merge two sorted sub-arrays

mergesort_end:
   lw x1, 0(sp)
   addi sp, sp, 32
   ret

##
# Merge(*arr, first, midpoint, last)
# pax1m a0 -> first address of first array   
# pax1m a1 -> first address of second array
# pax1m a2 -> last address of second array
##
merge:

   # Stack management
   addi sp, sp, -32              # Adjust stack pointer
   sw x1, 0(sp)                  # Load return address
   sw a0, 4(sp)                  # Load first element of first array address
   sw a1, 8(sp)                 # Load first element of second array address
   sw a2, 12(sp)                 # Load last element of second array address

   mv s0, a0                     # First half address copy 
   mv s1, a1                     # Second half address copy

   loop:

      mv t0, s0                  # copy first half position address
      mv t1, s1                  # copy second half position address
      lw t0, 0(t0)               # Load first half position value
      lw t1, 0(t1)               # Load second half position value   

      bgt t1, t0, shift_skip     # If lower value is first, no need to perform opex1tions

      mv a0, s1                  # a0 -> element to move
      mv a1, s0                  # a1 -> address to move it to
      jal shift                  # jump to shift 
      
      addi s1, s1, 4

      shift_skip: 

            addi s0, s0, 4          # Increment first half index and point to the next element
            lw a2, 24(sp)           # Load back last element address

            bge s0, a2, end_loop
            bge s1, a2, end_loop
            beq x0, x0, loop

      ##
      # Shift array element to a lower address
      # pax1m a0 -> address of element to shift
      # pax1m a1 -> address of where to move a0
      ##
      shift:

         ble a0, a1, end_shift      # Location reached, stop shifting
         addi t3, a0, -4            # Go to the previous element in the array
         lw t4, 0(a0)               # Get current element pointer
         lw t5, 0(t3)               # Get previous element pointer
         sw t4, 0(t3)               # Copy current element pointer to previous element address
         sw t5, 0(a0)               # Copy previous element pointer to current element address
         mv a0, t3                  # Shift current position back
         beq x0, x0, shift          # Loop again

      end_shift:

         ret

   end_loop:

      lw x1, 0(sp)
      addi sp, sp, 32
      ret
  done:
      nop
