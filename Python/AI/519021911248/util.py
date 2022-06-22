class Stack:
    def __init__(self):
        self._list = []

    def push(self, item):
        self._list.append(item)

    def pop(self):
        return self._list.pop()

    def is_empty(self):
        return len(self._list)==0
    
    def x(self):
        print (self._list[0])
   

class Queue:
    def __init__(self):
        self._list = []

    def push(self, item):
        self._list.append(item)

    def pop(self):
        return self._list.pop(0)


    def is_empty(self):
        return len(self._list) ==0