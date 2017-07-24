extends ProgressBar

################################################################################
#	DynamicBar
# A representation and partial dataholder for stuff like Health bars
################################################################################


# Exported values
export(float, 0, 5, 0.1) var SLIDE_DURATION = 0.5
export(float, 0, 5, 0.1) var DELAY_DURATION = 1.0

# Instance members
onready var SlideAnim = Tween.new() # A Tween that serves for the progress sliding animation

# "Private" members
var limit_value = 1

######################
### Core functions ###
######################
func _ready():
	SlideAnim.set_name("SlideAnim")
	add_child(SlideAnim)

func _play_anim(target):
	SlideAnim.interpolate_method(target, "set_value", target.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()

func _reset_anim():
	SlideAnim.reset_all()
	SlideAnim.remove_all()
	SlideAnim.set_repeat(false)

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "DynamicBar"

func is_type(type):
	return type == get_type()

func update(value):
	value = value if (value < limit_value) else limit_value
	set_value(value)

func set_limit_value(value):
	limit_value = value
