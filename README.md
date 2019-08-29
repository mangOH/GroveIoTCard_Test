# GroveIoTCard_Test

This repository contains a Legato system which is intended to be installed on a mangOH Yellow and
used to validate the functionality of the Grove IoT card.

## Build Instructions
1. Run `MANGOH_ROOT=<path to your mangOH source> mksys -t wp76xx grove_iot_card_test.sdef`
1. Run `update grove_iot_card_test.wp76xx.update 192.168.2.2`

## Test Execution Instructions
1. Run `./GroveCard.sh` and follow the prompts
1. Check test result: `PASSED/FAILED` at the end of script.
