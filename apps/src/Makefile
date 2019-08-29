TARGETS := $(MAKECMDGOALS)

.PHONY: all $(TARGETS)
all: $(TARGETS)

$(TARGETS):
	mkapp -t $@ \
		GroveGPIO/GroveGPIO.adef

	mkapp -C -D$@ -C -DINTERFACE_IOT0 -t $@ \
		ledmatrix/LedMatrix.adef

	mkapp -t $@ \
		fingerprint/FingerPrint.adef

	mkapp -t $@ \
		lightSensor/lightSensor.adef


clean:
	rm -rf _build_* *.update

