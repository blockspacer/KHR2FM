extends "MapEvent.gd"

var path_save = "res://SCENES/Pause/SavePoint.tscn"

func _interacted():
	SceneLoader.load_scene(path_save, SceneLoader.BACKGROUND)
	var scene = SceneLoader.show_scene(path_save)
	scene.get_child(0).connect("hide", SceneLoader, "erase_scene", [scene])
