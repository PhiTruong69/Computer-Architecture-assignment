

# Macro in ra chuoi
.macro print_string(%str)
    la $a0, %str             # Tai dia chi chuoi vao thanh ghi $a0
    addi $v0, $zero, 4       # Syscall 4: In chuoi
    syscall                  # Goi syscall
.end_macro

# Macro in ra chuoi ket hop voi ket qua
.macro print_string_with_result(%prompt, %flo_var)
    print_string %prompt      # Goi macro in chuoi prompt
    lwc1 $f12, %flo_var       # Tai so thuc tu bo nho vao thanh ghi $f12
    addi $v0, $zero, 2        # Syscall 2: In so thuc
    syscall                   # Goi syscall
.end_macro

# Macro in dong moi
.macro print_newline
    li $v0, 4                # Syscall 4: In chuoi
    la $a0, newline          # Tai dia chi chuoi newline vao $a0
    syscall                  # Goi syscall
.end_macro

# Macro mo file de doc
.macro open_file_to_read %filename, %fd
    la $a0, %filename         # Tai dia chi ten file vao $a0
    addi $a1, $zero, 0        # Che do mo file: chi doc (0)
    li $v0, 13                # Syscall 13: Mo file
    syscall                   # Goi syscall
    sw $v0, %fd               # Luu file descriptor vao bien %fd
.end_macro

# Macro doc file va luu vao bo nho
.macro read_file(%fd, %buffer, %size)
    lw $a0, %fd               # Lay file descriptor tu bien %fd
    la $a1, %buffer           # Tai dia chi buffer luu du lieu vao $a1
    li $a2, %size             # So byte can doc
    li $v0, 14                # Syscall 14: Doc file
    syscall                   # Goi syscall
.end_macro

# Macro dong file
.macro close_file(%fd)
    lw $a0, %fd               # Lay file descriptor tu bien %fd
    li $v0, 16                # Syscall 16: Dong file
    syscall                   # Goi syscall
.end_macro
#-----------------------------------------------------------------


#danh sach cac bien 
.data
dulieu1: .space 4              # Dành không gian luu so thuc dau tiên (4 byte)
dulieu2: .space 4              # Dành không gian luu so thuc thu hai  (4 byte)
tenfile: .asciiz "C:\\Users\\PHITRUONGPC\\Downloads\\taskktmt\\FLOAT2.BIN" # duong dan den file nhi phan
fdescr: .word 0               #  Luu file descriptor sau khi mo file
str_dl1: .asciiz "So thuc 1 = "  # Chuoi hien thi so thuc dau tien
str_dl2: .asciiz "So thuc 2 = "  # chuoi hien thi so thuc thu hai 
overflow_text: .asciiz "Xay ra Overflow"  # trang so 
underflow_text: .asciiz "Xay ra Underflow"  # thieu so 
str_kq: .asciiz "Ket qua (So thuc) = "  # hien thi ket qua 
dulieukq: .space 4           # khong gian luu ket qua 
newline: .asciiz "\n"        # xuong dong

.text

#====================================== Main ==============================================                 


main:
    # Su dung macro de mo file 
    open_file_to_read tenfile, fdescr  # Mo file de doc voi tên "tenfile" và luu mo ta file vao "fdescr"

    # doc so thuc dau tien
    read_file fdescr, dulieu1, 4       # doc 4 byte (32-bit float)dau tien vao "dulieu1"

    # doc so thuc thu hai 
    read_file fdescr, dulieu2, 4       # doc tiep 4 byte (32-bit float) tiep theo vao "dulieu2"

  
###############     Xuat hai gia tri ra mang hinh      #######################  


     #in ket qua cuoi cung
    print_string_with_result str_dl1, dulieu1    # In "Ket qua (So thuc) = <gia tri>"               
    print_newline                                # Xuong dong 
    print_string_with_result str_dl2, dulieu2    # In "Ket qua (So thuc) = <gia tri>"             
    print_newline   
#====================================================================================# 
#           Tach so thuc 1 thanh cac thanh phan va chua vao thanh ghi                #  
#           $t1 : 1 bit dau              $t2: 8 bit Exponent                         #  
#           $t3: 23 bit Fraction                                                     #  
#====================================================================================# 

    # Tach so thuc dau tien (dulieu1)
    lw $t0, dulieu1              # Doc gia tri cua dulieu1 vao thanh ghi $t0
    srl $t1, $t0, 31             # Lay bit dau bang cach dich phai 31 bit, luu vao $t1
    andi $t2, $t0, 0x7F800000    # AND voi 0x7F800000 de lay 8 bit exponent
    srl $t2, $t2, 23             # Dich phai 23 bit de lay gia tri exponent thuc su
    andi $t3, $t0, 0x7FFFFF      # AND voi 0x7FFFFF de lay 23 bit Fraction
    subi $t2, $t2, 127           # Dieu chinh bias cua exponent bang cach tru di 127

    beqz $t0, BaseCase0          # Neu gia tri $t0 bang 0, nhay den BaseCase0 (xu ly truong hop dac biet)

#====================================================================================# 
#           Tach so thuc 2 thanh cac thanh phan va chua vao thanh ghi                #  
#           $t1 : 1 bit dau              $t2: 8 bit Exponent                         #  
#           $t3: 23 bit Fraction                                                     #  
#====================================================================================# 

     # Tach so thuc thu hai (dulieu2)
    lw $t0, dulieu2              # Doc gia tri cua dulieu2 vao thanh ghi $t0
    srl $t4, $t0, 31             # Lay bit dau bang cach dich phai 31 bit, luu vao $t4
    andi $t5, $t0, 0x7F800000    # AND voi 0x7F800000 de lay 8 bit exponent
    srl $t5, $t5, 23             # Dich phai 23 bit de lay gia tri exponent thuc su
    andi $t6, $t0, 0x7FFFFF      # AND voi 0x7FFFFF de lay 23 bit Fraction
    subi $t5, $t5, 127           # Dieu chinh bias cua exponent bang cach tru di 127

    beqz $t0, BaseCase0          # Neu gia tri $t0 bang 0, nhay den BaseCase0 (xu ly truong hop dac biet)

#====================================================================================# 
#                     XU LY BIT DAU TRONG 2 THANH GHI $t1 VA $t4                     #  
#====================================================================================# 

    # Goi ham tinh toan dau
    move $a0, $t1                # Truyen bit dau cua so thuc 1 vao $a0
    move $a1, $t4                # Truyen bit dau cua so thuc 2 vao $a1
    jal TinhToanDau              # Goi ham tinh toan dau
    move $t7, $v0                # Luu ket qua dau vao $t7

#====================================================================================#   
###############       XU LY BIT EXPONENT TRONG 2 THANH GHI $t2 VA $t5    #############  
#====================================================================================# 

    # Goi ham tinh toan exponent
    move $a0, $t2                # Truyen exponent cua so thuc 1 vao $a0
    move $a1, $t5                # Truyen exponent cua so thuc 2 vao $a1
    jal TinhToanExponent         # Goi ham tinh toan exponent
    move $t8, $v0                # Luu ket qua exponent vao $t8

#====================================================================================#  
###############       XU LY BIT FRACTION TRONG 2 THANH GHI $t3 VA $t6    #############  
#====================================================================================# 

    # Goi ham tinh toan fraction
    move $a0, $t3                # Truyen fraction cua so thuc 1 vao $a0
    move $a1, $t6                # Truyen fraction cua so thuc 2 vao $a1
    move $a2, $t8                # Truyen exponent da tinh toan vao $a2
    jal TinhToanFraction         # Goi ham tinh toan fraction
    move $t9, $v0                # Luu ket qua fraction vao $t9
    move $t8, $v1                # Cap nhat exponent da chuan hoa vao $t8

#====================================================================================#   
####################        GHEP KET QUA THANH SO THUC       #########################  
#====================================================================================# 

    # Ghep thanh so thuc IEEE-754
    move $a0, $t7                # Truyen bit dau vao $a0
    move $a1, $t8                # Truyen exponent vao $a1
    move $a2, $t9                # Truyen fraction vao $a2
    jal GhepThanhSoThuc          # Goi ham ghep thanh so thuc IEEE-754

    # Luu ket qua tu ham tra ve vao bien "dulieukq"
    sw $v0, dulieukq

    # In ket qua cuoi cung
    print_string_with_result str_kq, dulieukq  # Xuat "Ket qua = <gia tri dulieukq>"

 
    # Dong file
    close_file fdescr            # Dong file da mo

#--------------------------  
    # ket thuc chuong trinh
    li $v0, 10                   # Syscall 10: thoat chuong trinh
    syscall                      # tien hanh
    
#====================================================================================#  
#-----------------------          dinh nghia cac ham           ----------------------#
#====================================================================================# 
# Ham tinh toan dau
# Dau vao 
#   $a0 - Bit dau cua thua so 1
#   $a1 - Bit dau cua thua so 2
# dau ra 
#   $v0 - Bit dau ket qua 
#-------------------------------------------------------------------------------------------------
TinhToanDau:
    xor $v0, $a0, $a1        # XOR hai bit dau de lay dau ket qua
    jr $ra                   # Quay lai ham goi

#-------------------------------------------------------------------------------------------------
# Ham: Tinh toan Exponent
# Dau vao:
#   $a0 - Exponent cua so thuc dau tien
#   $a1 - Exponent cua so thuc thu hai
# Dau ra:
#   $v0 - Exponent da tinh toan (bao gom bias)
#--------------------------------------------------------------------------------------------------
TinhToanExponent:
    add $v0, $a0, $a1         # Cong hai gia tri exponent
    addi $v0, $v0, 127        # Them bias (127) vao ket qua
    
    li $t1, 255
    bge  $v0, $t1, overflow   # Kiem tra Overflow
    li $t1, 0
    ble $v0, $t1, underflow  # Kiem tra Underflow
    jr $ra                   # Quay lai ham goi

#-------------------------------------------------------------------------------------------------
# Ham: Tinh toan Fraction
# Dau vao:
#   $a0 - Fraction cua so thuc dau tien
#   $a1 - Fraction cua so thuc thu hai
#   $a2 - Exponent hien tai
# Dau ra:
#   $v0 - Fraction da chuan hoa
#   $v1 - Exponent da chuan hoa
#-------------------------------------------------------------------------------------------------
TinhToanFraction:

    ori $a0, $a0, 0x800000   # Them bit an (1) vao Fraction cua so dau tien
    ori $a1, $a1, 0x800000   # Them bit an (1) vao Fraction cua so thu hai 

    multu $a0, $a1           # Nhan hai gia tri Fraction khong dau
    mfhi $t0                 # Lay phan cao (HI) cua ket qua nhan
    mflo $t1                 # Lay phan thap (LO) cua ket qua nhan

    sll $t0, $t0, 16         # Dich trai phan cao 16 bit
    srl $t1, $t1, 16         # Dich phai phan thap 16 bit
    or $t0, $t0, $t1         # Ghep phan cao va phan thap thanh Fraction 32-bit

    srl $t0, $t0, 7          # Dich phai 7 bit de chuan hoa Fraction thanh 25 bit

    srl $t1, $t0, 23         # Kiem tra bit ngoai de xac dinh chuan hoa
    subi $t1, $t1, 1         # Tru 1 de kiem tra bit
    beqz $t1, NotNormalize   # Neu khong can chuan hoa, nhay toi NotNormalize

    addi $a2, $a2, 1         # Tang gia tri Exponent neu can chuan hoa
    srl $t0, $t0, 1          #  Dich phai Fraction 1 bit de chuan hoa

    li $t1, 255
    bge  $a2, $t1, overflow   # kiem tra Overflow
    li $t1, 0
    ble $a2, $t1, underflow  # kiem tra Underflow

NotNormalize:
    andi $t0, $t0, 0x7FFFFF  # Gi? l?i 23 bit Fraction
    move $v0, $t0            # chuan hoa vao $v0
    move $v1, $a2            # chuan hoa vao $v1
    jr $ra                   # quay lai ham goi

#-------------------------------------------------------------------------------------------------
# Ham ghep thanh so chuan IEEE-754
# Dau vao
#   $a0 - Bit dau
#   $a1 - Exponent
#   $a2 - Fraction
# Dau ra 
#   $v0 - 32 bit bieu dien so thuc
#-------------------------------------------------------------------------------------------------
GhepThanhSoThuc:
    sll $t0, $a0, 31         # Dich trai bit dau vao vi tri bit cao nhat
    sll $t1, $a1, 23         # Dich trai Exponent vao vi tri cua no
    or $v0, $a2, $t1         # Ghep Fraction va Exponent
    or $v0, $v0, $t0         # Ghep voi bit dau
    jr $ra                   # Quay lai ham goi
    
   
    
#------------------------------------------------------------------------------------
#                       Ham xu ly neu co so thuc bang 0
#------------------------------------------------------------------------------------
BaseCase0:
    # Xu ly truong hop nhan voi 0, se tra ve ket qua la 0.0
    li $t0,0
    sw $t0, dulieukq
    print_string_with_result str_kq, dulieukq

    li $v0, 10               # Syscall 10: thoat ctrinh
    syscall                  # tien hanh thoat chuong trinh 

#------------------------------------------------------------------------------------#  
#                        xu lu Overflow va Underflow                            
#------------------------------------------------------------------------------------#  
overflow:
    # Truong hop Overflow (Exponent vuot qua gia tri lon nhat cho phep)
    print_string overflow_text  # In thong bao "Xay ra Overflow"
    li $v0, 10                  # Syscall 10: Thoat chuong trinh
    syscall                     # Thuc hien thoat chuong trinh

underflow:
    # Truong hop Underflow (Exponent nho hon gia tri nho nhat cho phep)
    print_string underflow_text # In thong bao "Xay ra Underflow"
    li $v0, 10                  # Syscall 10: Thoat chuong trinh
    syscall                     # Thuc hien thoat chuong trinh
