#### this is the source code of Python from the web tutorial " xiaojiayu "

import random
SECRET_KEY = random.randint(1,10)
print("#######I love u########")
temp = input("guess what?")
i=0
guess = int(temp)
while guess != SECRET_KEY:

    if guess > SECRET_KEY:
        print("bigger")
    else:
        print("less")
    i=i+1
    if i>=3:
        print ("come on, you are out")
        break
    temp = input("wrong again")
    guess = int(temp)
    
    
if i<3:
    print("what the fuck?!")
    print("You are great")
print("the end")



#  tab is the soul in python
# BIF == built in  function
