extends Control

@onready var quality_option = $ScrollContainer/SettingsVBox/QualityOption
@onready var brightness_slider = $ScrollContainer/SettingsVBox/BrightnessHBox/BrightnessSlider
@onready var master_volume_slider = $ScrollContainer/SettingsVBox/MasterVolumeHBox/MasterVolumeSlider
@onready var music_volume_slider = $ScrollContainer/SettingsVBox/MusicVolumeHBox/MusicVolumeSlider
@onready var fps_option = $ScrollContainer/SettingsVBox/FPSHBox/FPSOption

func _ready() -> void:
	# Load current settings
	var settings = SettingsManager.load_settings()
	
	quality_option.selected = settings.graphics_quality
	brightness_slider.value = settings.brightness
	master_volume_slider.value = settings.master_volume
	music_volume_slider.value = settings.music_volume
	fps_option.selected = settings.target_fps

func _on_quality_changed(index: int) -> void:
	SettingsManager.set_graphics_quality(index)

func _on_brightness_changed(value: float) -> void:
	SettingsManager.set_brightness(value)

func _on_master_volume_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)

func _on_fps_changed(index: int) -> void:
	SettingsManager.set_target_fps(index)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/ui/main_menu.tscn")
