package flappy_bird

import "core:fmt"
import rl "vendor:raylib"

OBSTACLE_SPEED :: 300
BASE_JUMP_SPEED :: 300
BASE_GRAVITY :: 500

started: bool
bird_pos: rl.Vector2
bird_vel: rl.Vector2

score: int
game_over: bool

obstacle: rl.Rectangle
obstacle_vel: rl.Vector2

restart :: proc() {
	bird_pos = {f32(rl.GetScreenWidth() / 4), f32(rl.GetScreenHeight() / 2)}
	obstacle = rl.Rectangle({f32(rl.GetScreenWidth() - 50), 0, 100, 300})
	game_over = false
	score = 0
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1280, 720, "Flappy birb")
	rl.SetTargetFPS(500)
	// ===============================
	// Init
	// ===============================
	// Inital starting point
	bird_pos = {f32(rl.GetScreenWidth() / 4), f32(rl.GetScreenHeight() / 2)}

	obstacle = rl.Rectangle({f32(rl.GetScreenWidth() - 50), 0, 100, 300})

	for !rl.WindowShouldClose() {
		// ===============================
		// Update each new frame
		// ===============================
		//
		//
		if !started {
			if rl.IsKeyPressed(.SPACE) {
				started = true
				restart()
			}
		} else if game_over && rl.IsKeyPressed(.SPACE) {
			restart()
		}

		// Gravity
		bird_vel.y += BASE_GRAVITY * rl.GetFrameTime()

		// obstacle velocity
		obstacle_vel.x = OBSTACLE_SPEED

		// Jump
		if rl.IsKeyPressed(.SPACE) {
			bird_vel.y = -BASE_JUMP_SPEED
		}

		// restart the game if the player goes under the "floor"
		if bird_pos.y > f32(rl.GetScreenHeight() + 32) {
			game_over = true
		}

		// add obstacles spawning in from the right, moving towards the left.
		// If they collide with the player, it is game over
		// If the player passes them, they should get score. A collider box that extends upwards/downwards from the obstacle, when the player collides with it, award point?
		// Although, would that give some false positives? Like they collide with an obstacle and still get a point while getting game over?
		// Make the score collider thinner? Award point when exiting the collider?
		//
		// Spawn in new obstacles, put them into an array. When they "slide off" the left side. Despawn them and either delete them, or put them back into rotation.


		// Add a game over screen that lets player see the score they got. Press space to reset and play again.
		// Add a highscore/leaderboard here as well, track between sessions and show the highest score.


		// background art? player art?
		// Parallax scroll the background?

		if started {

			// update player sprite
			bird_pos += bird_vel * rl.GetFrameTime()

			// update the obstacle movements
			obstacle.x -= obstacle_vel.x * rl.GetFrameTime()

			if rl.CheckCollisionCircleRec(bird_pos, 32, obstacle) {
				game_over = true
				bird_vel = 0
				obstacle_vel = 0
			}

			if obstacle.x < 0 {
				obstacle.x = f32(rl.GetScreenWidth() - 50)
			}
		}


		// ===============================
		// Draw the new frame
		// ===============================
		rl.BeginDrawing()
		rl.ClearBackground({150, 190, 220, 255})

		rl.DrawCircleV(bird_pos, 32, rl.RED)
		rl.DrawRectangleRec(obstacle, rl.DARKPURPLE)

		if game_over {
			started = false
			text := fmt.ctprintf("Score: %v. Play again? Press: SPACE", score)
			text_width := rl.MeasureText(text, 15)
			rl.DrawText(
				text,
				rl.GetScreenWidth() / 2 - text_width / 2,
				rl.GetScreenHeight() / 2,
				15,
				rl.WHITE,
			)
		} else if !started {
			text := fmt.ctprintf("Press: SPACE to start playing")
			text_width := rl.MeasureText(text, 15)
			rl.DrawText(
				text,
				rl.GetScreenWidth() / 2 - text_width / 2,
				rl.GetScreenHeight() / 2,
				15,
				rl.WHITE,
			)
		}


		rl.EndDrawing()
	}

	rl.CloseWindow()
}
