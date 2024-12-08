.data
a: .space 20   #20-per 5 integera
n: .word 0
message1: .asciiz "Jep numrin e antareve te vektorit (max. 5):"
message2: .asciiz "\nShtypni elementet nje nga nje:\n"
message3: .asciiz "\nVlerat e vektorit ne fund:\n"
newline: .asciiz "\n"
outmessage: .asciiz "\nKjo vlere eshte me e madhe se 5\n"

.text
.globl main

main:
la $a0,a           
lw $a1,n          

jal populloVektorin

jal unazaKalimit
addi $sp,$sp,4

li $v0,10
syscall



populloVektorin:
li $v0,4               #per me shfaq mesazhin 1
la $a0,message1
syscall

li $v0,5               #per me mar n
syscall 
move $a1,$v0           #e qon vleren e marrur aty ku e kema rezervu vendin per n


bgt $a1,5,out          #kushti per mos me qene n me i madh se 5

li $v0,4               #per me shfaq mesazhin 2
la $a0,message2
syscall

addi $t0,$zero,1      #i=1

populloVektorinLoop:
bgt $t0,$a1,exitPopulloLoop
sll $t1,$t0,2               #i*4-pasi qdo anetar i zen nga 4 bajt
 
li $v0,5                   #e merr nje vlere
syscall
sw $v0,a($t1)              #ate vlere e qon te adresa e antetarit te vektorit

addi $t0,$t0,1              #i++
j populloVektorinLoop

out:                   #kur n eshte me i madh se 5
li $v0,4               #per me shfaq outmessage
la $a0,outmessage
syscall
j populloVektorin

exitPopulloLoop:
jr $ra



unazaVlerave:
addi $t6,$t0,1                  #k=p+1
unazaVleraveLoop:
bgt $t6,$a1,exitVleratLoop     #kushti per me qene k <= n

sll $t7,$t6,2                  #=k*4
lw $t8,a($t7)                  #$t8= a[k]
bgt $t2,$t8,continue           #nese (min > a[k]) atehere shko tek continue

addi $t6,$t6,1                 #k++
j unazaVleraveLoop


continue:
move $t2,$t8                   #min = a[k]
move $t3,$t7                   #loc = k

addi $t6,$t6,1                 #k++
j unazaVleraveLoop

exitVleratLoop:
jr $ra





unazaKalimit:
addi $sp,$sp,-4            #e ruajm return address ne stack pinter
sw $ra,0($sp)

addi $t2,$zero,0           #$t2=min=0
addi $t3,$zero,0           #$t3=loc=0
addi $t4,$zero,0           #$t4=tmp=0

addi $t0,$zero,1           #p=1
sub $s0,$a1,1              #$s0=n-1

unazaKalimitLoop:
bgt $t0,$s0,exitKalimiLoop

sll $t1,$t0,2              #t1=p*4
lw $t5,a($t1)              #ne regjistrin $t5 e ruajm vleren e a[p]
move $t2,$t5               #min = a[p]
move $t3,$t1               #loc=p*4
jal unazaVlerave           #shko tek funksioni unazaVlerave
lw $ra,0($sp)              #e hekim ra nga stack


move $t4,$t5              #tmp = a[p]
lw $t9,a($t3)             #ne regjistrin $t9 e ruajm vleren e a[loc]
sw $t9,a($t1)             #a[p] = a[loc]
sw $t4,a($t3)             #a[loc] = tmp


addi $t0,$t0,1             #p++
j unazaKalimitLoop

exitKalimiLoop:

li $v0,4               #per me shfaq mesazhin 3
la $a0,message3
syscall
addi $a2,$zero,1       #i=1
printLoop:             #loop per me i printu anetaret e sortuar te vektorit 
bgt $a2,$a1,exitPrintLoop

sll $t1,$a2,2         #t1=i*4
lw $a3,a($t1)         #ne regjistrin $a3 e ruajm vleren e antarit

li $v0,1              #e printojme anetarin e vargut
move $a0,$a3 
syscall
li $v0,4               #per me dal resht te ri
la $a0,newline
syscall

addi $a2,$a2,1         #i++
j printLoop

exitPrintLoop:
jr $ra








