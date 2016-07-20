extends Node

# Instance members
var Lines

######################
### Core functions ###
######################
func _exit_tree():
	close()

func _init(csv_path):
	if csv_path == null:
		return false
	elif csv_path.empty():
		return false

	var locale = TranslationServer.get_locale()
	Lines = Translation.new()
	Lines.set_locale(locale)

	var csv_file = File.new()
	csv_file.open(csv_path, csv_file.READ)

	# Iterating CSV lines
	var strarr = csv_file.get_csv_line()
	var locale_index = -1
	for id in range(strarr.size()):
		if strarr[id] == locale:
			locale_index = id

	while !csv_file.eof_reached():
		strarr = csv_file.get_csv_line()
		if 0 < locale_index && locale_index < strarr.size():
			Lines.add_message(strarr[0], strarr[locale_index])

	csv_file.close()
	csv_file = null

	# Adding translation to server
	TranslationServer.add_translation(Lines)
	return true

###############
### Methods ###
###############
func translate(lineID):
	if Lines == null:
		tr(lineID)
	return TranslationServer.translate(lineID)

func close():
	if Lines != null:
		TranslationServer.remove_translation(Lines)
		Lines = null