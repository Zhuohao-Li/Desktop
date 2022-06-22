'''
print("a")
print("b")

print("----------")
print("a",end=" ")
print("b",end=" ")
'''

'''
import sys
print('================Python import mode==========================')
print ('命令行参数为:')
for i in sys.argv:
    print (i)
print ('\n python 路径为',sys.path)
'''

'''
for a in range(10,20):
    print(a, end=',')
'''

'''

sites=["google","apple","wiki","instagram","twitter","youtube",'huawei',"linu"]
for site in sites:
    if len(site)!=4:
        continue
    print(f"hello,{site}")
    if site=="youtube":
        #break
        print("done")

'''


'''
for i in [1,0,-1]:
    print(f'{i+1=}' ,end=",")
'''

'''
list = [1,2,3,4]
it = iter(list)
print (next(it))
print(next(it))

'''



# def max(a,b):
#     if a>b:
#         return a
#     else:
#         return b


# print(max(1,2))


# def hello():
#     print("FUCK YOU")

# hello()



