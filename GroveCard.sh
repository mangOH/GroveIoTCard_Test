#!/bin/bash
# Disable colors if stdout is not a tty
if [ -t 1 ]; then
	COLOR_TITLE="\\033[1;94m"
	COLOR_ERROR="\\033[0;31m"
	COLOR_WARN="\\033[0;93m"
	COLOR_PASS="\\033[0;32m"
	COLOR_RESET="\\033[0m"
else
	COLOR_TITLE=""
	COLOR_ERROR=""
	COLOR_WARN=""
	COLOR_PASS=""
	COLOR_RESET=""
fi

# testing variables
TEST_RESULT="p"

# Configuration loading
source ./configuration.cfg

# Libraries poll
source ./lib/common.sh

target_setup() {
    prompt_char "
Connect the following to the Grove IoT card:\n
  A0: light sensor\n
  D2: red led\n
  D3: green led\n
  D4: blue led\n
  D5: white led\n
  UART: fingerprint sensor\n
  I2C: led matrix\n
\n
Press ENTER to continue..."

	WaitForDevice "Up" "$rbTimer"

	# create test folder
	echo -e "${COLOR_TITLE}Creating testing folder${COLOR_RESET}"
	SshToTarget "mkdir -p /tmp/iot_grove_card/apps"

	# default state
	target_default_state

	return 0
}

#=== FUNCTION ==================================================================
#
#        NAME: prompt_char
# DESCRIPTION: Request user to input a character for prompt
# PARAMETER 1: prompt message
#
#     RETURNS: user inputed value
#
#===============================================================================
prompt_char() {
	echo -e $1 >&2
	read prompt_input
	echo $(echo $prompt_input | tr 'a-z' 'A-Z')
}

target_default_state() {
	# GPIO
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 0 output low"
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 1 output low"
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 2 output low"
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 3 output low"

	# Led Matrix
	SshToTarget "/legato/systems/current/bin/app runProc LedMatrix --exe=LedMatrix -- red string \" \""

	# FingerPrint
	# Do nothing
	return 0
}

#=== FUNCTION ==================================================================
#
#        NAME: numCompare
# DESCRIPTION: Compare two number
# PARAMETER 1: number1
# PARAMETER 2: number2
#
#    RETURNS: 0 number1 is less than number2 + 100
#             1 number1 is greater than number2 + 100
#
#===============================================================================
numCompare() {
	local res=$(awk -v n1="$1" -v n2="$2" -v res="0" 'BEGIN {print (n1>n2+100?"1":"0") }')
	return $res
}

magic_P() {
	while true
	do
		lightSensor=$(SshToTarget "/legato/systems/current/bin/app runProc lightSensor --exe=lightSensor --")
		# echo "$lightSensor"
		# color=""
		if [[ $lightSensor -gt 1700 ]]
		then
			color="red"
		else
			if [[ $lightSensor -gt 1300 ]]
			then
				color="green"
			else
				if [[ $lightSensor -gt 900 ]]
				then
					color="blue"
				else
					if [[ $lightSensor -gt 500 ]]
					then
						color="pink"
					else
						color="white"
					fi
				fi
			fi
		fi
		SshToTarget "/legato/systems/current/bin/app runProc LedMatrix --exe=LedMatrix -- $color string P"
	done
}

target_start_test() {
	# GPIO D2
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 0 output high"
	local resp=""
	while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
	do
		local resp=$(prompt_char "Do you see LED on IO D2 is turned ON? (Y/N)")
	done
	if [ "$resp" = "N" ]
	then
		echo -e "${COLOR_ERROR}Failed to turn on LED on D2. GPIO check is failed.${COLOR_RESET}"
		return 1
	else
		SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 0 output low"
		local resp=""
		while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
		do
			local resp=$(prompt_char "Do you see LED on IO D2 is turned OFF? (Y/N)")
		done
		if [ "$resp" = "N" ]
		then
			echo -e "${COLOR_ERROR}Failed to turn off LED on D2. GPIO check is failed.${COLOR_RESET}"
			return 1
		else
			echo -e "${COLOR_PASS}GPIO D2 check is passed.${COLOR_RESET}"
		fi
	fi
	# GPIO D3
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 1 output high"
	local resp=""
	while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
	do
		local resp=$(prompt_char "Do you see LED on IO D3 is turned ON? (Y/N)")
	done
	if [ "$resp" = "N" ]
	then
		echo -e "${COLOR_ERROR}Failed to turn on LED on D3. GPIO check is failed.${COLOR_RESET}"
		return 1
	else
		SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 1 output low"
		local resp=""
		while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
		do
			local resp=$(prompt_char "Do you see LED on IO D3 is turned OFF? (Y/N)")
		done
		if [ "$resp" = "N" ]
		then
			echo -e "${COLOR_ERROR}Failed to turn off LED on D3. GPIO check is failed.${COLOR_RESET}"
			return 1
		else
			echo -e "${COLOR_PASS}GPIO D3 check is passed.${COLOR_RESET}"
		fi
	fi
	# GPIO D4
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 2 output high"
	local resp=""
	while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
	do
		local resp=$(prompt_char "Do you see LED on IO D4 is turned ON? (Y/N)")
	done
	if [ "$resp" = "N" ]
	then
		echo -e "${COLOR_ERROR}Failed to turn on LED on D4. GPIO check is failed.${COLOR_RESET}"
		return 1
	else
		SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 2 output low"
		local resp=""
		while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
		do
			local resp=$(prompt_char "Do you see LED on IO D4 is turned OFF? (Y/N)")
		done
		if [ "$resp" = "N" ]
		then
			echo -e "${COLOR_ERROR}Failed to turn off LED on D4. GPIO check is failed.${COLOR_RESET}"
			return 1
		else
			echo -e "${COLOR_PASS}GPIO D4 check is passed.${COLOR_RESET}"
		fi
	fi
	# GPIO D5
	SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 3 output high"
	local resp=""
	while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
	do
		local resp=$(prompt_char "Do you see LED on IO D5 is turned ON? (Y/N)")
	done
	if [ "$resp" = "N" ]
	then
		echo -e "${COLOR_ERROR}Failed to turn on LED on D5. GPIO check is failed.${COLOR_RESET}"
		return 1
	else
		SshToTarget "/legato/systems/current/bin/app runProc GroveGPIO --exe=GroveGPIO -- -p 3 output low"
		local resp=""
		while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
		do
			local resp=$(prompt_char "Do you see LED on IO D5 is turned OFF? (Y/N)")
		done
		if [ "$resp" = "N" ]
		then
			echo -e "${COLOR_ERROR}Failed to turn off LED on D5. GPIO check is failed.${COLOR_RESET}"
			return 1
		else
			echo -e "${COLOR_PASS}GPIO D5 check is passed.${COLOR_RESET}"
		fi
	fi

	# RGB LED matrix (I2C)
	SshToTarget "/legato/systems/current/bin/app runProc LedMatrix --exe=LedMatrix -- green string P"
	local resp=""
	while [ "$resp" != "Y" ] && [ "$resp" != "N" ]
	do
		local resp=$(prompt_char "Do you see leter 'P' displayed on LED matrix? (Y/N)")
	done
	if [ "$resp" = "N" ]
	then
		echo -e "${COLOR_ERROR}Failed to display string on LED matrix. I2C check is failed.${COLOR_RESET}"
		return 1
	else
		echo -e "${COLOR_PASS}I2C check is passed.${COLOR_RESET}"
	fi

	# FingerPrint (UART)
	prompt_char "Put your finger to FingerPrint sensor then press ENTER to continue..."
	local finger_detect=$(SshToTarget "/legato/systems/current/bin/app runProc FingerPrint --exe=FingerPrint --")
	echo "$finger_detect"
	echo "$finger_detect" | grep "Image taken"
	if [ $? = 0 ]
	then
		echo -e "${COLOR_PASS}UART check is passed.${COLOR_RESET}"
	else
		echo -e "${COLOR_ERROR}Failed to take image of your finger. UART check is failed.${COLOR_RESET}"
		return 1
	fi

	# lightSensor (ADC)
	prompt_char "Please cover light sensor then press ENTER to continue..."
	cover_value=$(SshToTarget "/legato/systems/current/bin/app runProc lightSensor --exe=lightSensor --")
	echo "Light Sensor Value: '$cover_value'" >&2

	prompt_char "Please uncover light sensor then press ENTER to continue..."
	uncover_value=$(SshToTarget "/legato/systems/current/bin/app runProc lightSensor --exe=lightSensor --")
	echo "Light Sensor Value: '$uncover_value'" >&2

	numCompare $cover_value $uncover_value
	if [ $? = 0 ]
	then
		echo "Light sensor value when uncover greater than light sensor value when cover" >&2
		SshToTarget "/legato/systems/current/bin/app runProc LedMatrix --exe=LedMatrix -- green string P"
	else
		echo "Light sensor value when uncover is not greater than light sensor value when cover" >&2
		SshToTarget "/legato/systems/current/bin/app runProc LedMatrix --exe=LedMatrix -- red string F"
		return 1
	fi

	return 0
}


# main
if ! target_setup
then
	TEST_RESULT="f"
	echo -e "${COLOR_ERROR}Failed to setup target${COLOR_RESET}"
fi

if ! target_start_test
then
	TEST_RESULT="f"
	echo -e "${COLOR_ERROR}Test is failed${COLOR_RESET}"
fi

echo -e "${COLOR_TITLE}Test is finished${COLOR_RESET}"
EchoPassOrFail $TEST_RESULT
