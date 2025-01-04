#!/bin/bash

# Terminal size
width=40
height=20

# Snake position and movement
snake=()
snake_length=5
head_x=$((width / 4))
head_y=$((height / 2))

# Initialize snake body
for ((i=0; i<$snake_length; i++)); do
    snake[$i]="$head_x,$head_y"
done

# Food position
food_x=$((RANDOM % width))
food_y=$((RANDOM % height))

# Initial direction (right)
dir_x=1
dir_y=0

# Clear the screen
clear_screen() {
    printf "\e[H"
}

# Draw the game
draw_game() {
    clear_screen
    # Draw top border
    for ((x=0; x<$width+2; x++)); do echo -n "#"; done
    echo ""

    # Draw game area with snake and food
    for ((y=0; y<$height; y++)); do
        for ((x=0; x<$width; x++)); do
            if [[ $x -eq 0 || $x -eq $((width - 1)) ]]; then
                echo -n "#"
            else
                snake_found=0
                for ((i=0; i<$snake_length; i++)); do
                    if [[ "${snake[$i]}" == "$x,$y" ]]; then
                        echo -n "O"
                        snake_found=1
                        break
                    fi
                done
                if [[ $snake_found -eq 0 ]]; then
                    if [[ $x -eq $food_x && $y -eq $food_y ]]; then
                        echo -n "@"
                    else
                        echo -n " "
                    fi
                fi
            fi
        done
        echo ""
    done

    # Draw bottom border
    for ((x=0; x<$width+2; x++)); do echo -n "#"; done
    echo ""
}

# Move the snake
move_snake() {
    # Add new head to snake
    head="$head_x,$head_y"
    snake=($head "${snake[@]:0:$((snake_length - 1))}")

    # Remove tail
    snake=("${snake[@]:0:$((snake_length - 1))}")
}

# Game logic
game_over=0
while [[ $game_over -eq 0 ]]; do
    draw_game

    # Control
    read -t 0.1 -n 1 key
    case $key in
        w) dir_x=0; dir_y=-1;;  # Up
        s) dir_x=0; dir_y=1;;   # Down
        a) dir_x=-1; dir_y=0;;  # Left
        d) dir_x=1; dir_y=0;;   # Right
        q) game_over=1;;         # Quit
    esac

    # Update snake's position
    head_x=$((head_x + dir_x))
    head_y=$((head_y + dir_y))

    # Check for collision with walls
    if [[ $head_x -lt 1 || $head_x -ge $width || $head_y -lt 1 || $head_y -ge $height ]]; then
        game_over=1
    fi

    # Check for collision with itself
    for ((i=1; i<$snake_length; i++)); do
        if [[ "${snake[$i]}" == "$head_x,$head_y" ]]; then
            game_over=1
            break
        fi
    done

    # Check if snake eats food
    if [[ $head_x -eq $food_x && $head_y -eq $food_y ]]; then
        snake_length=$((snake_length + 1))
        food_x=$((RANDOM % width))
        food_y=$((RANDOM % height))
    fi

    # Move the snake
    move_snake
done

clear_screen
echo "Game Over!"
