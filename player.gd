extends CharacterBody3D


const SPEED = 20.0
const JUMP_VELOCITY = 20.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_horizontal_pivot: Node3D = $CameraHorizontalPivot
@onready var camera_vertical_pivot: Node3D = $CameraHorizontalPivot/CameraVerticalPivot
@onready var camera: Camera3D = $CameraHorizontalPivot/CameraVerticalPivot/Camera
@onready var hud: Control = $HUD

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_horizontal_pivot.rotate_y(-event.relative.x * 0.0025)
			camera.rotate_x(-event.relative.y * 0.0025)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
			hud.x_rotation = rad_to_deg(camera.rotation.x)
			hud.y_rotation = rad_to_deg(camera_horizontal_pivot.rotation.y) + 180.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction := (camera_horizontal_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_pressed("strafe_left"):
		camera_vertical_pivot.rotation.z = lerp(camera_vertical_pivot.rotation.z, deg_to_rad(10), 0.2)
	elif Input.is_action_pressed("strafe_right"):
		camera_vertical_pivot.rotation.z = lerp(camera_vertical_pivot.rotation.z, deg_to_rad(-10), 0.2)
	else:
		camera_vertical_pivot.rotation.z = lerp(camera_vertical_pivot.rotation.z, 0.0, 0.2)

	move_and_slide()
