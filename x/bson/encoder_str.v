module bson

import strings

const (
	escaped_chars = [r'\b', r'\f', r'\n', r'\r', r'\t']
	important_escapable_chars = [`\b`, `\f`, `\n`, `\r`, `\t`]
)

pub fn (bson Bson) str() string {
	mut buff := strings.new_builder(200)
	buff.write_b(`{`)
	mut i := 0
	for k, v in bson.fields {
		buff.write_string('"$k":')
		write_value(v, i, bson.fields.len, mut buff)
		i++
	}
	buff.write_b(`}`)
	return buff.str()
}

// str returns the string representation of the `[]Any`.
pub fn (arr []Any) str() string {
	mut wr := strings.new_builder(200)
	wr.write_b(`[`)
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
pub fn (f Any) str() string {
	match f {
		string {
			return bson_string(f)
		}
		int {
			return f.str()
		}
		u64, i64 {
			return f.str()
		}
		f32 {
			str_f32 := f.str()
			if str_f32.ends_with('.') {
				return '${str_f32}0'
			}
			return str_f32
		}
		f64 {
			str_f64 := f.str()
			if str_f64.ends_with('.') {
				return '${str_f64}0'
			}
			return str_f64
		}
		bool {
			return f.str()
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
}

// char_len_list is a modified version of builtin.utf8_str_len that returns an array of character lengths. (e.g "t✔" => [1,2])
fn char_len_list(s string) []int {
	mut l := 1
	mut ls := []int{}
	for i := 0; i < s.len; i++ {
		c := s[i]
		if (c & (1 << 7)) != 0 {
			for t := byte(1 << 6); (c & t) != 0; t >>= 1 {
				l++
				i++
			}
		}
		ls << l
		l = 1
	}
	return ls
}

// bson_string returns the BSON spec-compliant version of the string.
[manualfree]
fn bson_string(s string) string {
	// not the best implementation but will revisit it soon
	char_lens := char_len_list(s)
	mut sb := strings.new_builder(s.len)
	mut i := 0
	defer {
		unsafe {
			char_lens.free()
			// freeing string builder on defer after
			// returning .str() still isn't working :(
			// sb.free()
		}
	}
	for char_len in char_lens {
		if char_len == 1 {
			chr := s[i]
			if chr in important_escapable_chars {
				for j := 0; j < important_escapable_chars.len; j++ {
					if chr == important_escapable_chars[j] {
						sb.write_string(escaped_chars[j])
						break
					}
				}
			} else if chr == `"` || chr == `/` || chr == `\\` {
				sb.write_string('\\' + chr.ascii_str())
			} else {
				sb.write_b(chr)
			}
		} else {
			slice := s[i..i + char_len]
			hex_code := slice.utf32_code().hex()
			if hex_code.len == 4 {
				sb.write_string('\\u$hex_code')
			} else {
				// TODO: still figuring out what
				// to do with more than 4 chars
				sb.write_b(` `)
			}
			unsafe {
				slice.free()
				hex_code.free()
			}
		}
		i += char_len
	}
	str := sb.str()
	unsafe { sb.free() }
	return str
}