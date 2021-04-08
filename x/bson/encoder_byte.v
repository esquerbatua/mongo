module bson

import strings

pub fn (bson Bson) byte() []byte {
	mut buff := []byte{}
	mut i := 0
	for k, v in bson.fields {
		buff.write_string('"$k":')
		write_value(v, i, bson.fields.len, mut buff)
		i++
	}
	return buff.str()
}

// byte returns the byte representation of the `[]Any`.
pub fn (arr []Any) byte() []byte {
	mut buff := []byte{}
	buff << x04
	for i, v in arr {
		write_value(v, i, arr.len, mut wr)
	}
	wr.write_b(`]`)
	defer {
		unsafe { wr.free() }
	}
	res := wr.str()
	return res
}

fn write_value(v Any, i int, len int, mut wr strings.Builder) {
	str := v.str()
	if v is string {
		wr.write_string('"$str"')
	} else {
		wr.write_string(str)
	}
	if i >= len - 1 {
		return
	}
	wr.write_b(`,`)
}

// str returns the BSON string representation of the `Any` type.
pub fn (f Any) byte() []byte {
	mut buff := []byte{}
	match f {
		string {
			buff << type_string
			buff << f.bytes()
		}
		int {
			buff << type_int
			//TODO fill with 0 to get 4 bytes of lenght
			buff << f.bytes()
		}
		i64 {
			buff << type_i64
			//TODO fill with 0 to get 8 bytes of lenght
			f.bytes()
		}
		u64 {
			buff << type_timestamp
			//TODO fill with 0 to get 8 bytes of lenght
			f.bytes()
		}
		f32 {
			str_f32 := f.str()
			if str_f32.ends_with('.') {
				return '${str_f32}0'
			}
			str_f32
		}
		f64 {
			str_f64 := f.str()
			if str_f64.ends_with('.') {
				return '${str_f64}0'
			}
			return str_f64
		}
		bool {
			buff << type_i64
			buff << if f { byte(0x01) } else { byte(0x00) }
		}
		map[string]Any {
			return f.str()
		}
		[]Any {
			return f.str()
		}
		Null {
			return 'null'
		}
		ObjectId {
			return f.str()
		}
	}
	buff << type_end
	return buff
}