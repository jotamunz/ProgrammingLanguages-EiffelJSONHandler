note
	description: "Summary description for {ACTION_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_LISTENER

create
	make

feature -- Initialization

	json_hash: HASH_TABLE [JSON_FILE, STRING]
	file_manager: FILE_MANAGER

	make

		do
			create json_hash.make(0)
			create File_manager.make
		end

feature {NONE} -- Private

feature -- Public

	run

		local
			running: BOOLEAN
			operation: ARRAYED_LIST [STRING]

		do
			Io.put_string ("Main Menu")
			Io.new_line
			from
				running := true
			until
				running = false
			loop
				Io.put_string ("input an operation: ")
				Io.read_line
				create operation.make_from_iterable (Io.last_string.split (' '))
				if operation.at (1).same_string ("load") and operation.count = 3 then
					load(operation.at (2), operation.at (3))
				elseif operation.at (1).same_string ("save") and operation.count = 3 then
					save(operation.at (2), operation.at (3), false)
				elseif operation.at (1).same_string ("savecsv") and operation.count = 3 then
					save(operation.at (2), operation.at (3), true)
				elseif operation.at (1).same_string ("exit") then
					running := false
				else
					Io.put_string ("Unrecognized operation")
					Io.new_line
				end
			end

		end

	load (name: STRING; path: STRING)

		local
			json: JSON_FILE
			file_lines: ARRAYED_LIST [STRING]
			header: ARRAYED_LIST [STRING]
			types: ARRAYED_LIST [STRING]
			body: ARRAYED_LIST [ARRAYED_LIST [STRING]]

		do
			if not json_hash.has (name) then
				create file_lines.make_from_iterable (file_manager.read_file_lines (path))
				if not file_lines.is_empty then
					create header.make_from_iterable (File_manager.split_semicolon (file_lines.at (1)))
					create types.make_from_iterable (File_manager.split_semicolon (file_lines.at (2)))
					file_lines.remove_i_th (1)
					file_lines.remove_i_th (1)
					create body.make_from_iterable (File_manager.split_semicolon_multiple (file_lines))
					create json.make_from_list (name, header, types, body)
					json_hash.put (json, name)
					Io.put_string ("loaded file " + name)
					Io.new_line
					Io.put_string (json.body_to_string)
				else
					Io.put_string ("File not found")
				end
			else
				Io.put_string ("Specified name already exists")
			end
			Io.new_line
		end

	save (name: STRING; path: STRING; csv: BOOLEAN)

		local
			json: JSON_FILE

		do
			create json.make
			json := json_hash.at (name)
			if attached json then
				if csv then
					file_manager.write_file (path, json.to_csv_string)
				else
					file_manager.write_file (path, json.body_to_string)
				end
				Io.put_string ("Saved file " + name)
			else
				Io.put_string ("Specified name doesnt exist")
			end
			Io.new_line
		end

	json_from_matching (name: STRING; new_name: STRING; key: STRING; value: STRING)

		local
			json: JSON_FILE
			new_json: JSON_FILE
			matching_lines: ARRAYED_LIST [JSON_OBJECT]

		do
			create json.make
			json := json_hash.at (name)
			if attached json and not json_hash.has (new_name) then
				create matching_lines.make_from_iterable (json.matching_lines (key, value))
				if not matching_lines.is_empty then
					create new_json.make_from_json (new_name, json.header, json.types, matching_lines)
					json_hash.put (new_json, new_name)
					Io.put_string (new_json.to_string)
				else
					Io.put_string ("No matching lines")
				end
			else
				Io.put_string ("Specified name doesnt exist or new name already exists")
			end
			Io.new_line
		end

	json_from_columns (name: STRING; new_name:STRING; keys: ARRAYED_LIST [STRING])

		local
			json: JSON_FILE
			new_json: JSON_FILE
			matching_columns: ARRAYED_LIST [JSON_OBJECT]
			matching_types: ARRAYED_LIST [STRING]

		do
			create json.make
			json := json_hash.at (name)
			if attached json and not json_hash.has (new_name) then
				create matching_columns.make_from_iterable (json.get_columns (keys))
				create matching_types.make_from_iterable (json.get_types (keys))
				if not matching_columns.is_empty and matching_types.count = keys.count then
					create new_json.make_from_json (new_name, keys, matching_types, matching_columns)
					json_hash.put (new_json, new_name)
					Io.put_string (new_json.to_string)
				else
					Io.put_string ("One or more columns was not found")
				end
			else
				Io.put_string ("Specified name doesnt exist or new name already exists")
			end
			Io.new_line
		end
end
