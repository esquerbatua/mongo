module bson

fn test_oid() {
	for _ in 0..10_230000 {
		oid := new()
		assert oid.is_valid()
		gc_check_leaks()
	}
}