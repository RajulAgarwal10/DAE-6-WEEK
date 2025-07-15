# Grading App Improved Version

# Data storage
grades = {
    "1": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
    "2": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
    "3": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
    "4": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
}

category_weights = {
    "Test": 65,
    "Quiz": 25,
    "Homework": 5,
    "Classwork": 5
}

def start_menu():
    while True:
        print("\nPlease choose an option:")
        print("1. Start")
        print("2. Exit")
        choice = input("Enter 1 to start or 2 to exit: ").strip()
        if choice == "1":
            return
        elif choice == "2":
            print("Goodbye! Have a great day.")
            exit()
        else:
            print("Invalid input. Please try again.")

def get_user_info():
    while True:
        name = input("\nWhat's your name? ").strip()
        teacher = input("Who's your class teacher? ").strip()
        if name and teacher:
            return name, teacher
        else:
            print("Please enter valid names for both fields.")

def select_class():
    classes = {
        "1": "Math",
        "2": "Science",
        "3": "History",
        "4": "ELA"
    }
    while True:
        print("\nPlease choose a class:")
        for key, val in classes.items():
            print(f"{key}. {val}")
        choice = input("Enter the number of your class: ").strip()
        if choice in classes:
            return choice, classes[choice]
        else:
            print("That class number is not on the list. Try again.")

def action_menu():
    print("\nWhat would you like to do?")
    print("1. View current grade")
    print("2. Add new grade")
    print("3. Change class")
    print("4. Exit program")
    while True:
        choice = input("Enter the number of your action: ").strip()
        if choice in ["1", "2", "3", "4"]:
            return choice
        else:
            print("Invalid input. Please try again.")

def add_grade(class_choice):
    grade_types = {
        "1": ("Test", 65),
        "2": ("Quiz", 25),
        "3": ("Homework", 5),
        "4": ("Classwork", 5)
    }
    while True:
        print("\nWhat kind of grade would you like to enter?")
        for key, (name, weight) in grade_types.items():
            print(f"{key}. {name} (Worth {weight}% of your grade)")
        gtype = input("Enter the number of the grade type: ").strip()
        if gtype in grade_types:
            category, weight = grade_types[gtype]
            break
        else:
            print("Invalid grade type. Try again.")

    while True:
        try:
            grade = float(input("Enter the grade (0 to 100): ").strip())
            if 0 <= grade <= 100:
                break
            else:
                print("Grade must be between 0 and 100. Try again.")
        except ValueError:
            print("Invalid input. Enter a number between 0 and 100.")

    grades[class_choice][category].append(grade)
    print(f"Grade of {grade} added as {category} for class {class_choice}.")

def view_grades(class_choice, student_name):
    print(f"\nCalculating grades for {student_name} in class {class_choice}...")
    class_data = grades[class_choice]

    total_weighted = 0
    total_weights_used = 0

    for category, grade_list in class_data.items():
        if grade_list:
            avg = sum(grade_list) / len(grade_list)
            weight = category_weights[category]
            weighted_score = avg * (weight / 100)
            total_weighted += weighted_score
            total_weights_used += weight
            print(f"- {category} Average: {avg:.2f}% (Weight: {weight}%)")
        else:
            print(f"- {category} has no grades yet.")

    if total_weights_used > 0:
        # Weighted average based only on categories with grades entered
        final_grade = (total_weighted / total_weights_used) * 100
        print(f"\nOverall grade: {final_grade:.2f}%")
    else:
        print("\nNo grades entered yet. Please add grades to see a total.")

def main():
    start_menu()
    student_name, teacher_name = get_user_info()
    print(f"\nHello, {student_name}! Let's get started with your grading for {teacher_name}'s class.\n")

    class_choice, class_name = select_class()

    while True:
        action = action_menu()

        if action == "1":
            view_grades(class_choice, student_name)
        elif action == "2":
            add_grade(class_choice)
        elif action == "3":
            class_choice, class_name = select_class()
        elif action == "4":
            print("Goodbye!")
            break

if __name__ == "__main__":
    main()