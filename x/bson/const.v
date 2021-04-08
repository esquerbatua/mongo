module bson

const (
	type_end             = 0x00
	type_double          = 0x01
	type_string          = 0x02
	type_document        = 0x03
	type_array           = 0x04
	type_binary          = 0x05
	type_objectid        = 0x07
	type_bool            = 0x08
	type_datetime        = 0x09
	type_int             = 0x10
	type_timestamp       = 0x11
	type_i64             = 0x12
	type_decimal128      = 0x13
	type_null            = 0x0A
	type_regex           = 0x0B
	type_javascript      = 0x0D
	type_maxkey          = 0x7f
	type_minkey          = 0xFF

	// deprecateds
	type_undefined       = 0x06
	type_dbpointer       = 0x0C
	type_symbol          = 0x0E
	type_js_with_scope   = 0x0F

	subtype_binary       = 0x00
	subtype_fn           = 0x01
	subtype_binary_old   = 0x02
	subtype_uuid         = 0x03
	subtype_md5          = 0x05
	subtype_user_defined = 0x80
)
