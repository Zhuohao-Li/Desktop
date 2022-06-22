import random


def random_generate(name, num):
    desktop_path = '/Users/edith_lzh/Desktop/大三上/Algorithm/lab1'
    full_path = desktop_path + '/'+name + '.txt'
    file = open(full_path, 'w+')

    for i in range(num):
        random_number = random.randint(0, num*10)
        file.write(str(random_number)+' ')
    file.close()


random_generate('1000000', 1000000)
