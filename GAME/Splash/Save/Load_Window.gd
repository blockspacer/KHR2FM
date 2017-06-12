extends Panel

# Signals
signal error
signal finished

# Instance members
onready var anims  = get_node("Anims")

onready var List   = get_node("List")
onready var Scroll = get_node("List/Scroll")
onready var Slots  = get_node("List/Slots")

onready var Info = {
	"panel" : get_node("Info"),
	"title" : get_node("Info/Title"),
	"msg"   : get_node("Info/Message"),
}

######################
### Core functions ###
######################
func _ready():
	var save_template = Slots.get_node("Save")
	save_template.hide()
	save_template.set_text("")

	var save_list = SaveManager.get_save_list()
	var count = save_list.size()
	for i in range(0, count):
		var data = SaveManager.get_save(i)
		if data.empty(): # Save file doesn't exist (only happens in debug)
			continue

		var node = save_template.duplicate(true)
		var name = "Save " + String(i+1)

		node.set_name(name)
		node.connect("focus_enter", self, "_recenter", [node])
		node.connect("pressed", self, "_pressed_load", [i])

		# Populating button with information
		var hrs  = String(data.playtime_hrs).pad_zeros(2)
		var mins = String(data.playtime_min).pad_zeros(2)
		var location = data.location if not data.location.empty() else "null"

		node.get_node("LV").set_text("LV." + String(data.lv))
		node.get_node("Difficulty").set_text(data.difficulty)
		node.get_node("Location").set_text(data.location)
		node.get_node("Playtime").set_text(hrs + ":" + mins)

		# TODO: fill in the images of the world (saved at) and the avatar

		node.show()
		Slots.add_child(node)

	connect("draw", self, "_show_up")

#######################
### Signal routines ###
#######################
func _show_up():
	# Initial settings
	Info.panel.hide()

	# Making sure the first Option is selected
	if Slots.get_child_count() > 1:
		Slots.get_child(1).grab_focus()
	else:
		Info.msg.set_text("TITLE_SAVE_NOT_FOUND")
		if anims.is_playing():
			yield(anims, "finished")
		anims.play("Show Info")

func _recenter(button):
	var y = int(button.get_pos().y)
	Scroll.interpolate_method(
		List, "set_v_scroll", List.get_v_scroll(), y, 0.1,
		Scroll.TRANS_LINEAR, Scroll.EASE_IN
	)
	Scroll.start()

func _pressed_load(slot_idx):
	var it_loaded = SaveManager.load_game(slot_idx)
	emit_signal("finished" if it_loaded else "error")
