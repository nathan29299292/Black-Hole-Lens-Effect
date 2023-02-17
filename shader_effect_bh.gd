tool
extends Spatial

export(NodePath) var bh_path
var bh = null

onready var shader_eff = get_node("./shader_effect_bh")
onready var bhcam = get_node("../Viewport/Bhcam")
onready var srccam = get_node("../Src/Srccam")
onready var viewport = get_node("../Viewport")
onready var cam = get_node("../../Camera")

func _ready():
	bh = get_node(bh_path)
	viewport.size = get_viewport().size


func _process(delta):
	if bh != null:
		var distance = get_global_transform().origin.distance_to(bh.get_global_transform().origin)
		look_at(bh.get_global_transform().origin, Vector3.UP)

		var min_dist = max(distance, bh.event_horizon)

		shader_eff.scale = Vector3(min_dist, min_dist, min_dist)
		shader_eff.get_surface_material(0).set_shader_param("dist", distance)
		shader_eff.get_surface_material(0).set_shader_param("scale", bh.event_horizon)
		
		#Projects blackhole's position to the screen.
		var blackhole_p = cam.unproject_position(bh.get_global_transform().origin)

		var flip_v_x = (-cam.global_transform.basis.z).dot(-self.global_transform.basis.z)
		var flip_v_y = (-cam.global_transform.basis.y).dot(-self.global_transform.basis.y)

		print(blackhole_p)

		if flip_v_x < 0:
			blackhole_p.x = 1-clamp(blackhole_p.x/get_viewport().size.x, 0.0, 1.0)
		else:
			blackhole_p.x = clamp(blackhole_p.x/get_viewport().size.x, 0.0, 1.0)
		if flip_v_y < 0:
			blackhole_p.y = clamp(blackhole_p.y/get_viewport().size.y, 0.0, 1.0)	
		else:
			blackhole_p.y = 1-clamp(blackhole_p.y/get_viewport().size.y, 0.0, 1.0)	
		
		shader_eff.get_surface_material(0).set_shader_param("effect_origin", blackhole_p)

		bhcam.global_transform = cam.global_transform
		#bhcam.look_at(bh.get_global_transform().origin, Vector3.UP)
		bhcam.near = distance + 0.05

