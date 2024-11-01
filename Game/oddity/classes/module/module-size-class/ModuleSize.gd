extends Node

class_name ModuleSize

# Enum for Component Sizes
enum ComponentSize {
	SIZE_0 = 0,  # 0.25m x 0.25m x 0.5m
	SIZE_1,      # 0.5m x 0.5m x 1m 
	SIZE_2,      # 1m x 1m x 2m 
	SIZE_3,      # 1.5m x 1.5m x 3m
	SIZE_4,      # 2m x 2m x 4m 
	SIZE_5,      # 3m x 3m x 6m 
	SIZE_6,      # 4m x 4m x 8m 
	SIZE_7,      # 5m x 5m x 10m
	SIZE_8,      # 6m x 6m x 12m
	SIZE_9,      # 7m x 7m x 14m
	SIZE_10      # 8m x 8m x 16m
}

# Enum for Hardpoint Sizes
enum HardpointSize {
	SIZE_0 = 0,  # 0.25m x 0.5m x 0.25m
	SIZE_1,      # 0.35m x 0.7m x 0.35m
	SIZE_2,      # 0.5m x 1m x 0.5m
	SIZE_3,      # 0.7m x 1.5m x 0.7m
	SIZE_4,      # 1m x 2m x 1m
	SIZE_5,      # 2m x 4m x 2m
	SIZE_6,      # 3m x 6m x 3m
	SIZE_7,      # 4m x 8m x 4m
	SIZE_8,      # 5m x 10m x 5m
	SIZE_9,      # 6m x 12m x 6m
	SIZE_10,     # 7m x 14m x 7m
	SIZE_11,     # 8m x 16m x 8m
	SIZE_12,     # 9m x 18m x 9m
	SIZE_13      # 10m x 20m x 10m
}

# Enum for Abyssal Jump Drive Sizes
enum AbyssalJumpDriveSize {
	SIZE_0 = 0,
	SIZE_1,      # 1m x 0.5m x 2m
	SIZE_2,      # 1.5m x 0.75m x 4m
	SIZE_3,      # 2m x 1m x 6m
	SIZE_4,      # 2.5m x 1.2m x 8m
	SIZE_5,      # 3m x 1.5m x 10m
	SIZE_6,      # 4m x 2m x 12m
	SIZE_7,      # 5m x 2.5m x 14m
	SIZE_8,      # 6m x 3m x 16m
	SIZE_9,      # 7m x 3.5m x 18m
	SIZE_10      # 8m x 4m x 20m
}

# Enum for Alcubierre Drive Sizes
enum AlcubierreDriveSize {
	SIZE_0 = 0,  # 0.5m x 0.5m x 0.5m
	SIZE_1,      # 1m x 0.5m x 0.5m
	SIZE_2,      # 1.5m x 0.75m x 0.75m
	SIZE_3,      # 2m x 1m x 1m
	SIZE_4,      # 2.5m x 1.2m x 1.2m
	SIZE_5,      # 3m x 1.5m x 1.5m
	SIZE_6,      # 4m x 2m x 2m
	SIZE_7,      # 5m x 2.5m x 2.5m
	SIZE_8,      # 6m x 3m x 3m
	SIZE_9,      # 7m x 3.5m x 3.5m
	SIZE_10      # 8m x 4m x 4m
}

# Function to get component size dimensions
func get_component_size(size: ComponentSize) -> Vector3:
	match size:
		ComponentSize.SIZE_0: return Vector3(0.25, 0.25, 0.5)
		ComponentSize.SIZE_1: return Vector3(0.5, 0.5, 1)
		ComponentSize.SIZE_2: return Vector3(1, 1, 2)
		ComponentSize.SIZE_3: return Vector3(1.5, 1.5, 3)
		ComponentSize.SIZE_4: return Vector3(2, 2, 4)
		ComponentSize.SIZE_5: return Vector3(3, 3, 6)
		ComponentSize.SIZE_6: return Vector3(4, 4, 8)
		ComponentSize.SIZE_7: return Vector3(5, 5, 10)
		ComponentSize.SIZE_8: return Vector3(6, 6, 12)
		ComponentSize.SIZE_9: return Vector3(7, 7, 14)
		ComponentSize.SIZE_10: return Vector3(8, 8, 16)
		_ : return Vector3.ZERO

# Function to get hardpoint size dimensions
func get_hardpoint_size(size: HardpointSize) -> Vector3:
	match size:
		HardpointSize.SIZE_0: return Vector3(0.25, 0.5, 0.25)
		HardpointSize.SIZE_1: return Vector3(0.35, 0.7, 0.35)
		HardpointSize.SIZE_2: return Vector3(0.5, 1, 0.5)
		HardpointSize.SIZE_3: return Vector3(0.7, 1.5, 0.7)
		HardpointSize.SIZE_4: return Vector3(1, 2, 1)
		HardpointSize.SIZE_5: return Vector3(2, 4, 2)
		HardpointSize.SIZE_6: return Vector3(3, 6, 3)
		HardpointSize.SIZE_7: return Vector3(4, 8, 4)
		HardpointSize.SIZE_8: return Vector3(5, 10, 5)
		HardpointSize.SIZE_9: return Vector3(6, 12, 6)
		HardpointSize.SIZE_10: return Vector3(7, 14, 7)
		HardpointSize.SIZE_11: return Vector3(8, 16, 8)
		HardpointSize.SIZE_12: return Vector3(9, 18, 9)
		HardpointSize.SIZE_13: return Vector3(10, 20, 10)
		_ : return Vector3.ZERO

func get_abyssal_jump_drive_size(size: AbyssalJumpDriveSize) -> Vector3:
	match size:
		AbyssalJumpDriveSize.SIZE_0: return Vector3.ZERO
		AbyssalJumpDriveSize.SIZE_1: return Vector3(0.5, 1, 2)
		AbyssalJumpDriveSize.SIZE_2: return Vector3(0.75, 1.5, 4)
		AbyssalJumpDriveSize.SIZE_3: return Vector3(1, 2, 6)
		AbyssalJumpDriveSize.SIZE_4: return Vector3(1.2, 2.5, 8)
		AbyssalJumpDriveSize.SIZE_5: return Vector3(1.5, 3, 10)
		AbyssalJumpDriveSize.SIZE_6: return Vector3(2, 4, 12)
		AbyssalJumpDriveSize.SIZE_7: return Vector3(2.5, 5, 14)
		AbyssalJumpDriveSize.SIZE_8: return Vector3(3, 6, 16)
		AbyssalJumpDriveSize.SIZE_9: return Vector3(3.5, 7, 18)
		AbyssalJumpDriveSize.SIZE_10: return Vector3(4, 8, 20)
		_ : return Vector3.ZERO

func get_alcubierre_drive_size(size: AlcubierreDriveSize) -> Vector3:
	match size:
		AlcubierreDriveSize.SIZE_0: return Vector3(0.5, 0.5, 0.5)
		AlcubierreDriveSize.SIZE_1: return Vector3(0.5, 1, 0.5)
		AlcubierreDriveSize.SIZE_2: return Vector3(0.75, 1.5, 0.75)
		AlcubierreDriveSize.SIZE_3: return Vector3(1, 2, 1)
		AlcubierreDriveSize.SIZE_4: return Vector3(1.2, 2.5, 1.2)
		AlcubierreDriveSize.SIZE_5: return Vector3(1.5, 3, 1.5)
		AlcubierreDriveSize.SIZE_6: return Vector3(2, 4,2)
		AlcubierreDriveSize.SIZE_7: return Vector3(2.5, 5, 2.5)
		AlcubierreDriveSize.SIZE_8: return Vector3(3, 6, 3)
		AlcubierreDriveSize.SIZE_9: return Vector3(3.5, 7, 3.5)
		AlcubierreDriveSize.SIZE_10: return Vector3(4, 8, 4)
		_ : return Vector3.ZERO
