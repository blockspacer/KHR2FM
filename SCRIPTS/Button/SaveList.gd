extends ScrollContainer

# Signals
signal finished

# Paths to save images
const PATH_IMG_WORLD  = "res://ASSETS/GFX/Title/MainMenu/Save/Worlds/"
const PATH_IMG_AVATAR = "res://ASSETS/GFX/Title/MainMenu/Save/Avatars/"

# Instance members
onready var Scroll = get_node("Scroll")
onready var Slots  = get_node("Slots")

onready var save_template = get_node("Slots/Save")

######################
### Core functions ###
######################
func _ready():
	save_template.hide()
	save_template.set_text("")

func _recenter(button):
	var y = int(button.get_pos().y)
	Scroll.interpolate_method(
		self, "set_v_scroll", get_v_scroll(), y, 0.1,
		Scroll.TRANS_LINEAR, Scroll.EASE_IN
	)
	Scroll.start()

###############
### Methods ###
###############
func new_slot(cb_node, callback):
	var node = save_template.duplicate(true)
	node.add_to_group("Saves")
	node.connect("focus_enter", self, "_recenter", [node])
	node.connect("pressed", cb_node, callback, [node])

	node.show()
	Slots.add_child(node)
	return node

func edit_slot(node, slot_data):
	# If slot_data is null, create an empty slot_data
	if slot_data == null:
		slot_data = {
			lv         = "",
			playtime   = "",
			location   = "",
			difficulty = "",
			img_world  = "",
			img_avatar = ""
		}

	# Setting text labels
	node.get_node("LV").set_text(slot_data.lv)
	node.get_node("Difficulty").set_text(slot_data.difficulty)
	node.get_node("Location").set_text(slot_data.location)
	node.get_node("Playtime").set_text(slot_data.playtime)

	# Setting images
	var img = File.new()
	var path_world = PATH_IMG_WORLD + slot_data.img_world + ".png"
	if img.file_exists(path_world):
		node.get_node("World").set_texture(load(path_world))

	var path_avatar = PATH_IMG_AVATAR + slot_data.img_avatar + ".png"
	if img.file_exists(path_avatar):
		node.get_node("Avatar").set_texture(load(path_avatar))

func fetch_saves(cb_node, callback):
	for filename in SaveManager.get_save_list():
		var slot_idx = int(filename)
		var data = SaveManager.get_save(slot_idx)
		if data.empty(): # Save file doesn't exist (only happens in debug)
			continue

		var node = new_slot(cb_node, callback)
		node.set_name(filename)

		# Populating button with information
		var hrs    = String(data.playtime_hrs if data.playtime_hrs != null else 0).pad_zeros(2)
		var mins   = String(data.playtime_min if data.playtime_min != null else 0).pad_zeros(2)

		var slot_data = {
			lv         = tr("LEVEL") + "." + String(data.lv if data.lv != null else 0),
			playtime   = hrs + ":" + mins,
			location   = data.location   if data.location != null   else "null",
			difficulty = data.difficulty if data.difficulty != null else "null",
			img_world  = data.world.to_lower()  if data.world != null  else "",
			img_avatar = data.avatar.to_lower() if data.avatar != null else "",
		}

		edit_slot(node, slot_data)

	emit_signal("finished")

# Free all instanced save nodes
func cleanup():
	get_tree().call_group(0, "Saves", "queue_free")
