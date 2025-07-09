import time
import random

def countdown():
    print("\nGet ready!")
    for i in range(3, 0, -1):
        print(i)
        time.sleep(1)
    print("Go!\n")

def player_turn(reaction_window):
    countdown()
    start = time.time()
    input("Press Enter NOW!")
    reaction_time = time.time() - start
    print(f"Your reaction time: {reaction_time:.3f} seconds")

    # Player hits if their reaction time is within the window
    if reaction_time <= reaction_window:
        print("You HIT the ball!")
        return True
    else:
        print("You MISSED the ball!")
        return False

def computer_turn(difficulty):
    # Higher difficulty means better chance to hit (0.5 to 0.95)
    hit_chance = min(0.5 + difficulty * 0.05, 0.95)
    print("\nComputer's turn...")
    time.sleep(random.uniform(0.5, 1.5))
    if random.random() < hit_chance:
        print("Computer HIT the ball!")
        return True
    else:
        print("Computer MISSED the ball!")
        return False

print("🏓 Welcome to Reaction Ping Pong!")
player_name = input("What's your name? ")
print(f"Hi {player_name}, get ready to play against the computer!")
input("Press Enter to serve...")

player_score = 0
computer_score = 0
winning_score = 8

reaction_window = 1.0  # start allowing 1 second reaction time
difficulty = 0

while player_score < winning_score and computer_score < winning_score:
    print(f"\nCurrent reaction window: {reaction_window:.3f} seconds")
    
    # Player's turn to react
    if player_turn(reaction_window):
        player_score += 1
    else:
        computer_score += 1  # If player misses, computer scores

    print(f"Score - {player_name}: {player_score} | Computer: {computer_score}")

    # Check if someone has won
    if player_score >= winning_score or computer_score >= winning_score:
        break

    # Computer's turn to react
    if computer_turn(difficulty):
        computer_score += 1  # Computer scores if it hits
    else:
        player_score += 1  # Player scores if computer misses

    print(f"Score - {player_name}: {player_score} | Computer: {computer_score}")

    # Increase difficulty: shrink reaction window and raise difficulty counter every 2 total points
    total_points = player_score + computer_score
    if total_points > 0 and total_points % 2 == 0:
        reaction_window = max(0.3, reaction_window * 0.85)  # shrink window, but not less than 0.3s
        difficulty += 1
        print(f"Difficulty increased! Reaction window now {reaction_window:.3f} seconds.")

# Declare winner
if player_score >= winning_score:
    print(f"\n🏆 {player_name} wins the game with {player_score} points! 🎉")
else:
    print(f"\n🏆 Computer wins the game with {computer_score} points! 😎")
