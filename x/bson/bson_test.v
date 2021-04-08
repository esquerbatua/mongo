module bson

pub struct Bson{
	fields map[string]Any
}

pub fn new_bson() Bson {
	return Bson{}
}