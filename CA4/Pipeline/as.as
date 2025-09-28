        jal ra,8
        sw s0,84(zero)



        add     s0, zero, zero    
        add     s1, zero, zero     
        add     s2, zero, zero    
        add     s4, zero, zero    
Loop:
        slti    t1, s1, 20         
        beq     t1, zero, EndLoop  
        lw      s3, 0(S4)          
        slt     t2, s3, s0         
        bne     t2,zero,EndIf
        add     s0, zero, s3     
        add     s2, zero, s1     
EndIf:
        addi    s1, s1, 1        
        addi    s4, s4, 4 
        jal     zero, Loop         

EndLoop:
        jalr zero, ra,0


00000433
000004b3
00000933
00000a33
0144a313
02030263
000a2983
0089a3b3
00039663
01300433
00900933
00148493
004a0a13
fddff06f




00000433
000004b3
00000933
00000a33
0144a313
00031463
00c0006f
000a2983
0089a3b3
00038463
fe5ff06f
01300433
00900933
00148493
004a0a13