extends AnimatorDevice
class_name GuiMapAnimator
"""
goal is
	I receive correct data
	I animate it correctly on a GuiMap device (the screen where you see two people being animated you know)
"""

var anim_speed
var tilemap
var tween

var block : ColorRect = ColorRect.new()  #should give me a scene i will use to generate my beautiful blocks on your input
onready var blocks = $blocks

func _init(T : TileMap = TileMap.new(), t : Tween = Tween.new()):
	tilemap = T
	tween = t
	tween.set_active(true)



func FromAtoB( actor , A : Vector2, B : Vector2):
	var dist = (A - B).length()
	tween.start()
	tween.interpolate_property(actor,
			"position",
			tilemap.map_to_world(A),
			tilemap.map_to_world(B),
			dist/anim_speed,
			Tween.TRANS_BOUNCE,
			Tween.EASE_OUT)


func block_appear(blocks_pos : Array, color := Color.blue):
	#make blocks appear at specified pos
	var b = block
#	b.visble = true
	b.color = color
	b.rect_size = tilemap.cell_size*0.90
	
	for pos in blocks_pos:
		b.rect_position = tilemap.map_to_world(pos)
		blocks.add_child(b.duplicate(true))

func block_disappear():
	for b in blocks.get_children(): b.queue_free()

