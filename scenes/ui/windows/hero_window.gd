extends BaseWindow
class_name HeroWindow

@export var hero_name_lbl: Label
@export var hero_class_lbl: Label
@onready var ability_box: Control = %Ability_Box
@onready var res_box: Control = %Res_Box
@onready var stat_box: Control = %Stat_Box
@onready var hero_icon: TextureRect = %Hero_Rect
