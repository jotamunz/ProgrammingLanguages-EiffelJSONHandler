note
	description: "Summary description for {JSON_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_FILE

create
	make_from_json

create
	make_from_list

feature -- Initialization

	name: STRING
	header: ARRAYED_LIST [STRING]
	types: ARRAYED_LIST [STRING]
	body: ARRAYED_LIST [JSON_OBJECT]

	make_from_json (i_name: STRING; i_header: ARRAYED_LIST [STRING]; i_types: ARRAYED_LIST [STRING]; i_body: ARRAYED_LIST [JSON_OBJECT])

		do
			create name.make_from_string (i_name)
			create header.make_from_iterable (i_header)
			create types.make_from_iterable (i_types)
			create body.make_from_iterable (i_body)
		end

	make_from_list (i_name: STRING; i_header: ARRAYED_LIST [STRING]; i_types: ARRAYED_LIST [STRING]; i_body: ARRAYED_LIST [ARRAYED_LIST [STRING]])

		local
			i: INTEGER
			max: INTEGER
			json: JSON_OBJECT

		do
			create name.make_from_string (i_name)
			create header.make_from_iterable (i_header)
			create types.make_from_iterable (i_types)
			create body.make (0)

			across i_body as line
			loop
				create json.make_empty
				from
					i := 1
					max := line.item.count
				until
					i > max
				loop
					if line.item.at (i).is_equal ("") then
						json.put (Void, i_header.at (i))
					elseif i_types.at (i).is_equal ("X") then
						json.put_string (line.item.at (i), i_header.at (i))
					elseif i_types.at (i).is_equal ("N") then
						line.item.at (i).replace_substring_all (",", ".")
						json.put_real (line.item.at (i).to_real_64, i_header.at (i))
					elseif i_types.at (i).is_equal ("B") then
						if line.item.at (i).is_equal ("T") or line.item.at (i).is_equal ("S") then
							json.put_boolean (True, i_header.at (i))
						elseif line.item.at (i).is_equal ("F") or line.item.at (i).is_equal ("N") then
							json.put_boolean (False, i_header.at (i))
						end
					end
					i := i + 1
				end
				body.extend (json)
			end
		end

feature {NONE} -- Private

feature -- Public

	print_all

		do
			Io.put_string (name)
			Io.new_line

			across header as head
			loop
				Io.put_string (head.item + ", ")
			end
			Io.new_line

			across types as type
			loop
				Io.put_string (type.item + ", ")
			end
			Io.new_line

			print_body
		end

	print_body

		local
			keys: ARRAYED_LIST [JSON_STRING]

		do
			across body as line
			loop
				create keys.make_from_iterable(line.item.map_representation.current_keys)
				across keys as key
				loop
					if attached line.item.item (key.item) as value then
						Io.put_string (key.item.representation + ": ")
						Io.put_string (value.representation + ", ")
					end
				end
				Io.new_line
			end
		end

end
