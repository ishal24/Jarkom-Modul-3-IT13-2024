import matplotlib.pyplot as plt

num_worker = ['3', '2', '1']
rps_values = [4453.97, 4103.12, 4286.46]

plt.plot(num_worker, rps_values, color='blue', marker='o')

plt.xlabel('Number of worker')
plt.ylabel('Requests per Second')
plt.title('Average Requests per Second for Different numbers of worker')

plt.ylim(4000, 4500)

plt.grid(True)

plt.show()
