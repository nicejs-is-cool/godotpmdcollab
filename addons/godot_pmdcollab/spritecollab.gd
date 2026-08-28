extends Node

const PORTRAIT_SIZE = Vector2i(40, 40)
const SPRITESHEET_INDEX_SIZE = Vector2i(5, 8)
const ASYMMETRICAL_PORTRAITS_START = Vector2i(4, 0)

enum PortraitIndex {
	NORMAL,
	HAPPY,
	PAIN,
	ANGRY,
	WORRIED,
	SAD,
	CRYING,
	SHOUTING,
	TEARY_EYED,
	DETERMINED,
	JOYOUS,
	INSPIRED,
	SURPRISED,
	DIZZY,
	SPECIAL0,
	SPECIAL1,
	SIGH,
	STUNNED,
	SPECIAL2,
	SPECIAL3,
}

static func vec2i_to_index(vec: Vector2i) -> int:
	return (vec.x * SPRITESHEET_INDEX_SIZE.x) + (vec.y * SPRITESHEET_INDEX_SIZE.y)

# assumes a SC spritesheet
static func get_portrait_dimensions(index: int) -> Rect2i:
	var indexVec = Vector2i(index % SPRITESHEET_INDEX_SIZE.x, index / SPRITESHEET_INDEX_SIZE.x)
	#print("indexVec=",indexVec)
	return Rect2i(indexVec*PORTRAIT_SIZE, PORTRAIT_SIZE)

static func asym_portrait(index: int) -> int:
	return index + vec2i_to_index(ASYMMETRICAL_PORTRAITS_START)
