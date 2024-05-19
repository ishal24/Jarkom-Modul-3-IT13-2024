import matplotlib.pyplot as plt

algorithms = ['Round Robin', 'Least Connection', 'IP Hash', 'Generic Hash']
rps_values = [3310.74, 3316.01, 3328.74, 3323.71]

plt.plot(algorithms, rps_values, color='blue', marker='o')

plt.xlabel('Load Balancing Algorithm')
plt.ylabel('Requests per Second')
plt.title('Average Requests per Second for Different Load Balancing Algorithms')

plt.ylim(3300, 3350)

plt.grid(True)

plt.show()
