# Grading App Improved Version
#Importing to store grades so no disspearance after program ends
import json
import os

#Defining weights of assignments so that for example, tests are worth most of your grade as having the highest impact
category_weights = {
    "Test": 65,
    "Quiz": 25,
    "Homework": 5,
    "Classwork": 5
}

grades_file = "grades_data.json"

#This checks if the grades file exists and loads it, and if it doesn't it'll make a new dictionary for new use
def load_grades():
    if os.path.exists(grades_file):
        with open(grades_file, "r") as f:
            return json.load(f)
    else:
        return{
            "1": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
            "2": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
            "3": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
            "4": {"Test": [], "Quiz": [], "Homework": [], "Classwork": []},
        }
#This function save current grades to Json for storing grades
def save_grades(grades):
    with open(grades_file, "w") as f:
        json.dump(grades, f)
grades = load_grades()


#function for starting program, choose to start or to end program
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
#function for user information(name and teacher) Will be used to address 
def get_user_info():
    while True:
        name = input("\nWhat's your name? ").strip()
        teacher = input("Who's your class teacher? ").strip()
        if name and teacher:
            return name, teacher
        else:
            print("Please enter valid names for both fields.")
#which class to add grades to/view/change
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
#Actions menu starter(asks what action you want to take)
def action_menu():
    print("\nWhat would you like to do?")
    print("1. View current grade")
    print("2. Add new grade")
    print("3. Change class")
    print("4. Edit/Delete grades")
    print("5. Exit program")
    while True:
        choice = input("Enter the number of your action: ").strip()
        if choice in ["1", "2", "3", "4", "5"]:
            return choice
        else:
            print("Invalid input. Please try again.")
#used to add grades to your current grade
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
        grade_input = input("Enter one or more grades separated by commas (0 to 100): ").strip()
        
        if "," not in grade_input and " " not in grade_input and len(grade_input) > 3:
            print("\nDid you forget to separate grades with commas? Try again like: 85, 90, 78\n")
            continue
        
        try:
            # Split by commas, strip spaces, convert to floats
            grade_list = [float(g.strip()) for g in grade_input.split(",")]

            # Validate all grades
            if all(0 <= g <= 100 for g in grade_list):
                grades[class_choice][category].extend(grade_list)
                print(f"{len(grade_list)} grade(s) added to {category} for class {class_choice}.")
                save_grades(grades)
                break
            else:
                print("All grades must be between 0 and 100.")
        except ValueError:
            print("Invalid input. Please enter numbers separated by commas.")
#view grades for grade viewing for certain class
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
#This function enables editing and deleting already put in grades
def edit_delete_grade(class_choice):
    class_data = grades[class_choice]
    print("\nCurrent grades in each category:")
    for category, grade_list in class_data.items():
        print(f"{category.capitalize()}: {grade_list if grade_list else 'No grades yet'}")

    print("\nWhich category do you want to modify?")
    categories = list(class_data.keys())
    for i, cat in enumerate(categories, 1):
        print(f"{i}. {cat}")
    print(f"{len(categories)+1}. Delete ALL grades in a category")
    cat_choice = input("Enter number of the category: ").strip()
    if not cat_choice.isdigit():
        print("Invalid input.")
        return

    cat_index = int(cat_choice)
    if 1 <= cat_index <= len(categories):
        selected_category = categories[cat_index - 1]
    elif cat_index == len(categories) + 1:
        # Delete all grades menu
        print("\nWhich category would you like to wipe all grades from?")
        for i, cat in enumerate(categories, 1):
            print(f"{i}. {cat}")
        confirm = input("Type the number again to confirm: ").strip()
        if confirm.isdigit() and 1 <= int(confirm) <= len(categories):
            to_clear = categories[int(confirm) - 1]
            grades[class_choice][to_clear].clear()
            print(f"All grades deleted from {to_clear}.")
            save_grades(grades)
        else:
            print("Canceled or invalid choice.")
        return
    else:
        print("Invalid category.")
        return

    
    selected_category = categories[int(cat_choice)-1]
    grade_list = class_data[selected_category]
    
    if not grade_list:
        print(f"No grades in {selected_category} to edit or delete.")
        return

    print(f"\nGrades in {selected_category}:")
    for i, grade in enumerate(grade_list):
        print(f"{i+1}. {grade}")

    index = input("Enter the number of the grade to modify: ").strip()
    if not index.isdigit() or not (1 <= int(index) <= len(grade_list)):
        print("Invalid grade selection.")
        return

    index = int(index) - 1

    print("\nWhat would you like to do?")
    print("1. Edit this grade")
    print("2. Delete this grade")
    choice = input("Enter 1 or 2: ").strip()

    if choice == "1":
        try:
            new_grade = float(input("Enter the new grade (0 to 100): "))
            if 0 <= new_grade <= 100:
                old = grade_list[index]
                grade_list[index] = new_grade
                print(f"Grade {old} changed to {new_grade}.")
            else:
                print("Grade must be between 0 and 100.")
                return
        except ValueError:
            print("Invalid input.")
            return

    elif choice == "2":
        removed = grade_list.pop(index)
        print(f"Grade {removed} deleted.")
    else:
        print("Invalid choice.")
        return

    save_grades(grades)

#menu for actions repeat/ what each action does
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
            edit_delete_grade(class_choice)
        elif action == "5":
            print("Goodbye!")
            break

if __name__ == "__main__":
    main()