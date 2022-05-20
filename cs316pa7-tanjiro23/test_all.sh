#!/bin/bash

g++-9 -std=c++11 tiny4regs.C -o tiny4
g++-9 -std=c++11 tinyNew.C -o tiny

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing factorial2.micro"
	bash runme ./inputs/factorial2.micro user_op.out 
	./tiny4 user_op.out < ./inputs/factorial2.input | head -2 > prg_output.txt
	./tiny ./outputs/factorial2.out < ./inputs/factorial2.input |head -2 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for factorial2.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing fibonacci2.micro"
	bash runme ./inputs/fibonacci2.micro user_op.out 
	./tiny4 user_op.out < ./inputs/fibonacci2.input | head -16 > prg_output.txt
	./tiny ./outputs/fibonacci2.out < ./inputs/fibonacci2.input |head -16 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for fibonacci2.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing fma.micro"
	bash runme ./inputs/fma.micro user_op.out 
	./tiny4 user_op.out < ./inputs/fma.input | head -3 > prg_output.txt
	./tiny ./outputs/fma.out < ./inputs/fma.input |head -3 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for fma.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing step4_testcase.micro"
	bash runme ./inputs/step4_testcase.micro user_op.out 
	./tiny4 user_op.out < ./inputs/step4_testcase.input | head -1 > prg_output.txt
	./tiny ./outputs/step4_testcase.out < ./inputs/step4_testcase.input |head -1 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for step4_testcase.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing step4_testcase2.micro"
	bash runme ./inputs/step4_testcase2.micro user_op.out 
	./tiny4 user_op.out | head -1 > prg_output.txt
	./tiny ./outputs/step4_testcase2.out |head -1 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for step4_testcase2.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_if.micro"
	bash runme ./inputs/test_if.micro user_op.out 
	./tiny4 user_op.out | head -1 > prg_output.txt
	./tiny ./outputs/test_if.out |head -1 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_if.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_for.micro"
	bash runme ./inputs/test_for.micro user_op.out 
	./tiny4 user_op.out < inputs/test_for.input | head -2 > prg_output.txt
	./tiny ./outputs/test_for.out < inputs/test_for.input |head -2 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_for.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_adv.micro"
	bash runme ./inputs/test_adv.micro user_op.out 
	./tiny4 user_op.out < inputs/test_adv.input | head -2 > prg_output.txt
	./tiny ./outputs/test_adv.out < inputs/test_adv.input |head -2 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_adv.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_573.micro"
	bash runme ./inputs/test_573.micro user_op.out 
	./tiny4 user_op.out < inputs/test_573.input | head -2 > prg_output.txt
	./tiny ./outputs/test_573.out < inputs/test_573.input |head -2 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_573.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_combination.micro"
	bash runme ./inputs/test_combination.micro user_op.out 
	./tiny4 user_op.out | head -1 > prg_output.txt
	./tiny ./outputs/test_combination.out |head -1 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_combination.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_complex.micro"
	bash runme ./inputs/test_complex.micro user_op.out 
	./tiny4 user_op.out | head -5 > prg_output.txt
	./tiny ./outputs/test_complex.out |head -5 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_complex.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_expr.micro"
	bash runme ./inputs/test_expr.micro user_op.out 
	./tiny4 user_op.out | head -21 > prg_output.txt
	./tiny ./outputs/test_expr.out |head -21 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_expr.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_mult.micro"
	bash runme ./inputs/test_mult.micro user_op.out 
	./tiny4 user_op.out < inputs/test_mult.input | head -4 > prg_output.txt
	./tiny ./outputs/test_mult.out < inputs/test_mult.input |head -4 > exp_output.txt
	echo ""
	echo "User Output"
	cat prg_output.txt
	echo "Expected Output"
	cat exp_output.txt
	diff prg_output.txt exp_output.txt  
	if [ $? -ne 0 ]
	then  
		echo "Test failed. Incorrect output / output format for test_mult.out"
		echo ""
	else
		echo "Test passed."
		echo ""
	fi
fi

rm -rf user_op.out exp_output.txt prg_output.txt

#*****************************************************************************************#

echo "**************************************************************************************"
make clean
echo "If compiler gives warning during build, then -1"
echo "If make clean command doesn't work properly, then -1"