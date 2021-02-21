import matplotlib.pyplot as plt



# Foregroud RGB color

foreground_r = 0
foreground_g = 0
foreground_b = 100

plt.imshow([[(foreground_r,foreground_g,foreground_b)]])

plt.show()


# Background RGB color


background_r = 120
background_g = 0
background_b = 0

plt.imshow([[(background_r,background_g,background_b)]])

plt.show()





# Picking alpha blending value
alpha_value = 0.1



new_r = (foreground_r) + (background_r*alpha_value*(1-alpha_value)/alpha_value)
new_g = (foreground_g) + (background_g*alpha_value*(1-alpha_value)/alpha_value)
new_b = (foreground_b) + (background_b*alpha_value*(1-alpha_value)/alpha_value)

    


print("\n\nBlended with alpha value:", alpha_value)





plt.imshow([[(int(new_r),int(new_g),int(new_b))]])

plt.show()

