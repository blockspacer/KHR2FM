extends "res://GAME/SCRIPTS/Battle/Battler.gd"

# Holds eligible Animation names at initialization time
export(StringArray) var actions_holder

var ActionAnims = []
# Array where our rules will be held
var RuleSet = []

######################
### Core functions ###
######################
func _ready():
	add_to_group("Enemies")

	# Adding Timer
	create_timer(0.5, false)
	Data.timer.connect("timeout", self, "_test_rules")
	Data.timer.start()

func _fixed_process(delta):
	pass

# Tests for any added rules given
func _test_rules():
	for rule in RuleSet:
		if rule.test.callv("call_func", rule.args1):
			rule.result.callv("call_func", rule.args2)
			RuleSet.erase(rule)
			return true

######################
###     Rules      ###
######################
# FIXME: These will be gone after the existence of lambda functions
func HP_less_than(value):
	return get_HP() < value

###############
### Methods ###
###############

################################################################################
#	Rules
# A rule contains the following elements:
# test   : The Boolean function to test, a.k.a. condition
# args1  : Array of Variants to send to the function above
# result : The function to run when the condition set above has been met
# args2  : Array of Variants to send to the function above
################################################################################
func add_rule(test_func, test_args, result_func, result_args):
	if ( # Adding checks is REALLY important here so as to not screw up
	   typeof(test_func) == TYPE_OBJECT && test_func.is_type("FuncRef")
	&& typeof(result_func) == TYPE_OBJECT && result_func.is_type("FuncRef")
	&& typeof(test_args) == TYPE_ARRAY && typeof(result_args) == TYPE_ARRAY
	):
		var rule = {}
		rule.test = test_func
		rule.args1 = test_args
		rule.result = result_func
		rule.args2 = result_args
		RuleSet.push_back(rule)
