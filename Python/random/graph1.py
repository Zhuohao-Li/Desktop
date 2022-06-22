# import matplotlib.pyplot as plt
# import numpy as np


# labels = ['10', '100', '1000', '10000', '100000','1000000']
# men_means = [20, 34, 30, 35, 27]
# women_means = [25, 32, 34, 20, 25]

# x = np.arange(len(labels))  # the label locations
# width = 0.35  # the width of the bars

# fig, ax = plt.subplots()
# rects1 = ax.bar(x - width/2, men_means, width, label='Men')
# rects2 = ax.bar(x + width/2, women_means, width, label='Women')

# # Add some text for labels, title and custom x-axis tick labels, etc.
# ax.set_ylabel('Scores')
# ax.set_title('Scores by group and gender')
# ax.set_xticks(x)
# ax.set_xticklabels(labels)
# ax.legend()

# ax.bar_label(rects1, padding=3)
# ax.bar_label(rects2, padding=3)

# fig.tight_layout()

# plt.show()


import matplotlib.pyplot as plt
import numpy as np


labels = ['10', '100', '1000', '10000', '100000', '1000000']
sorttime = [261.95, 300.41, 936.326, 5320.5, 57104.6, 483203]
lineartime = [241.512, 284.98, 988.525, 5521.88, 36910.3, 316389]

x = np.arange(len(labels))  # the label locations
width = 0.35  # the width of the bars

fig, ax = plt.subplots()
rects1 = ax.bar(x - width/2, sorttime, width, label='Sort')
rects2 = ax.bar(x + width/2, lineartime, width, label='Linear')

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('Time/(unit: us)')
ax.set_title('Efficiency of the 2 algorithms')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()
plt.yscale("log")

ax.bar_label(rects1, padding=3)
ax.bar_label(rects2, padding=3)

fig.tight_layout()

plt.show()
