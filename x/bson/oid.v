module bson

import time
import rand
import regex

const (
	hex_regex = regex.regex_opt('^[0-9a-fA-F]{24}$') or { panic('error creating ObjectID regex validation') }
)

struct ObjectId {
	// 4 bytes max
	timestamp u32
	// 5 bytes max
	random    u64
	// 3 bytes max
	counter   u32
	bytes [12]byte
	hex       string
}

pub fn new_oid() ObjectId {
	timestamp := time.now().unix_time().str().u32()
	// 5 bytes max
	random := rand.u64n(4294967295)
	// 3 bytes max
	counter := rand.u32n(16777215)
	mut counter_hex := counter.hex()
	if counter_hex.len < 6 {
		counter_hex = '0'.repeat(6 - counter_hex.len) + counter_hex
	}
	/*
	println(timestamp.hex())
	println(random.hex_full()[6..16])
	println(counter.hex())
	*/
	return ObjectId{
		timestamp: timestamp
		random: random
		counter: counter
		hex: timestamp.hex() + random.hex_full()[6..16] + counter_hex
	}
}

pub fn oid(hex string) ObjectId {
	return ObjectId{
		hex: hex
	}
}

pub fn (oid ObjectId) str() string {
	return 'ObjectId("$oid.hex")'
}

pub fn (oid ObjectId) json_str() string {
	return '{"_id": { "\$oid": "$oid.hex"}}'
}

pub fn (oid ObjectId) is_valid() bool {
	mut re := hex_regex
	start, _ := re.match_string(oid.hex)
	return start >= 0
}