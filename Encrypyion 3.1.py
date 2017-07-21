__author__ = 'User'
import random
from itertools import *

def encrypt3(message,key):

    random.seed(key)

    l = range(len(message))

    random.shuffle(l)

    return "".join([message[x] for x in l])
def list_to_string(string):
    a = ""
    for i in string:
        a += i
    return a


data = "euTtSa:0 kty1h a0  nlradstara  atlot 5wtic"
test1 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnop'
test3 = []


for x in permutations('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 3): #Key will contain a different key each run
    key = list_to_string(x) # The key must be a string and not a list of strings.
    test2 = encrypt3(test1,key) # Encrypt the message
    for i in xrange(42):
        for j in xrange(42):
            if test1[i] == test2[j]:
                #data2 = data2[0:int(i)] +data[int(j)]+data2[int(i)+1:len(data)]
                test3.append(data[j])
    data2 = "".join(test3)
    test3 = []
    if data2[0:4] == 'The ':
        print data2
        print key