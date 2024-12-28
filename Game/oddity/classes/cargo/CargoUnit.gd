extends Node

class_name CargoUnit

enum ContainerSize
{
	CU_1 = 0,
	CU_2,
	CU_3,
	CU_4,
	CU_8,
	CU_16,
	CU_32
}

func get_container_size(cu: ContainerSize) -> Vector3:
	match cu:
		ContainerSize.CU_1:
			return Vector3(1.25, 1.25, 1.25)  # Width, Length, Height
		ContainerSize.CU_2:
			return Vector3(1.25, 1.25, 2.5)
		ContainerSize.CU_3:
			return Vector3(1.25, 1.25, 3.75)
		ContainerSize.CU_4:
			return Vector3(2.5, 1.25, 2.5)
		ContainerSize.CU_8:
			return Vector3(2.5, 2.5, 2.5)
		ContainerSize.CU_16:
			return Vector3(2.5, 2.5, 5.0)
		ContainerSize.CU_32:
			return Vector3(2.5, 2.5, 10.0)
		_:
			return Vector3.ZERO  # Default case for safety
