extends Node2D

const SPARK_SCENE = preload("res://hit_spark.tscn")
const DAMAGE_NUMBER_SCENE = preload("res://damage_number.tscn")

func create_hit_spark(position: Vector2):
	if SPARK_SCENE:
		var spark = SPARK_SCENE.instantiate()
		get_tree().current_scene.add_child(spark)
		spark.global_position = position

func create_damage_number(position: Vector2, damage: int, is_combo: bool = false):
	if DAMAGE_NUMBER_SCENE:
		var dmg_num = DAMAGE_NUMBER_SCENE.instantiate()
		get_tree().current_scene.add_child(dmg_num)
		dmg_num.setup(position, damage, is_combo)

func hit_freeze(duration: float = 0.1):
	Engine.time_scale = 0.1
	await get_tree().create_timer(duration * 0.1).timeout
	Engine.time_scale = 1.0
