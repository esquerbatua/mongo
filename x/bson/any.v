module bson

pub type Any = Null | []Any | bool | f32 | f64 | i64 | int | map[string]Any | string | u64 | ObjectId

pub struct Null {
	is_null bool = true
}