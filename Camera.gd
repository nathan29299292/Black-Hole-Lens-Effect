extends Camera

var speed = 1.5

func _process(delta):
	"""
	if Input.is_action_pressed('ui_up'):
		transform.origin += speed * -transform.basis.z * delta
	
	if Input.is_action_pressed('ui_down'):
		transform.origin += -speed * -transform.basis.z * delta

	if Input.is_action_pressed('ui_left'):
		transform.origin += speed * -transform.basis.x * delta
		
	if Input.is_action_pressed('ui_right'):
		transform.origin += -speed * -transform.basis.x * delta
	"""
	if Input.is_action_pressed('ui_up'):
		transform.origin += speed * Vector3.FORWARD * delta
	
	if Input.is_action_pressed('ui_down'):
		transform.origin += -speed * Vector3.FORWARD * delta


	if Input.is_action_pressed("camera_pitch_+"):
		rotate_x(PI/2 * delta)
	if Input.is_action_pressed("camera_pitch_-"):
		rotate_x(-PI/2 * delta)
	if Input.is_action_pressed("camera_yaw_+"):
		rotate_y(-PI/2 * delta)
	if Input.is_action_pressed("camera_yaw_-"):
		rotate_y(PI/2 * delta)
	if Input.is_action_pressed("camera_roll_+"):
		rotate_z(PI/2 * delta)
	if Input.is_action_pressed("camera_roll_-"):
		rotate_z(-PI/2 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				speed *= 1.05
				print(speed)
			elif event.button_index == BUTTON_WHEEL_DOWN && speed*0.05 > 0.00180:
				speed *= .05
				print(speed)
