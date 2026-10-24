package flappy_bird

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

OBSTACLE_SPEED :: 300
MAX_AMOUNT_OBSTACLES :: 100
OBSTACLE_WIDTH :: 150
BASE_JUMP_SPEED :: 300
BASE_GRAVITY :: 500

started: bool
bird_pos: rl.Vector2
bird_vel: rl.Vector2

score: int
game_over: bool

Obstacle :: struct {
	rec:    rl.Rectangle,
	active: bool,
}

obstacles := [MAX_AMOUNT_OBSTACLES * 2]Obstacle{}
obstaclesPos := [MAX_AMOUNT_OBSTACLES]rl.Vector2{}
got_score: bool

restart :: proc() {
	bird_pos = {f32(rl.GetScreenWidth() / 4), f32(rl.GetScreenHeight() / 2)}
	game_over = false
	score = 0
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1280, 720, "Flappy birb")
	rl.SetTargetFPS(60)

	// ===============================
	// Init
	// ===============================
	bird_pos = {f32(rl.GetScreenWidth() / 4), f32(rl.GetScreenHeight() / 2)}

	for i in 0 ..< MAX_AMOUNT_OBSTACLES {
		obstaclesPos[i].x = f32(1000 + (280 * i))
		obstaclesPos[i].y = -f32(rand.int_range(0, 120))
	}

	for i := 0; i < MAX_AMOUNT_OBSTACLES * 2; i += 2 {
		obstacles[i].rec.x = obstaclesPos[i / 2].x
		obstacles[i].rec.y = obstaclesPos[i / 2].y
		obstacles[i].rec.width = OBSTACLE_WIDTH
		obstacles[i].rec.height = 255

		obstacles[i + 1].rec.x = obstaclesPos[i / 2].x
		obstacles[i + 1].rec.y = 870 + obstaclesPos[i / 2].y - 255
		obstacles[i + 1].rec.width = OBSTACLE_WIDTH
		obstacles[i + 1].rec.height = 255

		obstacles[i / 2].active = true
	}

	for !rl.WindowShouldClose() {
		// ===============================
		// Update each new frame
		// ===============================
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

		// Jump
		if rl.IsKeyPressed(.SPACE) {
			bird_vel.y = -BASE_JUMP_SPEED
		}

		// restart the game if the player goes under the "floor"
		if bird_pos.y > f32(rl.GetScreenHeight() + 32) {
			game_over = true
		}

		// spawn new obstacles after the end has been reached
		// maybe increase difficulty at certan intervals?
		// PLay around with size/position of the obstacles and the gap between them.
		// Add a highscore/leaderboard, track between sessions and show the highest score.

		// background art? player art?
		// Parallax scroll the background?

		if started {

			// update player sprite
			bird_pos += bird_vel * rl.GetFrameTime()

			for i in 0 ..< MAX_AMOUNT_OBSTACLES {
				obstaclesPos[i].x -= OBSTACLE_SPEED * rl.GetFrameTime()
			}

			for i := 0; i < MAX_AMOUNT_OBSTACLES * 2; i += 2 {
				obstacles[i].rec.x = obstaclesPos[i / 2].x
				obstacles[i + 1].rec.x = obstaclesPos[i / 2].x
			}

			for i in 0 ..< MAX_AMOUNT_OBSTACLES * 2 {

				if rl.CheckCollisionCircleRec(bird_pos, 32, obstacles[i].rec) {
					game_over = true
				}
				if bird_pos.x > obstaclesPos[i / 2].x && obstacles[i / 2].active {
					score += 1
					obstacles[i / 2].active = false
				}
			}


		}


		// ===============================
		// Draw the new frame
		// ===============================
		rl.BeginDrawing()
		rl.ClearBackground({150, 190, 220, 255})


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


		rl.DrawCircleV(bird_pos, 32, rl.RED)

		for i in 0 ..< MAX_AMOUNT_OBSTACLES {

			rl.DrawRectangleRec(obstacles[i].rec, rl.DARKPURPLE)
		}
		score_text := fmt.ctprintf("Score: %v", score)
		rl.DrawText(score_text, 20, 20, 15, rl.WHITE)


		rl.EndDrawing()
	}

	rl.CloseWindow()
}
