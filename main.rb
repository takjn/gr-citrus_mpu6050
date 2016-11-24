#!mruby

# MPU-6050 Example Sketch
# based on  http://playground.arduino.cc/Main/MPU-6050

@ADDRESS = 0x68 # I2C address of the MPU-6050

usb = Serial.new(0)
i2c2 = I2c.new(0)

# Setup
i2c2.begin(@ADDRESS)
i2c2.lwrite(0x6B) # PWR_MGMT_1 register
i2c2.lwrite(0x00) # set to zero (wakes up the MPU-6050)
i2c2.end()

def convert_int(value)
	if value > 32767
		value -= 65536
	end
	value
end

100.times do
    
    i2c2.begin(@ADDRESS)
    i2c2.lwrite(0x3B) # starting with register 0x3B (ACCEL_XOUT_H)
    i2c2.end(1)
    i2c2.request(@ADDRESS, 14)  # request a total of 14 registers

    AcX = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
    AcY = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
    AcZ = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
    Tmp = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
    GyX = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
    GyY = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
    GyZ = convert_int(i2c2.lread() << 8 | i2c2.lread())  # 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)

    usb.print("AcX = #{AcX}")
    usb.print(" | AcY = #{AcY}")
    usb.print(" | AcZ = #{AcZ}")
    usb.print(" | Tmp = #{(Tmp/340.00+36.53)}") #equation for temperature in degrees C from datasheet
    usb.print(" | GyX = #{GyX}")
    usb.print(" | GyY = #{GyY}")
    usb.println(" | GyZ = #{GyZ}")

    delay 100
end
