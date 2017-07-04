extends Area2D

# Signals
signal touched
signal interacted

# Export values
export(String) var type = ""

######################
### Core functions ###
######################
func _ready():
	# Setting up
	connect("interacted", self, "_interacted")
	connect("body_enter", self, "_on_area_body_enter")
	connect("body_exit", self, "_on_area_body_exit")


func _interacted():
	pass # Called when interacted signal is emitted

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	if body.is_type("MapPlayer") && not body.has_interacting(self):
		body.add_interacting(self)


func _on_area_body_exit(body):
	if body.is_type("MapPlayer"):
		# If player entered another area this area might be wanted
		if body.has_interacting(self):
			body.erase_interacting(self)

########################
### Export functions ###
########################
func get_type():
	return type

func is_type(type):
	return type == get_type()
