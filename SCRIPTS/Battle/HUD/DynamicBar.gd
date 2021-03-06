extends ProgressBar

################################################################################
#	DynamicBar
# A representation and partial dataholder for stuff like Health bars
################################################################################


# Exported values
export(float, 0, 5, 0.1) var SLIDE_DURATION = 0.5
export(float, 0, 5, 0.1) var DELAY_DURATION = 0.5

# Instance members
onready var SlideAnim = Tween.new() # A Tween that serves for the progress sliding animation

######################
### Core functions ###
######################
func _ready():
	SlideAnim.set_name("SlideAnim")
	SlideAnim.set_repeat(false)
	add_child(SlideAnim)

func _slide(target):
	SlideAnim.stop_all()
	SlideAnim.interpolate_method(target, "set_value", target.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "DynamicBar"

func is_type(type):
	return type == get_type()
