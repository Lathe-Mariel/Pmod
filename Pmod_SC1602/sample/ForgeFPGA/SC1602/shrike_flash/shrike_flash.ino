#include "Shrike.h"

ShrikeFlash shrike;

void setup() {
  Serial.begin(115200);
  while (!Serial && millis() < 3000);

  shrike.begin();
  shrike.flash("/FPGA_bitstream_MCU.bin"); // replace with your file name
}

void loop() {
  // Empty loop - nothing to do
}


