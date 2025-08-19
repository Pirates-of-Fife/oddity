@tool
extends CanvasLayer

class_name InventoryHud

@export_category("Player")

@export
var player : Player

@export_category("HUD Elements")

@export
var interaction_icon : Sprite2D

@export
var storable_icon : AnimatedSprite2D

@export
var inventory : Control 

@export_category("Inventory Slots")

@export
var inventory_slot_1_label : Label

@export
var inventory_slot_2_label : Label

@export
var inventory_slot_3_label : Label

@export
var inventory_slot_4_label : Label

@export
var inventory_slot_5_label : Label


@export
var inventory_slot_1_label_number : Label

@export
var inventory_slot_2_label_number : Label

@export
var inventory_slot_3_label_number : Label

@export
var inventory_slot_4_label_number : Label

@export
var inventory_slot_5_label_number : Label

@export_category("Visibility")

@export
var interaction_icon_visibile : bool :
	set(value):
		if interaction_icon_visibile == null:
			return
		
		if !inventory_visible:
			return

		if value:
			interaction_icon_visibile = value
			interaction_icon.show()
		else:
			interaction_icon_visibile = value
			interaction_icon.hide()
	get:
		return interaction_icon_visibile


@export
var storable_icon_visibile : bool :
	set(value):
		if storable_icon_visibile == null:
			return
		
		if !inventory_visible:
			return
		
		if value:
			storable_icon_visibile = value
			storable_icon.show()
		else:
			storable_icon_visibile = value
			storable_icon.hide()
	get:
		return storable_icon_visibile

@export
var inventory_visible : bool :
	set(value):
		if inventory == null:
			return
		
		if value:
			inventory.show()
			inventory_visible = value
		else:
			inventory_visible = value
			inventory.hide()
			storable_icon_visibile = false
			interaction_icon_visibile = false


func _ready() -> void:
	inventory_visible = true
