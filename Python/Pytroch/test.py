import torch

x = torch.tensor([1, 1, 1, 1, 1], dtype=torch.float, requires_grad=True)
y = x * 2
grads = torch.FloatTensor([1, 2, 3, 4, 5])
y.backward(grads)  #如果y是scalar的话，那么直接y.backward()，然后通过x.grad方式，就可以得到var的梯度
x.grad  #如果y不是scalar，那么只能通过传参的方式给x指定梯度
print(y)