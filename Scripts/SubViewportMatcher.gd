extends SubViewportContainer

@onready var subviewport: SubViewport = $"SubViewport"

func _process(delta: float):
	subviewport.size = self.size