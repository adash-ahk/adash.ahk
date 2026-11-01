class adash {
	; --- Static Variables ---
	static stringCaseSense := false
	static throwExceptions := true
	static VERSION := "0.7.0"
	; --- Guarded Methods ---
	static _guarded := map(this.prototype.__class ".trim", { maxParams: 1, type: "self" }
		, this.prototype.__class ".trimEnd", { maxParams: 1, type: "self" }
		, this.prototype.__class ".trimStart", { maxParams: 1, type: "self" }
		, this.prototype.__class ".parseInt", { maxParams: 1, type: "self" }
		, this.prototype.__class ".chunk", { maxParams: 1, type: "self" }
		, this.prototype.__class ".take", { maxParams: 1, type: "self" }
		, this.prototype.__class ".takeRight", { maxParams: 1, type: "self" }
		, this.prototype.__class ".parseInt", { maxParams: 1, type: "self" }
		, this.prototype.__class ".drop", { maxParams: 1, type: "self" }
		, this.prototype.__class ".sampleSize", { maxParams: 1, type: "self" }
		, this.prototype.__class ".words", { maxParams: 1, type: "self" }
		, this.prototype.__class ".random", { maxParams: 1, type: "self" }
		, "Trim", { maxParams: 1, type: "function" }
		, "LTrim", { maxParams: 1, type: "function" }
		, "RTrim", { maxParams: 1, type: "function" })
	; --- Static Methods ---
	static map(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string", "object"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		if (this.isString(param_collection)) {
			l_collection := strSplit(param_collection)
		} else {
			l_collection := this.cloneDeep(param_collection)
		}
		l_array := []
		l_iteratee := this._createPredicate(param_iteratee?, l_collection)
		valType := type(l_collection)
		switch (valType) {
			case "Object":
				for key, value in l_collection.ownProps() {
					l_array.push(l_iteratee(value, key, l_collection))
				}
			default:
				for key, value in l_collection {
					l_array.push(l_iteratee(value, key, l_collection))
				}
		}
		return l_array
	}
	static size(param_collection) {
		switch type(param_collection), false {
			case "array":
				return param_collection.length
			case "object":
				return objOwnPropCount(param_collection)
			case "string":
				return strLen(param_collection)
			case "float":
				return 0
			case "integer":
				return 0
			default:
				if (param_collection.hasProp("Count")) {
					return param_collection.count
				}
				return 0
		}
		return ""
	}
	static flatMapDeep(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string", "object"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		return this.flatMapDepth(param_collection, param_iteratee?, 0x7FFFFFFF)
	}
	static flatMapDepth(param_collection,param_iteratee?,param_depth:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string", "object"], param_depth, ["integer"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		l_array := this.map(param_collection, param_iteratee?)
		loop (param_depth) {
			l_flattened := []
			l_foundArray := false
			for value in l_array {
				if (type(value) == "Array") {
					l_flattened.push(value*)
					l_foundArray := true
				} else {
					l_flattened.push(value)
				}
			}
			l_array := l_flattened
			if (!l_foundArray) {
				break
			}
		}
		return l_array
	}
	static sortBy(param_collection,param_iteratees?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "string"])
			if (isSet(param_iteratees)) {
				this._validateTypes(param_iteratees, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		if (this.isString(param_collection)) {
			l_values := strSplit(param_collection)
		} else if (type(param_collection) == "Object") {
			l_values := []
			for key, value in param_collection.ownProps() {
				l_values.push(value)
			}
		} else {
			l_values := param_collection
		}
		if (l_values.length == 0) {
			return []
		}
		l_iteratees := []
		if (!isSet(param_iteratees)) {
			l_iteratees.push(this._createPredicate())
		} else {
			for iteratee in (type(param_iteratees) == "Array" ? param_iteratees : [param_iteratees]) {
				l_iteratees.push(this._createPredicate(iteratee, l_values))
			}
		}
		l_criteria := []
		l_indexes := ""
		for index, value in l_values {
			l_keys := []
			for fn in l_iteratees {
				l_keys.push(fn(value, index, l_values))
			}
			l_criteria.push(l_keys)
			l_indexes .= index "|"
		}
		l_indexes := sort(rTrim(l_indexes, "|"), "D|"
			, (a, b, *) => this._sortByCompare(l_criteria[integer(a)], l_criteria[integer(b)]) || (a - b))
		l_array := []
		loop parse l_indexes, "|" {
			l_array.push(l_values[integer(A_LoopField)])
		}
		return l_array
	}
	static _sortByCompare(param_a,param_b) {
		for i, x in param_a {
			y := param_b[i]
			xRank := isObject(x) ? 2 : isNumber(x) ? 0 : 1
			yRank := isObject(y) ? 2 : isNumber(y) ? 0 : 1
			if (xRank != yRank) {
				return xRank - yRank
			}
			switch (xRank) {
				case 0:
					result := (x > y) - (x < y)
				case 1:
					result := strCompare(x, y, this.stringCaseSense)
				default:
					result := 0
			}
			if (result != 0) {
				return result
			}
		}
		return 0
	}
	static some(param_collection,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		l_enum := (type(param_collection) == "Object") ? param_collection.ownProps() : param_collection
		for key, value in l_enum {
			if (l_predicate(value, key, param_collection)) {
				return true
			}
		}
		return false
	}
	static filter(param_collection,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		l_enum := (type(param_collection) == "Object") ? param_collection.ownProps() : param_collection
		l_array := []
		for key, value in l_enum {
			if (l_predicate(value, key, param_collection)) {
				l_array.push(value)
			}
		}
		return l_array
	}
	static sampleSize(param_collection,param_sampleSize:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string", "object", "map"], param_sampleSize, ["integer"])
		}
		l_values := []
		if (this.isString(param_collection)) {
			l_values := strSplit(param_collection)
		} else {
			l_enum := (type(param_collection) == "Object") ? param_collection.ownProps() : param_collection
			for key, value in l_enum {
				l_values.push(value)
			}
		}
		l_shuffled := this.shuffle(l_values)
		l_count := max(0, min(param_sampleSize, l_shuffled.length))
		l_array := []
		loop (l_count) {
			l_array.push(l_shuffled[A_Index])
		}
		return l_array
	}
	static forEach(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_collection
		}
		l_collection := param_collection
		if (this.isString(param_collection)) {
			l_collection := strSplit(param_collection)
		}
		l_iteratee := this._createPredicate(param_iteratee, l_collection)
		l_enum := (type(l_collection) == "Object") ? l_collection.ownProps() : l_collection
		for key, value in l_enum {
			l_result := l_iteratee(value, key, l_collection)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_collection
	}
	static each(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_collection
		}
		l_collection := param_collection
		if (this.isString(param_collection)) {
			l_collection := strSplit(param_collection)
		}
		l_iteratee := this._createPredicate(param_iteratee, l_collection)
		l_enum := (type(l_collection) == "Object") ? l_collection.ownProps() : l_collection
		for key, value in l_enum {
			l_result := l_iteratee(value, key, l_collection)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_collection
	}
	static invokeMap(param_collection,param_path,param_args*) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"], param_path, ["string", "array", this.isFunction])
		}
		l_collection := this.isString(param_collection) ? strSplit(param_collection) : param_collection
		l_enum := (type(l_collection) == "Object") ? l_collection.ownProps() : l_collection
		l_array := []
		if (this.isFunction(param_path)) {
			l_isOwn := this.includes(param_path.name, this.prototype.__class ".")
			for key, value in l_enum {
				l_array.push(l_isOwn ? param_path.call(this, value, param_args*) : param_path.call(value, param_args*))
			}
			return l_array
		}
		l_path := this.toPath(param_path)
		l_path := (type(l_path) == "Array") ? l_path.clone() : [l_path]
		l_method := l_path.pop()
		for key, value in l_enum {
			l_array.push(this._invokeMapMethod(value, l_path, l_method, param_args))
		}
		return l_array
	}
	static _invokeMapMethod(param_value,param_parentPath,param_method,param_args) {
		l_owner := param_value
		if (param_parentPath.length) {
			if (!isObject(param_value)) {
				return ""
			}
			l_owner := this.get(param_value, param_parentPath)
		}
		if (isObject(l_owner) && hasMethod(l_owner, param_method)) {
			return l_owner.%param_method%(param_args*)
		}
		if (hasMethod(this, param_method)) {
			return this.%param_method%(l_owner, param_args*)
		}
		return ""
	}
	static includes(param_collection,param_value,param_fromIndex:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string"], param_fromIndex, ["integer"])
		}
		if (isObject(param_value)) {
			param_value := this._hash(param_value)
			param_collection := this.map(param_collection, this._hash)
		}
		if (isObject(param_collection)) {
			for key, value in param_collection {
				if (param_fromIndex > A_Index) {
					continue
				}
				if (this.isEqual(value, param_value)) {
					return true
				}
			}
			return false
		} else {
			if (inStr(param_collection, param_value, this.stringCaseSense, param_fromIndex)) {
				return true
			} else {
				return false
			}
		}
	}
	static _includes(param_collection,param_value) {
		if (isObject(param_collection)) {
			for key, value in param_collection {
				if (value == param_value) {
					return true
				}
			}
			return false
		}
		return (inStr(param_collection, param_value, 0) > 0)
	}
	static sample(param_collection) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string"])
		}
		if (this.isString(param_collection)) {
			param_collection := strSplit(param_collection)
		}
		if (param_collection.length == 0 ) {
			return ""
		}
		l_array := param_collection.clone()
		return l_array[this.random(1, l_array.length)]
	}
	static find(param_collection,param_predicate?,param_fromIndex:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object"], param_fromIndex, ["integer"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		l_size := this.size(param_collection)
		if (param_fromIndex < 0) {
			param_fromIndex := l_size + param_fromIndex + 1
		}
		param_fromIndex := max(param_fromIndex, 1)
		l_enum := (type(param_collection) == "Object") ? param_collection.ownProps() : param_collection
		for key, value in l_enum {
			if (A_Index < param_fromIndex) {
				continue
			}
			if (l_predicate(value, key, param_collection)) {
				return value
			}
		}
		return ""
	}
	static shuffle(param_collection) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object"])
		}
		switch (type(param_collection)) {
			case "Array":
				l_array := this.clone(param_collection)
			case "Object":
				l_array := this.map(param_collection)
		}
		l_index := l_array.length
		loop (l_index - 1) {
			randomIndex := random(1, l_index)
			l_tempVar := l_array[l_index]
			l_array[l_index] := l_array[randomIndex]
			l_array[randomIndex] := l_tempVar
			l_index--
		}
		return l_array
	}
	static flatMap(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string", "object"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		return this.flatMapDepth(param_collection, param_iteratee?, 1)
	}
	static constant(param_value) {
		return (*) => param_value
	}
	static matchesProperty(param_path,param_srcvalue) {
		if (this.throwExceptions) {
			this._validateTypes(param_path, [isObject, "string"])
		}
		fnProperty := this.property(param_path)
		return (param_itaree) => this._matchesProperty(fnProperty, param_srcvalue, param_itaree)
	}
	static _matchesProperty(param_property,param_matchvalue,param_itaree) {
		itareevalue := param_property.call(param_itaree)
		if (!this.isUndefined(itareevalue)) {
			if (itareevalue = param_matchvalue) {
				return true
			}
		}
		return false
	}
	static toPath(param_value) {
		if (this.throwExceptions) {
			this._validateTypes(param_value, ["string", isObject])
		}
		if (isObject(param_value)) {
			return param_value
		}
		path_parts := []
		current_part := ""
		loop parse, (param_value) {
			char := A_LoopField
			if (char = "." || char = "[") {
				if (current_part != "") {
					path_parts.push(current_part)
					current_part := ""
				}
			} else if (char = "]") {
				if (current_part != "") {
					path_parts.push(current_part)
					current_part := ""
				}
			} else {
				current_part .= char
			}
		}
		if (current_part != "") {
			path_parts.push(current_part)
		}
		return this.compact(path_parts)
	}
	static identity(param_value) => param_value
	static times(param_n,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_n, [this.isNumber])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, [this.isFunction])
			}
		}
		l_array := []
		if (!isSet(param_iteratee)) {
			param_iteratee := this.identity.bind(this)
		}
		guarded := this._findGuarded(param_iteratee)
		switch (guarded.type) {
			case "self":
				loop (param_n) {
					l_array.push(param_iteratee.call(this, A_Index))
				}
			case "function":
				loop (param_n) {
					l_array.push(param_iteratee.call(A_Index))
				}
			default:
				passIndex := (param_iteratee.isVariadic || param_iteratee.maxParams >= 1)
				loop (param_n) {
					l_array.push(passIndex ? param_iteratee.call(A_Index) : param_iteratee.call())
				}
		}
		return l_array
	}
	static property(param_path) {
		if (this.throwExceptions) {
			this._validateTypes(param_path, ["string", "integer", isObject])
		}
		l_path := isObject(param_path) ? param_path : this.toPath(string(param_path))
		return (param_itaree) => (isObject(param_itaree) ? this.get(param_itaree, l_path) : "")
	}
	static matches(param_source) {
		if (this.throwExceptions) {
			this._validateTypes(param_source, ["object", "array", "map"])
		}
		l_source := this.cloneDeep(param_source)
		return (param_itaree) => this.isMatch(param_itaree, l_source)
	}
	static xor(param_arrays*) {
		if (this.throwExceptions) {
			for key, value in param_arrays {
				this._validateTypes(value, ["array"])
			}
		}
		l_counts := map()
		for key, arr in param_arrays {
			l_seen := map()
			for key2, value in arr {
				l_hash := this._hash(value)
				if (!l_seen.has(l_hash)) {
					l_seen[l_hash] := true
					l_counts[l_hash] := l_counts.get(l_hash, 0) + 1
				}
			}
		}
		l_array := []
		l_added := map()
		for key, arr in param_arrays {
			for key2, value in arr {
				l_hash := this._hash(value)
				if (l_counts[l_hash] == 1 && !l_added.has(l_hash)) {
					l_added[l_hash] := true
					l_array.push(value)
				}
			}
		}
		return l_array
	}
	static takeRight(param_array,param_n:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"], param_n, ["integer"])
		}
		if (isObject(param_array)) {
			param_array := this.clone(param_array)
		} else {
			param_array := strSplit(param_array)
		}
		l_array := []
		param_n := this.clamp(param_n, 0, param_array.length)
		loop (param_n) {
			if (param_array.length == 0) {
				break
			}
			value := param_array.pop()
			l_array.push(value)
		}
		if (l_array.length == 0 || param_n == 0) {
			return []
		}
		return this.reverse(l_array)
	}
	static initial(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"])
		}
		if (isObject(param_array)) {
			l_array := this.clone(param_array)
		} else {
			l_array := strSplit(param_array)
		}
		if (l_array.length == 0) {
			return []
		}
		return this.dropRight(l_array)
	}
	static dropRightWhile(param_array,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_end := param_array.length
		while (l_end > 0 && l_predicate(param_array[l_end], l_end, param_array)) {
			l_end--
		}
		l_array := []
		loop (l_end) {
			l_array.push(param_array[A_Index])
		}
		return l_array
	}
	static compact(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := []
		for key, value in param_array {
			if (!isSet(value)) {
				continue
			}
			switch (value) {
				case false:
					continue
				case "":
					continue
			}
			l_array.push(value)
		}
		return l_array
	}
	static uniq(param_collection) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "string", "integer"])
		}
		switch (type(param_collection)) {
			case "Array":
			default:
				param_collection := strSplit(param_collection)
		}
		tempArray := []
		l_array := []
		for key, value in param_collection {
			l_printedElement := this._hash(param_collection[key])
			if (this.indexOf(tempArray, l_printedElement) == -1) {
				tempArray.push(l_printedElement)
				l_array.push(value)
			}
		}
		return l_array
	}
	static zipObject(param_props,param_values) {
		if (this.throwExceptions) {
			this._validateTypes(param_props, ["array"], param_values, ["array"])
		}
		if (!isObject(param_props)) {
			param_props := []
		}
		if (!isObject(param_values)) {
			param_values := []
		}
		l_obj := {}
		for key, value in param_props {
			if (param_values.has(key)) {
				l_obj.%value% := param_values[key]
			} else {
				l_obj.%value% := ""
			}
		}
		return l_obj
	}
	static pullAllBy(param_array,param_values,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_values, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		return this._basePullAll(param_array, param_values, l_iteratee, (a, b) => this._pullEquals(a, b))
	}
	static lastIndexOf(param_array,param_value,param_fromIndex:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"], param_fromIndex, ["integer"])
		}
		if (this.isString(param_array)) {
			param_array := strSplit(param_array)
		}
		if (param_fromIndex == 0 || param_fromIndex > param_array.length - 1) {
			param_fromIndex := param_array.length - 1
		}
		index := param_fromIndex
		while (index >= 0) {
			if (this.isEqual(param_array[index + 1], param_value)) {
				return index + 1
			}
			index -= 1
		}
		return -1
	}
	static pullAllWith(param_array,param_values,param_comparator) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_values, ["array"], param_comparator, [this.isFunction])
		}
		fn := param_comparator
		if (this.includes(fn.name, this.prototype.__class ".")) {
			l_comparator := (a, b) => fn.call(this, a, b)
		} else {
			l_comparator := (a, b) => fn.call(a, b)
		}
		return this._basePullAll(param_array, param_values, "", l_comparator)
	}
	static zip(param_arrays*) {
		l_array := []
		shortestLength := 9223372036854775807
		for key, arr in param_arrays {
			if (!isObject(arr)) {
				continue
			}
			shortestLength := min(shortestLength, arr.length)
		}
		loop (shortestLength) {
			currentIndex := A_Index
			zippedGroup := []
			for key, arr in param_arrays {
				if (isObject(arr) && arr.length >= currentIndex) {
					zippedGroup.push(arr[currentIndex])
				} else {
					zippedGroup.push("")
				}
			}
			l_array.push(zippedGroup)
		}
		return l_array
	}
	static flattenDepth(param_array,param_depth:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_depth, ["integer"])
		}
		l_obj := this.cloneDeep(param_array)
		loop (param_depth) {
			l_obj := this.flatten(l_obj)
		}
		return l_obj
	}
	static difference(param_array,param_values*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := this.clone(param_array)
		for key, value in param_values {
			for key2, value2 in value {
				while ((foundIndex := this.indexOf(l_array, value2)) != -1) {
					l_array.removeAt(foundIndex)
				}
			}
		}
		return l_array
	}
	static join(param_array,param_separator:=",") {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "object", "string"], param_separator, ["string"])
		}
		if (this.isString(param_array)) {
			param_array := strSplit(param_array)
		}
		output := ""
		if (param_array.hasProp("__Item")) {
			for key, value in param_array {
				output .= (value ?? "") param_separator
			}
		} else {
			for key, value in param_array.ownProps() {
				output .= (value ?? "") param_separator
			}
		}
		return (len := strLen(param_separator)) ? subStr(output, 1, -len) : output
	}
	static findLastIndex(param_array,param_predicate?,param_fromIndex?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
			if (isSet(param_fromIndex)) {
				this._validateTypes(param_fromIndex, ["integer"])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_size := param_array.length
		l_index := isSet(param_fromIndex) ? param_fromIndex : l_size
		if (l_index < 0) {
			l_index := l_size + l_index + 1
		}
		l_index := min(l_index, l_size)
		while (l_index >= 1) {
			if (l_predicate(param_array[l_index], l_index, param_array)) {
				return l_index
			}
			l_index--
		}
		return -1
	}
	static findIndex(param_array,param_predicate?,param_fromIndex:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_fromIndex, ["integer"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_size := param_array.length
		if (param_fromIndex < 0) {
			param_fromIndex := l_size + param_fromIndex + 1
		}
		param_fromIndex := max(param_fromIndex, 1)
		for key, value in param_array {
			if (key < param_fromIndex) {
				continue
			}
			if (l_predicate(value, key, param_array)) {
				return key
			}
		}
		return -1
	}
	static flattenDeep(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "object"])
		}
		flattenedArray := []
		if (param_array.hasProp("__Item")) {
			for key, value in param_array {
				if (isObject(value)) {
					flattenedArray.push(this.flattenDeep(value)*)
				} else {
					flattenedArray.push(value)
				}
			}
		} else {
			for key, obj in param_array.ownProps() {
				if (isObject(obj)) {
					flattenedArray.push(this.flatten(obj)*)
				} else {
					flattenedArray.push(obj)
				}
			}
		}
		return flattenedArray
	}
	static nth(param_array,param_n:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"], param_n, ["integer"])
		}
		if (isObject(param_array)) {
			l_array := this.clone(param_array)
		} else {
			l_array := strSplit(param_array)
		}
		if (param_n == 0) {
			param_n := 1
		}
		if (l_array.length < param_n) {
			return ""
		}
		if (param_n > 0) {
			return l_array[param_n]
		}
		if (l_array.length == 0) {
			return ""
		}
		l_array := this.reverse(l_array)
		param_n := 0 - param_n
		return this.nth(l_array, param_n)
	}
	static sortedIndex(param_array,param_value) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		if (param_value < param_array[1]) {
			return 1
		}
		loop param_array.length - 1 {
			if (param_array[A_Index] <= param_value && param_value < param_array[A_Index + 1]) {
				return A_Index + 1
			}
		}
		return param_array.length + 1
	}
	static intersectionBy(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_iteratee := this._createPredicate()
		if (l_arrays.length > 0 && type(l_arrays[l_arrays.length]) != "Array") {
			if (this.throwExceptions) {
				this._validateTypes(l_arrays[l_arrays.length], ["string", "integer", "array", "object", "map", this.isFunction])
			}
			l_iteratee := this._createPredicate(l_arrays.pop())
		}
		if (this.throwExceptions) {
			for key, value in l_arrays {
				this._validateTypes(value, ["array"])
			}
		}
		if (l_arrays.length == 0) {
			return []
		}
		l_result := []
		l_criteria := []
		l_first := l_arrays[1]
		for key, value in l_first {
			l_criterion := l_iteratee(value, key, l_first)
			if (this.includes(l_criteria, l_criterion)) {
				continue
			}
			l_isShared := true
			loop (l_arrays.length - 1) {
				l_other := l_arrays[A_Index + 1]
				l_found := false
				for otherKey, otherValue in l_other {
					if (this.isEqual(l_iteratee(otherValue, otherKey, l_other), l_criterion)) {
						l_found := true
						break
					}
				}
				if (!l_found) {
					l_isShared := false
					break
				}
			}
			if (l_isShared) {
				l_criteria.push(l_criterion)
				l_result.push(value)
			}
		}
		return l_result
	}
	static intersection(param_arrays*) {
		tempArray := this.cloneDeep(param_arrays[1])
		param_arrays.removeAt(1)
		l_array := []
		for key, value in tempArray {
			for key2, value2 in param_arrays {
				if (this.indexOf(value2, value) != -1) {
					found := true
				} else {
					found := false
					break
				}
			}
			if (found && this.indexOf(l_array, value) == -1) {
				l_array.push(value)
			}
		}
		return l_array
	}
	static pull(param_array,param_values*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this.pullAll(param_array, param_values)
	}
	static fromPairs(param_pairs) {
		if (this.throwExceptions) {
			this._validateTypes(param_pairs, ["array"])
		}
		l_obj := {}
		for key, value in param_pairs {
			l_obj.%value[1]% := value[2]
		}
		return l_obj
	}
	static depthOf(param_array,param_depth:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_depth, ["integer"])
		}
		if (param_array.hasProp("__Item")) {
			for key, value in param_array {
				if (isObject(value)) {
					param_depth := this.depthOf(value, param_depth + 1)
				}
			}
		} else {
			for key, value in param_array.ownProps() {
				if (isObject(value)) {
					param_depth := this.depthOf(value, param_depth + 1)
				}
			}
		}
		return param_depth
	}
	static pullAll(param_array,param_values) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_values, ["array"])
		}
		return this._basePullAll(param_array, param_values, "", (a, b) => this._pullEquals(a, b))
	}
	static _pullEquals(param_a,param_b) {
		if (isObject(param_a) || isObject(param_b)) {
			return (isObject(param_a) && isObject(param_b) && this.isEqual(param_a, param_b))
		}
		return (param_a == param_b)
	}
	static _basePullAll(param_array,param_values,param_iteratee,param_comparator) {
		if (param_array.length == 0 || param_values.length == 0) {
			return param_array
		}
		l_values := []
		for value in param_values {
			l_values.push(param_iteratee ? param_iteratee(value, "", "") : value)
		}
		l_write := 0
		for value in param_array {
			l_computed := param_iteratee ? param_iteratee(value, "", "") : value
			l_matched := false
			for other in l_values {
				if (param_comparator(l_computed, other)) {
					l_matched := true
					break
				}
			}
			if (!l_matched) {
				param_array[++l_write] := value
			}
		}
		param_array.length := l_write
		return param_array
	}
	static union(param_arrays*) {
		combinedArray := []
		for each, value in param_arrays {
			if (isObject(value)) {
				for key, value2 in value {
					combinedArray.push(value2)
				}
			} else {
				combinedArray.push(value)
			}
		}
		return this.uniq(combinedArray)
	}
	static flatten(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_obj := []
		for index, obj in param_array {
			if (isObject(obj)) {
				for index2, object2 in obj {
					l_obj.push(object2)
				}
			} else {
				l_obj.push(obj)
			}
		}
		return l_obj
	}
	static reverse(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_collection := this.cloneDeep(param_array)
		l_array := []
		while (l_collection.length != 0) {
			l_array.push(l_collection.pop())
		}
		return l_array
	}
	static chunk(param_array,param_size:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string"], param_size, ["integer"])
		}
		l_array := []
		if (this.isString(param_array)) {
			param_array := strSplit(param_array)
		} else {
			param_array := this.clone(param_array)
		}
		while (param_array.length > 0) {
			l_innerArr := []
			loop (param_size) {
				if (param_array.length == 0) {
					break
				}
				l_innerArr.push(param_array.removeAt(1))
			}
		l_array.push(l_innerArr)
		}
		return l_array
	}
	static head(param) {
		if (this.isObject(param) && param.hasProp("__Item")) {
			return (param.length > 0) ? param[1] : ""
		} else if (this.isObject(param) && !param.hasProp("__Item")) {
			for key, value in param.ownProps() {
				return value
			}
		} else if (this.isString(param) || this.isNumber(param) || param == "") {
			return subStr(param, 1, 1)
		}
	}
	static first(param) {
		if (this.isObject(param) && param.hasProp("__Item")) {
			return (param.length > 0) ? param[1] : ""
		} else if (this.isObject(param) && !param.hasProp("__Item")) {
			for key, value in param.ownProps() {
				return value
			}
		} else if (this.isString(param) || this.isNumber(param) || param == "") {
			return subStr(param, 1, 1)
		}
	}
	static dropRight(param_array,param_n:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"], param_n, ["integer"])
		}
		if (isObject(param_array)) {
			l_array := param_array.clone()
		} else {
			l_array := strSplit(param_array)
		}
		if (l_array.length == 0) {
			return []
		}
		param_n := this.clamp(param_n, 0, l_array.length)
		loop (param_n) {
			l_array.removeAt(l_array.length)
		}
		if (l_array.length == 0) {
			return []
		}
		return l_array
	}
	static concat(param_array,param_values*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := param_array.clone()
		for value in param_values {
			switch type(value) {
				case "Array":
					for value2 in value {
						l_array.push(value2?)
					}
				case "Object":
					for key, value2 in value.ownProps() {
						l_array.push(value2)
					}
				default:
					l_array.push(value)
			}
		}
		return l_array
	}
	static tail(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"])
		}
		return this.drop(param_array)
	}
	static last(param_array) {
		if (!isObject(param_array)) {
			param_array := strSplit(param_array)
		}
		if (param_array.length == 0) {
			return ""
		}
		return param_array[param_array.length]
	}
	static sortedUniq(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := []
		l_temp := ""
		for key, value in param_array {
			printedelement := this._stringify(param_array[key])
			if (!this.isEqual(l_temp, printedelement)) {
				l_temp := printedelement
				l_array.push(value)
			}
		}
		return l_array
	}
	static take(param_array,param_n:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"], param_n, ["integer"])
		}
		if (this.isString(param_array) || this.isNumber(param_array)) {
			l_array := []
			loop parse, (param_array) {
				if (A_Index > param_n) {
					break
				}
				l_array.push(a_loopfield)
			}
			return l_array
		}
		if this.isObject(param_array) && param_array.hasProp("__Item") {
			param_array := this.clone(param_array)
		}
		param_n := min(param_n, param_array.length)
		l_array := []
		for index, value in param_array {
			if (a_index > param_n) {
				break
			}
			l_array.push(value)
		}
		return l_array
	}
	static unzip(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := []
		group_count := param_array[1].length
		loop (group_count) {
			l_array.push([])
		}
		for index, subarray in param_array {
			for key, value in subarray {
				if (l_array.has(key)) {
					l_array[key].push(value)
				}
			}
		}
		return l_array
	}
	static slice(param_array,param_start:=1,param_end:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "integer"], param_start, ["integer"]
				, param_end, ["integer"])
		}
		if (!isObject(param_array)) {
			param_array := strSplit(param_array)
		}
		if (param_end == 0) {
			param_end := param_array.length
		}
		l_array := []
		for key, value in param_array {
			if (A_Index >= param_start && A_Index <= param_end) {
				l_array.push(value)
			}
		}
		return l_array
	}
	static fill(param_array,param_value:="",param_start:=1,param_end:=-1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_start, ["integer"]
				, param_end, ["integer"])
		}
		if (param_end == -1) {
			param_end := param_array.length + 1
		}
		for key, value in param_array {
			if (key >= param_start && key < param_end) {
				param_array[key] := param_value
			}
		}
		return param_array
	}
	static indexOf(param_array,param_value,param_fromIndex:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array", "string", "object"], param_fromIndex, ["integer"])
		}
		switch (type(param_value)) {
			case "Array":
				param_value := this._hash(param_value)
				param_array := this.map(param_array, this._hash)
		}
		switch (type(param_array)) {
			case "String":
				param_array := strSplit(param_array)
		}
		if (param_fromIndex < 0) {
			param_fromIndex := this.size(param_array) + param_fromIndex + 1
			if (param_fromIndex < 1) {
				param_fromIndex := 1
			}
		}
		if (isObject(param_array) && param_array.hasProp("__Item")) {
			for key, value in param_array {
				if (A_Index < param_fromIndex) {
					continue
				}
				if (isObject(value) && isObject(param_value)) {
					if (this.isEqual(value, param_value)) {
						return key
					}
				} else if (value == param_value) {
					return key
				}
			}
		} else if (isObject(param_array)) {
			for key, value in param_array.ownProps() {
				if (A_Index < param_fromIndex) {
					continue
				}
				if (isObject(value) && isObject(param_value)) {
					if (this.isEqual(value, param_value)) {
						return key
					}
				} else if (value == param_value) {
					return key
				}
			}
		} else if (type(param_array) = "Array") {
			for key, value in param_array {
				if (A_Index < param_fromIndex) {
					continue
				}
				if (isObject(value) && isObject(param_value)) {
					if (this.isEqual(value, param_value)) {
						return key
					}
				} else if (value == param_value) {
					return key
				}
			}
		}
		return -1
	}
	static dropWhile(param_array,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_array := []
		l_dropping := true
		for key, value in param_array {
			if (l_dropping && l_predicate(value, key, param_array)) {
				continue
			}
			l_dropping := false
			l_array.push(value)
		}
		return l_array
	}
	static without(param_array,param_values*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this._basePullAll(param_array.clone(), param_values, "", (a, b) => this._pullEquals(a, b))
	}
	static drop(param_array,param_n:=1) {
		if (this.throwExceptions) {
		}
		switch (type(param_array)) {
			case "Array":
				l_array := this.clone(param_array)
			default:
				l_array := strSplit(param_array)
		}
		if (l_array.length == 0 || param_array == "") {
			return []
		}
		if (param_n == 0) {
			return param_array
		}
		param_n := this.clamp(param_n, 1, l_array.length)
		l_array.removeAt(1, param_n)
		return l_array
	}
	static _hash(dataArray) {
		dataArray := strSplit(this.toString(dataArray))
		data := ""
		for index, value in dataArray {
			if isObject(value) {
				for key, val in value {
					data .= key . val
				}
			} else {
				data .= value
			}
		}
		hash := 0
		for index, char in strSplit(data) {
			hash := (hash * 31) ^ ord(char)
		}
		return format("{:08X}", hash & 0xFFFFFFFF)
	}
	static _createShorthandFn(param_predicate,param_collection:="") {
		switch (type(param_predicate)) {
			case "String", "Integer":
				return this.property(param_predicate)
			case "Array":
				return this.matchesProperty(param_predicate[1], param_predicate[2])
			case "Object", "Map":
				return this.matches(param_predicate)
			default:
				return this.identity
		}
	}
	static _splitWords(param_string:="") {
		l_string := regexReplace(param_string "", "([a-z\d])([A-Z])", "$1 $2")
		l_string := regexReplace(l_string, "([A-Z]+)([A-Z][a-z])", "$1 $2")
		l_string := regexReplace(l_string, "[^A-Za-z\d']+", " ")
		return this.words(l_string)
	}
	static _createPredicate(param_predicate?,param_collection:="") {
		if (!isSet(param_predicate)) {
			return (param_value, *) => param_value
		}
		if (!this.isFunction(param_predicate)) {
			param_predicate := this._createShorthandFn(param_predicate, param_collection)
		}
		fn := param_predicate
		guarded := this._findGuarded(fn)
		switch (guarded.type) {
			case "self":
				switch (guarded.maxParams) {
					case 1:
						return (param_value, *) => fn.call(this, param_value)
					case 2:
						return (param_value, param_key, *) => fn.call(this, param_value, param_key)
					case 3:
						return (param_value, param_key, param_collection) => fn.call(this, param_value, param_key, param_collection)
				}
			case "function":
				switch (guarded.maxParams) {
					case 1:
						return (param_value, *) => fn.call(param_value)
					case 2:
						return (param_value, param_key, *) => fn.call(param_value, param_key)
					case 3:
						return (param_value, param_key, param_collection) => fn.call(param_value, param_key, param_collection)
				}
		}
		if (this.includes(fn.name, this.prototype.__class ".")) {
			switch (fn.maxParams) {
				case 2:
					return (param_value, *) => fn.call(this, param_value)
				case 3:
					return (param_value, param_key, *) => fn.call(this, param_value, param_key)
				case 4:
					return (param_value, param_key, param_collection) => fn.call(this, param_value, param_key, param_collection)
			}
		}
		switch (fn.maxParams) {
			case 0:
				if (fn.isVariadic) {
					return (param_value, param_key, param_collection) => fn.call(param_value, param_key, param_collection)
				}
				return (*) => fn.call()
			case 1:
				return (param_value, *) => fn.call(param_value)
			case 2:
				return (param_value, param_key, *) => fn.call(param_value, param_key)
			default:
				return (param_value, param_key, param_collection) => fn.call(param_value, param_key, param_collection)
		}
	}
	static _throwTypeException(param_received:="",param_expectedType:="") {
		throw valueError("Type Error", -3, "Expected: (" this._formatTypeNames(param_expectedType) ") but received (" type(param_received) ")")
	}
	static _formatTypeNames(typeArray) {
		formattedTypes := []
		for _, typeCheck in typeArray {
			if this.isFunction(typeCheck) {
				typeName := this.last(strSplit(typeCheck.name, "is"))
				formattedTypes.push(this.upperFirst(typeName))
			} else if this.isString(typeCheck) {
				formattedTypes.push(this.upperFirst(typeCheck))
			}
		}
		return this.join(formattedTypes, "|")
	}
	static _findGuarded(param_target) {
		if (type(param_target) == "Func") {
			if (this._guarded.has(param_target.name)) {
				return this._guarded[param_target.name]
			}
		}
		return {type: "none"}
	}
	static _regexMatch(param_haystack,param_regex,param_startingPos:=1) {
		if (regexMatch(param_haystack, param_regex, &l_match, param_startingPos)) {
			return l_match
		}
		return false
	}
	static _stringify(param_value?) {
		if (!IsSet(param_value)) {
			return "unset"
		}
		paramValueType := type(param_value)
		switch paramValueType, false {
			case "string":
				return "'" param_value "'"
			case "integer", "float":
				return param_value
			default:
				selfValue := "", iterValue := "", outValue := ""
				if (!(paramValueType ~= "i)^(Array|Map|Object)$")) {
					try selfValue := this.toString(param_value.ToString())
				}
				if (paramValueType = "object") {
					for key, value in param_value.OwnProps() {
						iterValue .= key ": " this._stringify(value) ", "
					}
					iterValue := rTrim(iterValue, ", ")
				} else if (paramValueType != "Array") {
					try {
						enumValue := param_value.__Enum(2)
						while (enumValue.Call(&enumVal1, &enumVal2)) {
							iterValue .= this._stringify(enumVal1) ": " this._stringify(enumVal2?) ", "
						}
					}
				}
				if (!IsSet(enumValue) && paramValueType != "object") {
					try {
						enumValue := param_value.__Enum(1)
						while (enumValue.Call(&enumVal)) {
							iterValue .= this._stringify(enumVal?) ", "
						}
					}
				}
				iterValue := RTrim(iterValue, ", ")
				if (!selfValue && !iterValue && !((paramValueType = "array" && param_value.Length = 0) || (paramValueType = "Map" && param_value.Count = 0) || (paramValueType = "Object" && ObjOwnPropCount(param_value) = 0))) {
					return paramValueType
				} else if (selfValue && iterValue) {
					outValue .= "value:" selfValue ", iter:[" iterValue "]"
				} else {
					outValue .= selfValue iterValue
				}
				return (paramValueType = "object") ? "{" outValue "}" : (paramValueType = "Array") ? "[" outValue "]" : paramValueType "(" outValue ")"
		}
	}
	static _validateTypes(param_input*) {
		for key, value in param_input {
			if (mod(key, 2) != 0) {
				valid_types := param_input[key + 1]
				current_type := strLower(type(value))
				is_valid := false
				for key, type_check in valid_types {
					if (this.isString(type_check) && current_type = type_check) {
						is_valid := true
						break
					} else if (this.isFunction(type_check)) {
						if (this._includes(type_check.name, this.prototype.__class ".")) {
							if (type_check(this, value)) {
								is_valid := true
								break
							}
							continue
						}
						if (type_check(value)) {
							is_valid := true
							break
						}
					}
				}
				if (!is_valid) {
					this._throwTypeException(value, valid_types)
				}
			}
		}
	}
	static _isFalsey(param_value?) {
		if (isSet(param_value)) {
			switch (param_value) {
				case "":
					return true
				case false:
					return true
			}
		} else {
			return true
		}
		return false
	}
	static _internal_handleShorthand(param_shorthand,param_objects:="") {
		if (this.isFunction(param_shorthand)) {
			return param_shorthand
		}
		if (!isObject(param_shorthand) && (param_shorthand == "__identity" || param_shorthand == "")) {
			return (param_value, *) => param_value
		}
		return this._createShorthandFn(param_shorthand, param_objects)
	}
	static round(param_number,param_precision:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_number, [isNumber], param_precision, [isNumber])
		}
		return round(param_number, param_precision)
	}
	static maxBy(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_hasValue := false
		for key, value in param_array {
			l_criterion := l_iteratee(value, key, param_array)
			if (!l_hasValue || l_criterion > l_max) {
				l_hasValue := true
				l_max := l_criterion
				l_return := value
			}
		}
		return l_hasValue ? l_return : ""
	}
	static multiply(param_multiplier,param_multiplicand) {
		if (this.throwExceptions) {
			this._validateTypes(param_multiplier, [isNumber], param_multiplicand, [isNumber])
		}
		return param_multiplier * param_multiplicand
	}
	static meanBy(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		if (param_array.length == 0) {
			return ""
		}
		return this.sumBy(param_array, param_iteratee?) / param_array.length
	}
	static ceil(param_number,param_precision:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_number, [isNumber], param_precision, [isNumber])
		}
		if (param_precision == 0) {
			return ceil(param_number)
		}
		l_offset := 0.5 / (10 ** param_precision)
		if (param_number < 0 && param_precision >= 1) {
			l_offset /= 10
		}
		l_sum := (param_precision >= 1)
			? format("{:." max(strLen(subStr(param_number, inStr(param_number, ".") + 1))) + 1 "f}", param_number + l_offset)
			: param_number + l_offset
		l_sum := trim(l_sum, "0")
		l_value := (subStr(l_sum, 0) = "5" && param_number != l_sum) ? subStr(l_sum, 1, -1) : l_sum
		return round(l_value, param_precision)
	}
	static divide(param_dividend,param_divisor) {
		if (this.throwExceptions) {
			this._validateTypes(param_dividend, [IsNumber], param_divisor, [isNumber])
		}
		if (param_divisor == 0) {
			return ""
		}
		return param_dividend / param_divisor
	}
	static min(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := []
		for key, value in param_array {
			if (!isSet(value)) {
				continue
			}
			switch (value) {
				case "":
					continue
			}
			l_array.push(value)
		}
		if (l_array.length == 0) {
			return ""
		}
		return min(l_array*)
	}
	static add(param_augend,param_addend) {
		if (this.throwExceptions) {
			this._validateTypes(param_augend, [isNumber], param_addend, [isNumber])
		}
		return param_augend + param_addend
	}
	static subtract(param_minuend,param_subtrahend) {
		if (this.throwExceptions) {
			this._validateTypes(param_minuend, [isNumber], param_subtrahend, [isNumber])
		}
		return param_minuend - param_subtrahend
	}
	static sumBy(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_total := 0
		for key, value in param_array {
			l_total += l_iteratee(value, key, param_array)
		}
		return l_total
	}
	static sum(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, [isObject])
		}
		vSum := 0
		if (param_array.hasProp("__Item")) {
			for key, value in param_array {
				if (isSet(value)) {
					vSum += value
				}
			}
		}
		return vSum
	}
	static floor(param_number,param_precision:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_number, [isNumber], param_precision, [isNumber])
		}
		if (param_precision == 0) {
			return floor(param_number)
		}
		l_offset := -0.5 / (10**param_precision)
		if (param_number < 0 && param_precision >= 1) {
			l_offset /= 10
		}
		if (param_precision >= 1) {
			l_decChar := strLen( substr(param_number, inStr(param_number, ".") + 1) )
			l_sum := format("{:." this.max([l_decChar, param_precision]) + 1 "f}", param_number + l_offset)
		} else {
			l_sum := param_number + l_offset
		}
		l_sum := trim(l_sum, "0")
		l_value := (subStr(l_sum, 0) = "5") && param_number != l_sum ? subStr(l_sum, 1, -1) : l_sum
		return round(l_value, param_precision)
	}
	static max(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_array := []
		for key, value in param_array {
			if (!isSet(value)) {
				continue
			}
			switch (value) {
				case "":
					continue
			}
			l_array.push(value)
		}
		if (l_array.length == 0) {
			return ""
		}
		return max(l_array*)
	}
	static mean(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this.sum(param_array) / this.size(param_array)
	}
	static minBy(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_hasValue := false
		for key, value in param_array {
			l_criterion := l_iteratee(value, key, param_array)
			if (!l_hasValue || l_criterion < l_min) {
				l_hasValue := true
				l_min := l_criterion
				l_return := value
			}
		}
		return l_hasValue ? l_return : ""
	}
	static clamp(param_number,param_lower,param_upper) {
		if (this.throwExceptions) {
			this._validateTypes(param_number, [isNumber], param_lower, [isNumber]
				, param_upper, [isNumber])
		}
		if (param_number < param_lower) {
			param_number := param_lower
		}
		if (param_number > param_upper) {
			param_number := param_upper
		}
		return param_number
	}
	static inRange(param_number,param_start:=0,param_end:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_number, [isNumber], param_start, [isNumber]
				, param_end, ["string", isNumber])
		}
		if (param_end == "") {
			param_end := param_start
			param_start := 0
		}
		if (param_start > param_end) {
			l_temp := param_start
			param_start := param_end
			param_end := l_temp
		}
		if (param_number >= param_start && param_number < param_end) {
			return true
		}
		return false
	}
	static random(param_lower:=0,param_upper:=1,param_floating:=false) {
		if (this.throwExceptions) {
			this._validateTypes(param_lower, [isNumber], param_upper, [isNumber]
				, param_floating, [this.isBoolean])
		}
		if (param_lower == true && param_upper == 1 && param_floating == false) {
			param_lower := 0
			param_floating := true
		}
		if (param_lower > param_upper) {
			l_temp := param_lower
			param_lower := param_upper
			param_upper := l_temp
		}
		if (param_floating) {
			param_lower += 0.0
			param_upper += 0.0
		}
		return random(param_lower, param_upper)
	}
	static isString(param) => (type(param) == "String")
	static clone(param_value) {
		if (isObject(param_value)) {
			newObj := param_value.clone()
			for key, value in param_value {
				newObj[key] := value
			}
			return newObj
		} else {
			return param_value
		}
	}
	static isBuffer(param_value) => (type(param_value) == "Buffer")
	static isMatch(param_object,param_source) {
		if (!isObject(param_source)) {
			return (!isObject(param_object) && param_object == param_source)
		}
		if (!isObject(param_object)) {
			return false
		}
		switch (type(param_source)) {
			case "Array":
				if (type(param_object) != "Array") {
					return false
				}
				for value in param_source {
					l_found := false
					for value2 in param_object {
						if (isSet(value2) && this.isMatch(value2, value)) {
							l_found := true
							break
						}
					}
					if (!l_found) {
						return false
					}
				}
			case "Map":
				if (!(param_object is Map)) {
					return false
				}
				for key, value in param_source {
					if (!param_object.has(key) || !this.isMatch(param_object[key], value)) {
						return false
					}
				}
			default:
				for key, value in param_source.ownProps() {
					if (!param_object.hasProp(key) || !this.isMatch(param_object.%key%, value)) {
						return false
					}
				}
		}
		return true
	}
	static isObject(param) => isObject(param)
	static isError(param_value) {
		return isObject(param_value) && (param_value is Error)
	}
	static isInteger(param) => (type(param) == "Integer")
	static toString(param_value) {
		if (isObject(param_value)) {
			return this.join(param_value, ",")
		} else {
			return "" param_value
		}
	}
	static isBoolean(param) => (this.includes([true, false], param))
	static isMap(param_value?) => (type(param_value) == "Map")
	static isUndefined(param_value) => (!isSet(param_value))
	static isFunction(param) => (this.includes(["BoundFunc", "Func", "Closure"], type(param)))
	static isNumber(param) => isNumber(param)
	static typeOf(param_value?) => this.toLower(type(param_value))
	static isFloat(param) => (type(param) == "Float")
	static isNative(param_value) {
		if (this.isFunction(param_value) && param_value.IsBuiltIn == true) {
			return true
		}
		return false
	}
	static isEmpty(param_value) {
		if (isSet(param_value)) {
			switch (type(param_value)) {
				case "Array":
					return (param_value.length == 0)
				case "Object":
					return (ObjGetCapacity(param_value) == 0)
				case "Map":
					return (param_value.count == 0)
				default:
					return false
			}
		}
		return false
	}
	static isArray(param) => (type(param) == "Array")
	static isAlnum(param) {
		if (type(param) == "String") {
			if (isAlnum(param)) {
				return true
			}
		}
		return false
	}
	static cloneDeep(param) {
		if (!isObject(param)) {
			return param
		}
		if (param.hasProp("__Item")) {
			clone := []
			for value in param {
				clone.push(this.cloneDeep(value))
			}
		} else {
			clone := {}
			for key, value in param.OwnProps() {
				clone.%key% := this.cloneDeep(value)
			}
		}
		return clone
	}
	static isEqual(param_value,param_other*) {
		for value in param_other {
			if (!this._baseIsEqual(param_value, value?, map())) {
				return false
			}
		}
		return true
	}
	static _baseIsEqual(param_a?,param_b?,param_stack:="") {
		if (!isSet(param_a) || !isSet(param_b)) {
			return (!isSet(param_a) && !isSet(param_b))
		}
		if (!isObject(param_a) || !isObject(param_b)) {
			if (isObject(param_a) || isObject(param_b)) {
				return false
			}
			if (isNumber(param_a) && isNumber(param_b)) {
				return (param_a == param_b)
			}
			return (strCompare(param_a, param_b, this.stringCaseSense) == 0)
		}
		if (param_a == param_b) {
			return true
		}
		if (type(param_a) != type(param_b)) {
			return false
		}
		if (param_stack.has(param_a)) {
			return (param_stack[param_a] == param_b)
		}
		param_stack[param_a] := param_b
		l_result := true
		switch (type(param_a)) {
			case "Array":
				if (param_a.length != param_b.length) {
					l_result := false
				} else {
					loop (param_a.length) {
						l_hasA := param_a.has(A_Index)
						if (l_hasA != param_b.has(A_Index)) {
							l_result := false
							break
						}
						if (l_hasA && !this._baseIsEqual(param_a[A_Index], param_b[A_Index], param_stack)) {
							l_result := false
							break
						}
					}
				}
			case "Map":
				if (param_a.count != param_b.count) {
					l_result := false
				} else {
					for key, value in param_a {
						if (!param_b.has(key) || !this._baseIsEqual(value, param_b[key], param_stack)) {
							l_result := false
							break
						}
					}
				}
			case "Func", "BoundFunc", "Closure", "Enumerator", "ComObject", "Buffer":
				l_result := false
			default:
				if (objOwnPropCount(param_a) != objOwnPropCount(param_b)) {
					l_result := false
				} else {
					for key, value in param_a.ownProps() {
						if (!param_b.hasOwnProp(key) || !this._baseIsEqual(value, param_b.%key%, param_stack)) {
							l_result := false
							break
						}
					}
				}
		}
		param_stack.delete(param_a)
		return l_result
	}
	static get(paramObject,paramPath,param_defaultValue:="") {
		if (this.throwExceptions) {
			this._validateTypes(paramObject, [isObject], paramPath, ["string", isObject])
		}
		if (!isObject(paramPath)) {
			paramPath := this.toPath(paramPath)
		}
		currentValue := paramObject
		for key, part in paramPath {
			switch (type(currentValue)) {
				case "Object":
					if (currentValue.hasOwnProp(part)) {
						currentValue := currentValue.%part%
					} else {
						return param_defaultValue
					}
				case "Array":
					if (isInteger(part) && currentValue.has(part)) {
						currentValue := currentValue[part]
					} else {
						return param_defaultValue
					}
				default:
					return param_defaultValue
			}
		}
		return currentValue
	}
	static set(paramObject,paramPath,paramValue) {
		if (this.throwExceptions) {
			this._validateTypes(paramObject, [isObject], paramPath, ["string", isObject])
		}
		if (!isObject(paramPath)) {
			paramPath := this.toPath(paramPath)
		}
		currentObject := paramObject
		for key, part in paramPath {
			if (key = paramPath.length) {
				switch (type(currentObject)) {
					case "Object":
						currentObject.%part% := paramValue
					case "Array":
						currentObject.insertAt(part, paramValue)
				}
			} else {
				switch (type(currentObject)) {
					case "Object":
						if (!currentObject.hasOwnProp(part)) {
							currentObject.%part% := isInteger(paramPath[key + 1]) ? [] : {}
						}
						currentObject := currentObject.%part%
					case "Array":
						if (part >= currentObject.length) {
							loop (part - currentObject.length) {
								currentObject.push({})
							}
						}
						if (!IsObject(currentObject[part])) {
							currentObject[part] := isInteger(paramPath[key + 1]) ? [] : {}
						}
						currentObject := currentObject[part]
				}
			}
		}
		return paramObject
	}
	static once(param_func) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		return this.before(2, param_func)
	}
	static after(param_n, param_func) {
		if (this.throwExceptions) {
			this._validateTypes(param_n, [this.isNumber], param_func, [this.isFunction])
		}
		l_count := param_n
		fn(param_args*) {
			if (--l_count < 1) {
				return param_func.call(param_args*)
			}
			return ""
		}
		return fn
	}
	static before(param_n, param_func) {
		if (this.throwExceptions) {
			this._validateTypes(param_n, [this.isNumber], param_func, [this.isFunction])
		}
		l_count := param_n
		l_result := ""
		fn(param_args*) {
			if (--l_count > 0) {
				l_result := param_func.call(param_args*)
			}
			return l_result
		}
		return fn
	}
	static repeat(param_string,param_number:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_number, [isNumber])
		}
		if (param_number <= 0) {
			return ""
		}
		return strReplace(format("{:0" param_number "}", 0), "0", param_string)
	}
	static padStart(param_string:="",param_length:=0,param_chars:=" ") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"], param_length, [isNumber]
				, param_chars, ["string"])
		}
		stringLength := strLen(param_string)
		if (param_length <= stringLength) {
			return param_string
		}
		padLength := param_length - stringLength
		padChars := param_chars
		while (strLen(padChars) < padLength) {
			padChars .= padChars
		}
		return subStr(padChars, 1, padLength) . param_string
	}
	static pad(param_string:="",param_length:=0,param_chars:=" ") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"], param_length, [isNumber]
				, param_chars, ["string"])
		}
		if (param_length <= strLen(param_string)) {
			return param_string
		}
		param_length := param_length - strLen(param_string)
		l_start := floor(param_length / 2)
		l_end := ceil(param_length / 2)
		l_start := this.padStart("", l_start, param_chars)
		l_end := this.padEnd("", l_end, param_chars)
		return l_start param_string l_end
	}
	static parseInt(param_string,param_radix:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer"], param_radix, [isNumber])
		}
		inputString := "" param_string
		inputString := this.trimStart(inputString, A_Tab A_Space)
		sign := 1
		if (inputString != "" && subStr(inputString, 1, 1) == "-") {
			sign := -1
			inputString := subStr(inputString, 2)
		} else if (inputString != "" && subStr(inputString, 1, 1) == "+") {
			inputString := subStr(inputString, 2)
		}
		radix := round(param_radix)
		stripPrefix := true
		if (radix == 0) {
			radix := 10
		} else {
			if (radix < 2 || radix > 36) {
				return ""
			}
			if (radix != 16) {
				stripPrefix := false
			}
		}
		if (stripPrefix && strLen(inputString) >= 2 && (subStr(inputString, 1, 2) == "0x" || subStr(inputString, 1, 2) == "0X")) {
			inputString := subStr(inputString, 3)
			radix := 16
		}
		validDigits := ""
		loop (strLen(inputString)) {
			char := subStr(inputString, A_Index, 1)
			if (!inStr(subStr("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 1, radix), char)) {
				break
			}
			validDigits .= char
		}
		if (validDigits == "") {
			return ""
		}
		mathInt := 0
		loop (strLen(validDigits)) {
			digit := subStr(validDigits, A_Index, 1)
			mathInt := mathInt * radix + (("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" ~= "i)" digit) - 1)
		}
		return sign * mathInt
	}
	static trim(param_string,param_chars:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_chars, ["string", "integer", "float"])
		}
		if (param_chars == "") {
			return this.trim(param_string, "`r`n" A_space A_tab)
		} else {
			l_string := this.trimStart(param_string, param_chars)
			l_string := this.trimEnd(l_string, param_chars)
			return l_string
		}
	}
	static trimEnd(param_string,param_chars:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_chars, ["string", "integer", "float"])
		}
		if (param_chars == "") {
			return rtrim(param_string)
		}
		stringLength := strLen(param_string)
		endIndex := stringLength
		while (endIndex > 0 && inStr(param_chars, subStr(param_string, endIndex, 1))) {
			endIndex--
		}
		return subStr(param_string, 1, endIndex)
	}
	static upperFirst(param_string:="") {
		return this.toUpper(subStr(param_string, 1, 1)) subStr(param_string, 2)
	}
	static lowerCase(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_words := this._splitWords(param_string)
		l_string := ""
		for key, value in l_words {
			l_string .= (key > 1 ? " " : "") this.toLower(value)
		}
		return l_string
	}
	static trimStart(param_string,param_chars := "") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_chars, ["string", "integer", "float"])
		}
		if (param_chars = "") {
			return regexReplace(param_string, "^\s+")
		} else {
			l_array := strSplit(param_chars)
			l_removechars := ""
			for key, value in l_array {
				if (regexMatch(value, "[a-zA-Z0-9]")) {
					l_removechars .= value
				} else {
					l_removechars .= "\" value
				}
			}
			l_pattern := "^[" l_removechars "]+"
			l_pos := regexMatch(param_string, l_pattern, &l_match)
			if (l_pos > 0) {
				return subStr(param_string, l_pos + l_match.len)
			} else {
				return param_string
			}
		}
	}
	static lowerFirst(param_string := "") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"])
		}
		if (param_string == "") {
			return ""
		}
		firstChar := subStr(param_string, 1, 1)
		restOfString := subStr(param_string, 2)
		return StrLower(firstChar) . restOfString
	}
	static camelCase(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_words := this._splitWords(param_string)
		l_string := ""
		for key, value in l_words {
			if (key == 1) {
				l_string .= this.toLower(value)
			} else {
				l_string .= this.upperFirst(this.toLower(value))
			}
		}
		return l_string
	}
	static kebabCase(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_words := this._splitWords(param_string)
		l_string := ""
		for key, value in l_words {
			l_string .= (key > 1 ? "-" : "") this.toLower(value)
		}
		return l_string
	}
	static split(param_string:="",param_separator?,param_limit?) {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
			if (isSet(param_separator)) {
				this._validateTypes(param_separator, ["string", "integer", "float"])
			}
			if (isSet(param_limit)) {
				this._validateTypes(param_limit, [isNumber])
			}
		}
		l_string := param_string ""
		l_limit := isSet(param_limit) ? integer(param_limit) : -1
		l_array := []
		if (l_limit == 0) {
			return l_array
		}
		if (!isSet(param_separator)) {
			l_array.push(l_string)
			return l_array
		}
		l_separator := param_separator ""
		if (regexMatch(l_separator, "s)^/(.*)/([gimsuxy]*)$", &l_reMatch)) {
			l_options := regexReplace(l_reMatch[2], "[guy]")
			l_needle := (l_options != "" ? l_options ")" : "") l_reMatch[1]
			l_size := strLen(l_string)
			if (l_size == 0) {
				if (!regexMatch(l_string, l_needle)) {
					l_array.push(l_string)
				}
				return l_array
			}
			l_pos := 1
			l_search := 1
			while (l_search <= l_size) {
				if (!regexMatch(l_string, l_needle, &l_match, l_search) || l_match.pos > l_size) {
					break
				}
				l_end := l_match.pos + l_match.len
				if (l_end == l_pos) {
					l_search := l_match.pos + 1
					continue
				}
				l_array.push(subStr(l_string, l_pos, l_match.pos - l_pos))
				if (l_array.length == l_limit) {
					return l_array
				}
				loop (l_match.count) {
					l_array.push(l_match[A_Index])
					if (l_array.length == l_limit) {
						return l_array
					}
				}
				l_pos := l_end
				l_search := (l_match.len == 0) ? l_end + 1 : l_end
			}
			l_array.push(subStr(l_string, l_pos))
			return l_array
		}
		if (l_separator == "") {
			loop parse, l_string {
				l_array.push(A_LoopField)
				if (l_array.length == l_limit) {
					break
				}
			}
			return l_array
		}
		l_sepLen := strLen(l_separator)
		l_pos := 1
		while (l_found := inStr(l_string, l_separator, true, l_pos)) {
			l_array.push(subStr(l_string, l_pos, l_found - l_pos))
			if (l_array.length == l_limit) {
				return l_array
			}
			l_pos := l_found + l_sepLen
		}
		l_array.push(subStr(l_string, l_pos))
		return l_array
	}
	static toLower(param_string) {
		return strLower(param_string)
	}
	static escape(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"])
		}
		HTMLmap := [["&","&amp;"], ["<","&lt;"], [">","&gt;"], ["`"","&quot;"], ["'","&#39;"]]
		for key, value in HTMLmap {
			param_string := strReplace(param_string, value[1], value[2], true, , -1)
		}
		return param_string
	}
	static truncate(param_string,param_options:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		if (!isObject(param_options)) {
			param_options := {}
			param_options.length := 30
		}
		if (!param_options.hasOwnProp("omission")) {
			param_options.omission := "..."
		}
		if (!param_options.hasOwnProp("separator")) {
			param_options.separator := ""
		}
		if (strLen(param_string) < param_options.length && !param_options.separator) {
			return param_string
		}
		l_string := subStr(param_string, 1, param_options.length)
		if (param_options.separator) {
			return regexReplace(l_string, "^(.{1," param_options.length "})" param_options.separator ".*$", "$1") param_options.omission
		}
		if (strLen(l_string) < strLen(param_string)) {
			l_string := subStr(l_string, 1, (strLen(l_string) - strLen(param_options.omission) + 1))
			l_string := l_string . param_options.omission
		}
		return l_string
	}
	static endsWith(param_string,param_needle,param_fromIndex:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"], param_needle, ["string"]
				, param_fromIndex, [isNumber])
		}
		if (param_fromIndex == 0) {
			param_fromIndex := strLen(param_string)
		}
		if (strLen(param_needle) > 1) {
			param_fromIndex := strLen(param_string) - strLen(param_needle) + 1
		}
		l_endChar := subStr(param_string, param_fromIndex, strLen(param_needle))
		if (this.isEqual(l_endChar, param_needle)) {
			return true
		}
		return false
	}
	static upperCase(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_words := this._splitWords(param_string)
		l_string := ""
		for key, value in l_words {
			l_string .= (key > 1 ? " " : "") this.toUpper(value)
		}
		return l_string
	}
	static padEnd(param_string:="",param_length:=0,param_chars:=" ") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"], param_length, [isNumber]
				, param_chars, ["string"])
		}
		stringLength := strLen(param_string)
		if (param_length <= stringLength) {
			return param_string
		}
		padLength := param_length - stringLength
		padChars := param_chars
		while (strLen(padChars) < padLength) {
			padChars .= padChars
		}
		return param_string . subStr(padChars, 1, padLength)
	}
	static toUpper(param_string) {
		return strUpper(param_string)
	}
	static startsWith(param_string,param_needle,param_fromIndex:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_needle, ["string", "integer"]
				, param_fromIndex, [isNumber])
		}
		l_startString := subStr(param_string, param_fromIndex, strLen(param_needle))
		if (this.isEqual(l_startString, param_needle)) {
			return true
		}
		return false
	}
	static words(param_string,param_pattern:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"], param_pattern, ["string"])
		}
		if (param_pattern == "") {
			param_pattern := "\b\w+(?:'\w+)?\b"
		}
		localString := param_string
		localArray := []
		while (regexMatch(localString, param_pattern, &reMatch)) {
			localArray.push(reMatch[0])
			localString := subStr(localString, reMatch.pos + reMatch.len)
		}
		return localArray
	}
	static unescape(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string"])
		}
		HTMLmap := [["&","&amp;"], ["<","&lt;"], [">","&gt;"], ["`"","&quot;"], ["'","&#39;"]]
		for key, value in HTMLmap {
			param_string := strReplace(param_string, value[2], value[1], true, , -1)
		}
		return param_string
	}
	static replace(param_string:="",param_pattern:="",param_replacement:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_pattern, ["string", "integer", "float"]
				, param_replacement, ["string", "integer", "float"])
		}
		l_string := param_string ""
		l_pattern := param_pattern ""
		l_replacement := param_replacement ""
		if (l_pattern == "") {
			return l_string
		}
		if (regexMatch(l_pattern, "s)^/(.*)/([gimsuxy]*)$", &l_reMatch)) {
			l_options := regexReplace(l_reMatch[2], "[guy]")
			l_needle := (l_options != "" ? l_options ")" : "") l_reMatch[1]
			return regexReplace(l_string, l_needle, l_replacement, , 1)
		}
		return strReplace(l_string, l_pattern, l_replacement, true, , 1)
	}
	static snakeCase(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_words := this._splitWords(param_string)
		l_string := ""
		for key, value in l_words {
			l_string .= (key > 1 ? "_" : "") this.toLower(value)
		}
		return l_string
	}
	static startCase(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_words := this._splitWords(param_string)
		l_string := ""
		for key, value in l_words {
			l_string .= (key > 1 ? " " : "") this.upperFirst(this.toLower(value))
		}
		return l_string
	}
}
