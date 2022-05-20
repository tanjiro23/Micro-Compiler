#!/bin/bash

g++-11 tinyNew.c -o tiny

#*****************************************************************************************#

echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing step4_testcase.micro"
	bash runme ./inputs/step4_testcase.micro user_op.out 
	./tiny user_op.out < ./inputs/step4_testcase.input | head -1 > prg_output.txt
	./tiny ./outputs/step4_testcase.out < ./inputs/step4_testcase.input |head -1 > exp_output.txt
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

echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing step4_testcase2.micro"
	bash runme ./inputs/step4_testcase2.micro user_op.out
	./tiny user_op.out | head -1 > prg_output.txt
	./tiny ./outputs/step4_testcase2.out |head -1 > exp_output.txt
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

echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_adv.micro"
	bash runme ./inputs/test_adv.micro user_op.out
	./tiny user_op.out < ./inputs/test_adv.input | head -3 > prg_output.txt
	./tiny ./outputs/test_adv.out < ./inputs/test_adv.input |head -3 > exp_output.txt
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

echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_573.micro"
	bash runme ./inputs/test_573.micro user_op.out
	./tiny user_op.out < ./inputs/test_573.input | head -3 > prg_output.txt
	./tiny ./outputs/test_573.out < ./inputs/test_573.input |head -3 > exp_output.txt
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

echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_if.micro"
	bash runme ./inputs/test_if.micro user_op.out
	./tiny user_op.out | head -1 > prg_output.txt
	./tiny ./outputs/test_if.out |head -1 > exp_output.txt
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

echo "[*] make compiler"
make compiler
if [ $? -ne 0 ]
then
	echo "Test failed. Error in building compiler."
else
	echo "Testing test_for.micro"
	bash runme ./inputs/test_for.micro user_op.out
	./tiny user_op.out < ./inputs/test_for.input | head -2 > prg_output.txt
	./tiny ./outputs/test_for.out < ./inputs/test_for.input |head -2 > exp_output.txt
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
make clean




