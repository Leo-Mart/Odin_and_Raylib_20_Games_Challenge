package flappy_bird

import rl "vendor:raylib"

main :: proc() {
	obstacle_speed: int
	started: bool
	bird_pos: rl.Vector2
	bird_vel: rl.Vector2

	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1280, 720, "Flappy birb")
	rl.SetTargetFPS(500)
	// ===============================
	// Init
	// ===============================
	//
	//
	// Inital starting point
	bird_pos = {f32(rl.GetScreenWidth() / 4), f32(rl.GetScreenHeight() / 2)}

	for !rl.WindowShouldClose() {


		// ===============================
		// Update each new frame
		// ===============================
		// Gravity
		bird_vel.y += 500 * rl.GetFrameTime()

		if rl.IsKeyPressed(.SPACE) {
			bird_vel.y = -300
		}

		bird_pos += bird_vel * rl.GetFrameTime()


		// ===============================
		// Draw the new frame
		// ===============================
		rl.BeginDrawing()
		rl.ClearBackground({150, 190, 220, 255})

		rl.DrawCircleV(bird_pos, 32, rl.RED)

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
