# Greeting the user
print("Welcome to the Grading App!")
# Ask for choosing the class
print("Please choose a class:")
print("1. Math")
print("2. Science")
print("3. History")
print("4. ELA")
class_choice = input("Enter the number of your class: ")
print("What would you like to do?")
print("1. View current grade")
print("2. Add new grade")
print("What kind of grade would you like to enter?")
print("1. Test (Worth 65% of your grade)")
print("2. Quiz (Worth 25% of your grade)")
print("3. Homework (Worth 5% of your grade)")
print("4. Classwork/Participitation (Worth 5% of your grade)")
grade_type = input("Enter the number of the grade type: ")
if grade_type == "1":
    weight = 65
elif grade_type == "2":
    weight = 25
elif grade_type == "3":
    weight = 5
elif grade_type == "4":
    weight = 5
else:
    weight = 0
print(f"This grade is worth {weight}% of your final grade.")
sample_grade = float(input("Enter a test grade (e.g. 87.5): "))
print(f"You entered a grade of {sample_grade}%.")