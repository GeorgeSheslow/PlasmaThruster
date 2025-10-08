import serial


class ThrusterInterface:
    def __init__(self, serial_port: str, logging: bool = False):
        self.comm = serial.Serial(
            port=serial_port,
            baudrate=115200,
            bytesize=8,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=0.05,
        )
        self.ping_msg = b"\x80"
        self.fire_msg = b"\x81"
        self.trigger_fire_msg = b"\x82"
        self.trigger_test_msg = b"\x83"
        self.trigger_charge_msg = b"\x84"
        self.main_cap_charge_msg = b"\x85"
        self.charge_rst_msg = b"\x86"

        self.read_trigger_duration_msg = b"\x21"
        self.read_trigger_resistance_msg = b"\x22"
        self.read_main_cap_resistance_msg = b"\x23"

        self.set_trigger_duration_msg = b"\x41"
        self.set_trig_resistance_msg = b"\x42"
        self.set_main_cap_resistance_msg = b"\x43"

        # TODO: Add logging

    # def __del__(self):
    #     try:
    #         self.comm.close()
    #     except serial.SerialException as e:
    #         print(f"Error: {e}")

    def send_msg(self, cmd_id: bytes, ret_val: bytes):
        try:
            self.comm.write(cmd_id)
        except serial.SerialException as e:
            print(f"Error: {e}")

        try:
            received_data = self.comm.read(2)
        except serial.SerialException as e:
            print(f"Error: {e}")

        # received too many bytes
        if len(received_data) > 1:
            print(f"Received too many bytes: {received_data}")
            return False
        if len(received_data) == 0:
            print("No data received within timeout.")
            return False
        if ret_val == None:
            print("Command ", cmd_id, " successful, received value:", received_data)
            return received_data
        if received_data == ret_val:
            print("Command ", cmd_id, " successful")
            return True
        else:
            print("Command failed, expected ", ret_val, " but received ", received_data)
            return False

    def ping(self):
        return self.send_msg(self.ping_msg, b"\xa0")

    def fire(self):
        self.charge_reset()
        return self.send_msg(self.fire_msg, b"\xa1")

    def trigger_fire(self):
        self.charge_reset()
        return self.send_msg(self.trigger_fire_msg, b"\xa2")

    def trigger_test(self):
        return self.send_msg(self.trigger_test_msg, b"\xa3")

    def trigger_charge(self):
        self.charge_reset()
        return self.send_msg(self.trigger_charge_msg, b"\xa4")

    def main_cap_charge(self):
        self.charge_reset()
        return self.send_msg(self.main_cap_charge_msg, b"\xa5")

    def charge_reset(self):
        return self.send_msg(self.charge_rst_msg, b"\xa6")

    def read_trigger_duration(self):
        return self.send_msg(self.read_trigger_duration_msg, None)

    def read_trigger_resistance(self):
        return self.send_msg(self.read_trigger_resistance_msg, None)

    def read_main_cap_resistance(self):
        return self.send_msg(self.read_main_cap_resistance_msg, None)

    def set_trigger_duration(self, duration):
        # ensure duration is less than 255
        if duration > 255:
            print("Duration must be less than 255")
            print("Setting duration to 255")
            duration = 255
        status = self.send_msg(self.set_trigger_duration_msg, b"\xbb")
        if status == True:
            return self.send_msg(duration.to_bytes(1, "big"), b"\xc1")
        else:
            return False

    def set_trigger_voltage(self, voltage):
        resistance = 0.98 * 10 * (40200 / (voltage + 0.7))
        print("calculated resistance: ", resistance)
        val = int(((resistance - 60) / 10000) * 256)
        print("calculated val: ", val)
        status = self.send_msg(self.set_trig_resistance_msg, b"\xbb")
        if status == True:
            return self.send_msg(val.to_bytes(1, "big"), b"\xc2")
        else:
            return False

    def set_main_cap_voltage(self, voltage):
        resistance = 0.98 * 10 * (40200 / (voltage + 0.7))
        print("calculated resistance: ", resistance)
        val = int(((resistance - 60) / 10000) * 256)
        print("calculated val: ", val)
        status = self.send_msg(self.set_main_cap_resistance_msg, b"\xbb")
        if status == True:
            return self.send_msg(val.to_bytes(1, "big"), b"\xc3")
        else:
            return False
