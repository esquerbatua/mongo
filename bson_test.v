module mongo

struct Test {
	str string
	number int
	float f64
	boolean bool
}

fn test_to_json() {
	test := Test{
		str: 'test'
		number: 1
		float: 0.5
		boolean: true
	}
	text := bson.to_json<Test>(test)
	assert text.as_json() == '{ "str" : "test", "number" : 1, "float" : 0.5, "boolean" : true }'
}

fn test_as_json() {
	doc := bson.new_from_json('{"insert":"test"}')
	assert doc.as_json() == '{ "insert" : "test" }'
}

fn test_compare() {
	doc1 := bson.new_from_json('{"insert":"test"}')
	doc2 := bson.new_from_json('{"insert":"test"}')
	assert doc1.compare(doc2) == 0

	doc3 := bson.new_from_json('{"insert":"test"}')
	doc4 := bson.new_from_json('{"insert":"test1"}')
	assert doc3.compare(doc4) != 0
}

fn test_concat() {
	doc1 := bson.new_from_json('{"key":"value"}')
	doc2 := bson.new_from_json('{"key1":"value1"}')
	doc1.concat(doc2)
	assert doc1.as_json() == '{ "key" : "value", "key1" : "value1" }'
}

fn test_count_keys() {
	doc1 := bson.new_from_json('{"1":"value","2":"value1","3":"value3"}')
	assert doc1.count_keys() == 3
}

fn test_equal() {
	doc1 := bson.new_from_json('{"insert":"test"}')
	doc2 := bson.new_from_json('{"insert":"test"}')
	assert doc1.equal(doc2)

	doc3 := bson.new_from_json('{"insert":"test"}')
	doc4 := bson.new_from_json('{"insert":"test1"}')
	assert !doc3.equal(doc4)
}

fn test_has_field() {
	doc := bson.new_from_json('{"insert":"test"}')
	assert doc.has_field('insert')

	doc1 := bson.new_from_json('{"insert":"test"}')
	assert !doc1.has_field('doc2')
}