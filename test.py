import time
from datetime import datetime

a = 0
with open("time_log.txt", "a") as file:
    while True:
        a+=1
        print(a)
        time.sleep(2)
