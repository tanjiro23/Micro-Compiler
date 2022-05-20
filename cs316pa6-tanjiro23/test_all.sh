#!/bin/bash

g++-11 -std=c++11 tinyNew.C -o tiny

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
	./tiny user_op.out < ./inputs/factorial2.input | head -2 > prg_output.txt
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
	./tiny user_op.out < ./inputs/fibonacci2.input | head -16 > prg_output.txt
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
	./tiny user_op.out < ./inputs/fma.input | head -3 > prg_output.txt
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
make clean
echo "If compiler gives warning during build, then -1"
echo "If make clean command doesn't work properly, then -1"