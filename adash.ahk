class adash {
	; --- Static Variables ---
	static stringCaseSense := false
	static throwExceptions := true
	static VERSION := "0.8.0"
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
		, this.prototype.__class ".ary", { maxParams: 1, type: "self" }
		, this.prototype.__class ".curry", { maxParams: 1, type: "self" }
		, this.prototype.__class ".curryRight", { maxParams: 1, type: "self" }
		, "Trim", { maxParams: 1, type: "function" }
		, "LTrim", { maxParams: 1, type: "function" }
		, "RTrim", { maxParams: 1, type: "function" })
	; --- Static Methods ---
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
	static differenceBy(param_arrays*) {
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
		l_excluded := map()
		for i, arr in l_arrays {
			if (i == 1) {
				continue
			}
			for key, value in arr {
				l_excluded[this._hash(l_iteratee(value, key, arr))] := true
			}
		}
		l_result := []
		for key, value in l_arrays[1] {
			if (!l_excluded.has(this._hash(l_iteratee(value, key, l_arrays[1])))) {
				l_result.push(value)
			}
		}
		return l_result
	}
	static differenceWith(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_comparator := (a, b) => this._pullEquals(a, b)
		if (l_arrays.length > 0 && this.isFunction(l_arrays[l_arrays.length])) {
			l_comparator := this._bindFn(l_arrays.pop())
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
		for key, value in l_arrays[1] {
			l_found := false
			for i, arr in l_arrays {
				if (i == 1) {
					continue
				}
				for other in arr {
					if (l_comparator(value, other)) {
						l_found := true
						break
					}
				}
				if (l_found) {
					break
				}
			}
			if (!l_found) {
				l_result.push(value)
			}
		}
		return l_result
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
	static fill(param_array,param_value,param_start:=1,param_end:=-1) {
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
	static intersection(param_arrays*) {
		if (this.throwExceptions) {
			for value in param_arrays {
				this._validateTypes(value, ["array", "object"])
			}
		}
		if (param_arrays.length == 0) {
			return []
		}
		for value in param_arrays {
			if (this.isString(value) || type(value) == "Map") {
				return []
			}
		}
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
	static intersectionWith(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_comparator := (a, b) => this._pullEquals(a, b)
		if (l_arrays.length > 0 && this.isFunction(l_arrays[l_arrays.length])) {
			l_comparator := this._bindFn(l_arrays.pop())
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
		for key, value in l_arrays[1] {
			l_isShared := true
			for i, arr in l_arrays {
				if (i == 1) {
					continue
				}
				l_found := false
				for other in arr {
					if (l_comparator(value, other)) {
						l_found := true
						break
					}
				}
				if (!l_found) {
					l_isShared := false
					break
				}
			}
			if (!l_isShared) {
				continue
			}
			l_duplicate := false
			for kept in l_result {
				if (l_comparator(value, kept)) {
					l_duplicate := true
					break
				}
			}
			if (!l_duplicate) {
				l_result.push(value)
			}
		}
		return l_result
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
	static last(param_array) {
		if (!isObject(param_array)) {
			param_array := strSplit(param_array)
		}
		if (param_array.length == 0) {
			return ""
		}
		return param_array[param_array.length]
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
	static pull(param_array,param_values*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this.pullAll(param_array, param_values)
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
	static pullAllWith(param_array,param_values,param_comparator?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"], param_values, ["array"])
			if (isSet(param_comparator)) {
				this._validateTypes(param_comparator, [this.isFunction])
			}
		}
		if (!isSet(param_comparator)) {
			return this.pullAll(param_array, param_values)
		}
		fn := param_comparator
		if (this.includes(fn.name, this.prototype.__class ".")) {
			l_comparator := (a, b) => fn.call(this, a, b)
		} else {
			l_comparator := (a, b) => fn.call(a, b)
		}
		return this._basePullAll(param_array, param_values, "", l_comparator)
	}
	static pullAt(param_array,param_indexes*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_indexes := []
		for value in param_indexes {
			if (isObject(value)) {
				for key, index in value {
					l_indexes.push(index)
				}
			} else {
				l_indexes.push(value)
			}
		}
		l_original := this.clone(param_array)
		l_removed := []
		l_remove := map()
		for index in l_indexes {
			if (index >= 1 && index <= l_original.length) {
				l_removed.push(l_original[index])
				l_remove[index] := true
			}
		}
		l_write := 0
		for key, value in l_original {
			if (!l_remove.has(key)) {
				param_array[++l_write] := value
			}
		}
		param_array.length := l_write
		return l_removed
	}
	static remove(param_array,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_original := this.clone(param_array)
		l_removed := []
		l_write := 0
		for key, value in l_original {
			if (l_predicate(value, key, l_original)) {
				l_removed.push(value)
			} else {
				param_array[++l_write] := value
			}
		}
		param_array.length := l_write
		return l_removed
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
	static sortedIndexBy(param_array,param_value,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_computed := l_iteratee(param_value, "", param_array)
		l_low := 1
		l_high := param_array.length + 1
		while (l_low < l_high) {
			l_mid := (l_low + l_high) // 2
			if (this._compareValues(l_iteratee(param_array[l_mid], l_mid, param_array), l_computed) < 0) {
				l_low := l_mid + 1
			} else {
				l_high := l_mid
			}
		}
		return l_low
	}
	static sortedIndexOf(param_array,param_value) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_index := this.sortedIndexBy(param_array, param_value)
		if (l_index <= param_array.length && this.isEqual(param_array[l_index], param_value)) {
			return l_index
		}
		return -1
	}
	static sortedLastIndex(param_array,param_value) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this.sortedLastIndexBy(param_array, param_value)
	}
	static sortedLastIndexBy(param_array,param_value,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_computed := l_iteratee(param_value, "", param_array)
		l_low := 1
		l_high := param_array.length + 1
		while (l_low < l_high) {
			l_mid := (l_low + l_high) // 2
			if (this._compareValues(l_iteratee(param_array[l_mid], l_mid, param_array), l_computed) <= 0) {
				l_low := l_mid + 1
			} else {
				l_high := l_mid
			}
		}
		return l_low
	}
	static sortedLastIndexOf(param_array,param_value) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		l_index := this.sortedLastIndex(param_array, param_value) - 1
		if (l_index >= 1 && this.isEqual(param_array[l_index], param_value)) {
			return l_index
		}
		return -1
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
	static sortedUniqBy(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_array := []
		l_hasLast := false
		l_last := ""
		for key, value in param_array {
			l_computed := l_iteratee(value, key, param_array)
			if (!l_hasLast || !this.isEqual(l_last, l_computed)) {
				l_hasLast := true
				l_last := l_computed
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
	static takeRightWhile(param_array,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_index := param_array.length
		while (l_index >= 1 && l_predicate(param_array[l_index], l_index, param_array)) {
			l_index--
		}
		l_array := []
		for key, value in param_array {
			if (key > l_index) {
				l_array.push(value)
			}
		}
		return l_array
	}
	static takeWhile(param_array,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_array)
		l_array := []
		for key, value in param_array {
			if (!l_predicate(value, key, param_array)) {
				break
			}
			l_array.push(value)
		}
		return l_array
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
	static unionBy(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_hasIteratee := false
		if (l_arrays.length > 0 && type(l_arrays[l_arrays.length]) != "Array") {
			if (this.throwExceptions) {
				this._validateTypes(l_arrays[l_arrays.length], ["string", "integer", "array", "object", "map", this.isFunction])
			}
			l_iteratee := l_arrays.pop()
			l_hasIteratee := true
		}
		if (this.throwExceptions) {
			for key, value in l_arrays {
				this._validateTypes(value, ["array"])
			}
		}
		l_combined := []
		for arr in l_arrays {
			for value in arr {
				l_combined.push(value)
			}
		}
		return l_hasIteratee ? this.uniqBy(l_combined, l_iteratee) : this.uniqBy(l_combined)
	}
	static unionWith(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_hasComparator := false
		if (l_arrays.length > 0 && this.isFunction(l_arrays[l_arrays.length])) {
			l_comparator := l_arrays.pop()
			l_hasComparator := true
		}
		if (this.throwExceptions) {
			for key, value in l_arrays {
				this._validateTypes(value, ["array"])
			}
		}
		l_combined := []
		for arr in l_arrays {
			for value in arr {
				l_combined.push(value)
			}
		}
		return l_hasComparator ? this.uniqWith(l_combined, l_comparator) : this.uniqWith(l_combined)
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
	static uniqBy(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_array)
		l_seen := map()
		l_array := []
		for key, value in param_array {
			l_hash := this._hash(l_iteratee(value, key, param_array))
			if (!l_seen.has(l_hash)) {
				l_seen[l_hash] := true
				l_array.push(value)
			}
		}
		return l_array
	}
	static uniqWith(param_array,param_comparator?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_comparator)) {
				this._validateTypes(param_comparator, [this.isFunction])
			}
		}
		l_comparator := (a, b) => this._pullEquals(a, b)
		if (isSet(param_comparator)) {
			l_comparator := this._bindFn(param_comparator)
		}
		l_array := []
		for key, value in param_array {
			l_duplicate := false
			for kept in l_array {
				if (l_comparator(value, kept)) {
					l_duplicate := true
					break
				}
			}
			if (!l_duplicate) {
				l_array.push(value)
			}
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
	static unzipWith(param_array,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, [this.isFunction])
			}
		}
		if (param_array.length == 0) {
			return []
		}
		l_grouped := this.unzip(param_array)
		if (!isSet(param_iteratee)) {
			return l_grouped
		}
		l_fn := this._bindFn(param_iteratee)
		l_array := []
		for group in l_grouped {
			l_array.push(l_fn(group*))
		}
		return l_array
	}
	static without(param_array,param_values*) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this._basePullAll(param_array.clone(), param_values, "", (a, b) => this._pullEquals(a, b))
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
	static xorBy(param_arrays*) {
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
		l_counts := map()
		for key, arr in l_arrays {
			l_seen := map()
			for key2, value in arr {
				l_hash := this._hash(l_iteratee(value, key2, arr))
				if (!l_seen.has(l_hash)) {
					l_seen[l_hash] := true
					l_counts[l_hash] := l_counts.get(l_hash, 0) + 1
				}
			}
		}
		l_array := []
		l_added := map()
		for key, arr in l_arrays {
			for key2, value in arr {
				l_hash := this._hash(l_iteratee(value, key2, arr))
				if (l_counts[l_hash] == 1 && !l_added.has(l_hash)) {
					l_added[l_hash] := true
					l_array.push(value)
				}
			}
		}
		return l_array
	}
	static xorWith(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_comparator := (a, b) => this._pullEquals(a, b)
		if (l_arrays.length > 0 && this.isFunction(l_arrays[l_arrays.length])) {
			l_comparator := this._bindFn(l_arrays.pop())
		}
		if (this.throwExceptions) {
			for key, value in l_arrays {
				this._validateTypes(value, ["array"])
			}
		}
		l_array := []
		for i, arr in l_arrays {
			for key, value in arr {
				l_inOther := false
				for j, other in l_arrays {
					if (j == i) {
						continue
					}
					for item in other {
						if (l_comparator(value, item)) {
							l_inOther := true
							break
						}
					}
					if (l_inOther) {
						break
					}
				}
				if (l_inOther) {
					continue
				}
				l_duplicate := false
				for kept in l_array {
					if (l_comparator(value, kept)) {
						l_duplicate := true
						break
					}
				}
				if (!l_duplicate) {
					l_array.push(value)
				}
			}
		}
		return l_array
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
	static zipObject(param_props?,param_values?) {
		if (this.throwExceptions) {
			if (isSet(param_props)) {
				this._validateTypes(param_props, ["array"])
			}
			if (isSet(param_values)) {
				this._validateTypes(param_values, ["array"])
			}
		}
		if (!isSet(param_props) || !isObject(param_props)) {
			param_props := []
		}
		if (!isSet(param_values) || !isObject(param_values)) {
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
	static zipObjectDeep(param_paths?,param_values?) {
		if (this.throwExceptions) {
			if (isSet(param_paths)) {
				this._validateTypes(param_paths, ["array"])
			}
			if (isSet(param_values)) {
				this._validateTypes(param_values, ["array"])
			}
		}
		if (!isSet(param_paths)) {
			param_paths := []
		}
		if (!isSet(param_values)) {
			param_values := []
		}
		l_obj := {}
		for key, path in param_paths {
			l_value := param_values.has(key) ? param_values[key] : ""
			this.set(l_obj, path, l_value)
		}
		return l_obj
	}
	static zipWith(param_arrays*) {
		l_arrays := param_arrays.clone()
		l_hasIteratee := false
		if (l_arrays.length > 0 && this.isFunction(l_arrays[l_arrays.length])) {
			l_fn := this._bindFn(l_arrays.pop())
			l_hasIteratee := true
		}
		if (l_arrays.length == 0) {
			return []
		}
		l_zipped := this.zip(l_arrays*)
		if (!l_hasIteratee) {
			return l_zipped
		}
		l_array := []
		for group in l_zipped {
			l_array.push(l_fn(group*))
		}
		return l_array
	}
	static countBy(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_collection)
		l_result := {}
		for pair in this._collectionEntries(param_collection) {
			l_key := String(l_iteratee(pair[2], pair[1], param_collection))
			l_result.%l_key% := (l_result.hasOwnProp(l_key) ? l_result.%l_key% : 0) + 1
		}
		return l_result
	}
	static every(param_collection,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		for pair in this._collectionEntries(param_collection) {
			if (!l_predicate(pair[2], pair[1], param_collection)) {
				return false
			}
		}
		return true
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
	static findLast(param_collection,param_predicate?,param_fromIndex?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
			if (isSet(param_fromIndex)) {
				this._validateTypes(param_fromIndex, ["integer"])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		l_entries := this._collectionEntries(param_collection)
		l_size := l_entries.length
		l_start := l_size
		if (isSet(param_fromIndex)) {
			l_start := (param_fromIndex < 0) ? l_size + param_fromIndex + 1 : param_fromIndex
		}
		l_start := Max(Min(l_start, l_size), 0)
		loop l_start {
			pair := l_entries[l_start - A_Index + 1]
			if (l_predicate(pair[2], pair[1], param_collection)) {
				return pair[2]
			}
		}
		return ""
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
	static forEachRight(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_collection
		}
		l_iteratee := this._createPredicate(param_iteratee, param_collection)
		l_entries := this._collectionEntries(param_collection)
		loop l_entries.length {
			pair := l_entries[l_entries.length - A_Index + 1]
			l_result := l_iteratee(pair[2], pair[1], param_collection)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_collection
	}
	static eachRight(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_collection
		}
		l_iteratee := this._createPredicate(param_iteratee, param_collection)
		l_entries := this._collectionEntries(param_collection)
		loop l_entries.length {
			pair := l_entries[l_entries.length - A_Index + 1]
			l_result := l_iteratee(pair[2], pair[1], param_collection)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_collection
	}
	static groupBy(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_collection)
		l_result := {}
		for pair in this._collectionEntries(param_collection) {
			l_key := String(l_iteratee(pair[2], pair[1], param_collection))
			if (!l_result.hasOwnProp(l_key)) {
				l_result.%l_key% := []
			}
			l_group := l_result.%l_key%
			l_group.push(pair[2])
		}
		return l_result
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
	static keyBy(param_collection,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_collection)
		l_result := {}
		for pair in this._collectionEntries(param_collection) {
			l_key := String(l_iteratee(pair[2], pair[1], param_collection))
			l_result.%l_key% := pair[2]
		}
		return l_result
	}
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
	static orderBy(param_collection,param_iteratees?,param_orders?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratees)) {
				this._validateTypes(param_iteratees, ["string", "integer", "array", "object", "map", this.isFunction])
			}
			if (isSet(param_orders)) {
				this._validateTypes(param_orders, ["string", "array"])
			}
		}
		l_entries := this._collectionEntries(param_collection)
		if (l_entries.length == 0) {
			return []
		}
		l_iteratees := []
		if (!isSet(param_iteratees)) {
			l_iteratees.push(this._createPredicate())
		} else {
			for iteratee in (type(param_iteratees) == "Array" ? param_iteratees : [param_iteratees]) {
				l_iteratees.push(this._createPredicate(iteratee, param_collection))
			}
		}
		l_orders := []
		if (isSet(param_orders)) {
			l_orders := (type(param_orders) == "Array") ? param_orders : [param_orders]
		}
		l_desc := []
		for index, fn in l_iteratees {
			l_desc.push((index <= l_orders.length) && (StrLower(l_orders[index]) == "desc"))
		}
		l_criteria := []
		l_indexes := ""
		for index, pair in l_entries {
			l_keys := []
			for fn in l_iteratees {
				l_keys.push(fn(pair[2], pair[1], param_collection))
			}
			l_criteria.push(l_keys)
			l_indexes .= index "|"
		}
		l_indexes := sort(rTrim(l_indexes, "|"), "D|"
			, (a, b, *) => this._orderByCompare(l_criteria[integer(a)], l_criteria[integer(b)], l_desc) || (a - b))
		l_array := []
		loop parse l_indexes, "|" {
			l_array.push(l_entries[integer(A_LoopField)][2])
		}
		return l_array
	}
	static _orderByCompare(param_a,param_b,param_desc) {
		for i, x in param_a {
			result := this._sortByCompare([x], [param_b[i]])
			if (param_desc[i]) {
				result := -result
			}
			if (result != 0) {
				return result
			}
		}
		return 0
	}
	static partition(param_collection,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		l_truthy := []
		l_falsy := []
		for pair in this._collectionEntries(param_collection) {
			if (l_predicate(pair[2], pair[1], param_collection)) {
				l_truthy.push(pair[2])
			} else {
				l_falsy.push(pair[2])
			}
		}
		return [l_truthy, l_falsy]
	}
	static reduce(param_collection,param_iteratee?,param_accumulator?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, [this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			param_iteratee := (acc, *) => acc
		}
		l_entries := this._collectionEntries(param_collection)
		l_start := 1
		if (isSet(param_accumulator)) {
			l_acc := param_accumulator
		} else {
			if (l_entries.length == 0) {
				return ""
			}
			l_acc := l_entries[1][2]
			l_start := 2
		}
		loop (l_entries.length - l_start + 1) {
			pair := l_entries[l_start + A_Index - 1]
			l_acc := this._invokeArity(param_iteratee, [l_acc, pair[2], pair[1], param_collection])
		}
		return l_acc
	}
	static reduceRight(param_collection,param_iteratee?,param_accumulator?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, [this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			param_iteratee := (acc, *) => acc
		}
		l_forward := this._collectionEntries(param_collection)
		l_entries := []
		loop l_forward.length {
			l_entries.push(l_forward[l_forward.length - A_Index + 1])
		}
		l_start := 1
		if (isSet(param_accumulator)) {
			l_acc := param_accumulator
		} else {
			if (l_entries.length == 0) {
				return ""
			}
			l_acc := l_entries[1][2]
			l_start := 2
		}
		loop (l_entries.length - l_start + 1) {
			pair := l_entries[l_start + A_Index - 1]
			l_acc := this._invokeArity(param_iteratee, [l_acc, pair[2], pair[1], param_collection])
		}
		return l_acc
	}
	static reject(param_collection,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_collection, ["array", "object", "map", "string"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_collection)
		l_array := []
		for pair in this._collectionEntries(param_collection) {
			if (!l_predicate(pair[2], pair[1], param_collection)) {
				l_array.push(pair[2])
			}
		}
		return l_array
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
		l_count := l_array.length
		loop (l_count - 1) {
			l_i := l_count - A_Index + 1
			l_j := random(1, l_i)
			l_temp := l_array[l_i]
			l_array[l_i] := l_array[l_j]
			l_array[l_j] := l_temp
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
	static ary(param_func, param_n?) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
			if (isSet(param_n)) {
				this._validateTypes(param_n, ["integer"])
			}
		}
		l_n := param_func.maxParams
		if (isSet(param_n)) {
			l_n := param_n
		}
		fn(param_args*) {
			l_args := []
			loop Min(l_n, param_args.length) {
				l_args.push(param_args[A_Index])
			}
			return param_func.call(l_args*)
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
	static bind(param_func, param_thisArg, param_partials*) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		fn(param_args*) {
			l_args := [param_thisArg]
			for value in param_partials {
				l_args.push(value)
			}
			for value in param_args {
				l_args.push(value)
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static bindKey(param_object, param_key, param_partials*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"], param_key, ["string"])
		}
		fn(param_args*) {
			l_args := []
			for value in param_partials {
				l_args.push(value)
			}
			for value in param_args {
				l_args.push(value)
			}
			l_func := param_object.%param_key%
			return l_func.call(param_object, l_args*)
		}
		return fn
	}
	static curry(param_func, param_arity?) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
			if (isSet(param_arity)) {
				this._validateTypes(param_arity, ["integer"])
			}
		}
		l_arity := param_func.maxParams
		if (isSet(param_arity)) {
			l_arity := param_arity
		}
		collect(l_collected) {
			fn(param_args*) {
				l_all := []
				for value in l_collected {
					l_all.push(value)
				}
				for value in param_args {
					l_all.push(value)
				}
				if (l_all.length >= l_arity) {
					return param_func.call(l_all*)
				}
				return collect(l_all)
			}
			return fn
		}
		return collect([])
	}
	static curryRight(param_func, param_arity?) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
			if (isSet(param_arity)) {
				this._validateTypes(param_arity, ["integer"])
			}
		}
		l_arity := param_func.maxParams
		if (isSet(param_arity)) {
			l_arity := param_arity
		}
		collect(l_collected) {
			fn(param_args*) {
				l_all := []
				for value in param_args {
					l_all.push(value)
				}
				for value in l_collected {
					l_all.push(value)
				}
				if (l_all.length >= l_arity) {
					return param_func.call(l_all*)
				}
				return collect(l_all)
			}
			return fn
		}
		return collect([])
	}
	static debounce(param_func, param_wait:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction], param_wait, ["integer"])
		}
		l_args := []
		l_result := ""
		invoke() {
			l_result := param_func.call(l_args*)
		}
		fn(param_args*) {
			l_args := param_args
			SetTimer(invoke, -Max(param_wait, 1))
			return l_result
		}
		return fn
	}
	static defer(param_func, param_args*) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		l_callback := () => param_func.call(param_args*)
		SetTimer(l_callback, -1)
		return ""
	}
	static delay(param_func, param_wait, param_args*) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction], param_wait, ["integer"])
		}
		l_callback := () => param_func.call(param_args*)
		SetTimer(l_callback, -Max(param_wait, 1))
		return ""
	}
	static flip(param_func) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		fn(param_args*) {
			l_args := []
			loop param_args.length {
				l_args.push(param_args[param_args.length - A_Index + 1])
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static memoize(param_func, param_resolver?) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
			if (isSet(param_resolver)) {
				this._validateTypes(param_resolver, [this.isFunction])
			}
		}
		l_cache := Map()
		l_hasResolver := isSet(param_resolver)
		l_resolver := ""
		if (isSet(param_resolver)) {
			l_resolver := param_resolver
		}
		fn(param_args*) {
			l_key := ""
			if (l_hasResolver) {
				l_key := l_resolver.call(param_args*)
			} else if (param_args.length > 0) {
				l_key := param_args[1]
			}
			if (l_cache.has(l_key)) {
				return l_cache[l_key]
			}
			l_result := param_func.call(param_args*)
			l_cache[l_key] := l_result
			return l_result
		}
		return fn
	}
	static negate(param_predicate) {
		if (this.throwExceptions) {
			this._validateTypes(param_predicate, [this.isFunction])
		}
		fn(param_args*) {
			return !param_predicate.call(param_args*)
		}
		return fn
	}
	static now() {
		loop {
			l_now := A_NowUTC
			l_msec := A_MSec
			if (l_now == A_NowUTC) {
				break
			}
		}
		return DateDiff(l_now, "19700101000000", "Seconds") * 1000 + l_msec
	}
	static once(param_func) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		return this.before(2, param_func)
	}
	static overArgs(param_func, param_transforms?) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
			if (isSet(param_transforms)) {
				this._validateTypes(param_transforms, ["array"])
				for transform in param_transforms {
					this._validateTypes(transform, [this.isFunction])
				}
			}
		}
		if (!isSet(param_transforms)) {
			param_transforms := []
		}
		fn(param_args*) {
			l_args := []
			loop param_args.length {
				if (A_Index <= param_transforms.length) {
					l_args.push(param_transforms[A_Index].call(param_args[A_Index]))
				} else {
					l_args.push(param_args[A_Index])
				}
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static partial(param_func, param_partials*) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		fn(param_args*) {
			l_args := []
			for value in param_partials {
				l_args.push(value)
			}
			for value in param_args {
				l_args.push(value)
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static partialRight(param_func, param_partials*) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		fn(param_args*) {
			l_args := []
			for value in param_args {
				l_args.push(value)
			}
			for value in param_partials {
				l_args.push(value)
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static rearg(param_func, param_indexes) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction], param_indexes, ["array"])
		}
		fn(param_args*) {
			l_args := []
			loop param_args.length {
				l_index := A_Index
				if (A_Index <= param_indexes.length) {
					l_index := param_indexes[A_Index] + 1
				}
				if (l_index > param_args.length) {
					l_args.push("")
				} else {
					l_args.push(param_args[l_index])
				}
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static rest(param_func, param_start?) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
			if (isSet(param_start)) {
				this._validateTypes(param_start, ["integer"])
			}
		}
		l_start := Max(param_func.maxParams - 1, 0)
		if (isSet(param_start)) {
			l_start := Max(param_start, 0)
		}
		fn(param_args*) {
			l_args := []
			loop l_start {
				if (A_Index <= param_args.length) {
					l_args.push(param_args[A_Index])
				} else {
					l_args.push("")
				}
			}
			l_rest := []
			loop param_args.length {
				if (A_Index > l_start) {
					l_rest.push(param_args[A_Index])
				}
			}
			l_args.push(l_rest)
			return param_func.call(l_args*)
		}
		return fn
	}
	static spread(param_func, param_start:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction], param_start, ["integer"])
		}
		l_start := Max(param_start, 0)
		fn(param_args*) {
			l_args := []
			loop l_start {
				if (A_Index <= param_args.length) {
					l_args.push(param_args[A_Index])
				}
			}
			if (param_args.length > l_start) {
				l_spread := param_args[l_start + 1]
				if (type(l_spread) = "Array") {
					for value in l_spread {
						l_args.push(value)
					}
				}
			}
			return param_func.call(l_args*)
		}
		return fn
	}
	static throttle(param_func, param_wait:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction], param_wait, ["integer"])
		}
		l_last := ""
		l_result := ""
		fn(param_args*) {
			if (l_last = "" || A_TickCount - l_last >= param_wait) {
				l_last := A_TickCount
				l_result := param_func.call(param_args*)
			}
			return l_result
		}
		return fn
	}
	static unary(param_func) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		fn(param_value, *) {
			return param_func.call(param_value)
		}
		return fn
	}
	static wrap(param_value, param_wrapper?) {
		if (this.throwExceptions) {
			if (isSet(param_wrapper)) {
				this._validateTypes(param_wrapper, [this.isFunction])
			}
		}
		if (!isSet(param_wrapper)) {
			param_wrapper := (v, *) => v
		}
		fn(param_args*) {
			l_args := [param_value]
			for value in param_args {
				l_args.push(value)
			}
			return param_wrapper.call(l_args*)
		}
		return fn
	}
	static _bindFn(param_fn) {
		if (this.includes(param_fn.name, this.prototype.__class ".")) {
			return (args*) => param_fn.call(this, args*)
		}
		return (args*) => param_fn.call(args*)
	}
	static _collectionEntries(param_collection) {
		l_entries := []
		if (this.isString(param_collection)) {
			for index, char in strSplit(param_collection) {
				l_entries.push([index, char])
			}
		} else if (type(param_collection) == "Object") {
			for key, value in param_collection.ownProps() {
				l_entries.push([key, value])
			}
		} else {
			for key, value in param_collection {
				l_entries.push([key, value])
			}
		}
		return l_entries
	}
	static _compareValues(param_a,param_b) {
		if (isNumber(param_a) && isNumber(param_b)) {
			return (param_a < param_b) ? -1 : ((param_a > param_b) ? 1 : 0)
		}
		return strCompare(param_a, param_b, this.stringCaseSense)
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
	static _internal_handleShorthand(param_shorthand,param_objects:="") {
		if (this.isFunction(param_shorthand)) {
			return param_shorthand
		}
		if (!isObject(param_shorthand) && (param_shorthand == "__identity" || param_shorthand == "")) {
			return (param_value, *) => param_value
		}
		return this._createShorthandFn(param_shorthand, param_objects)
	}
	static _findGuarded(param_target) {
		if (type(param_target) == "Func") {
			if (this._guarded.has(param_target.name)) {
				return this._guarded[param_target.name]
			}
		}
		return {type: "none"}
	}
	static _hash(dataArray) {
		data := this.toString(dataArray)
		hash := 0
		loop parse data {
			hash := (hash * 31) ^ ord(A_LoopField)
		}
		return format("{:08X}", hash & 0xFFFFFFFF)
	}
	static _invokeArity(param_func, param_args) {
		l_count := param_func.isVariadic ? param_args.length : Min(param_func.maxParams, param_args.length)
		l_args := []
		loop l_count {
			l_args.push(param_args[A_Index])
		}
		return param_func.call(l_args*)
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
	static _objectEntries(param_object, param_inherited:=false) {
		l_entries := []
		if (type(param_object) == "Array" || type(param_object) == "Map") {
			for key, value in param_object {
				l_entries.push([key, value])
			}
		} else if (isObject(param_object) && !this.isFunction(param_object)) {
			l_seen := map()
			for key, value in param_object.ownProps() {
				l_seen[key] := true
				l_entries.push([key, value])
			}
			if (param_inherited) {
				l_proto := param_object.Base
				while (isObject(l_proto) && l_proto.__Class != "Object") {
					for key, value in l_proto.ownProps() {
						if (key ~= "^__" || l_seen.has(key)) {
							continue
						}
						l_seen[key] := true
						l_entries.push([key, param_object.%key%])
					}
					l_proto := l_proto.Base
				}
			}
		}
		return l_entries
	}
	static _regexMatch(param_haystack,param_regex,param_startingPos:=1) {
		if (regexMatch(param_haystack, param_regex, &l_match, param_startingPos)) {
			return l_match
		}
		return false
	}
	static _splitWords(param_string:="") {
		l_string := regexReplace(param_string "", "([a-z\d])([A-Z])", "$1 $2")
		l_string := regexReplace(l_string, "([A-Z]+)([A-Z][a-z])", "$1 $2")
		l_string := regexReplace(l_string, "[^A-Za-z\d']+", " ")
		return this.words(l_string)
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
	static castArray(param_value?) {
		if (!isSet(param_value)) {
			return []
		}
		if (this.isArray(param_value)) {
			return param_value
		}
		return [param_value]
	}
	static clone(param_value) {
		if (!isObject(param_value) || this.isFunction(param_value)) {
			return param_value
		}
		switch (type(param_value)) {
			case "Array":
				l_clone := []
				for value in param_value {
					l_clone.push(value)
				}
			case "Map":
				l_clone := map()
				l_clone.caseSense := param_value.caseSense
				for key, value in param_value {
					l_clone[key] := value
				}
			case "Object":
				l_clone := {}
				for key, value in param_value.ownProps() {
					l_clone.%key% := value
				}
			default:
				return param_value
		}
		return l_clone
	}
	static cloneDeep(param) {
		return this._cloneDeep(param, map())
	}
	static _cloneDeep(param,param_stack) {
		if (!isObject(param) || this.isFunction(param)) {
			return param
		}
		if (param_stack.has(param)) {
			return param_stack[param]
		}
		switch (type(param)) {
			case "Array":
				l_clone := []
				param_stack[param] := l_clone
				for value in param {
					l_clone.push(this._cloneDeep(value, param_stack))
				}
			case "Map":
				l_clone := map()
				l_clone.caseSense := param.caseSense
				param_stack[param] := l_clone
				for key, value in param {
					l_clone[key] := this._cloneDeep(value, param_stack)
				}
			case "Object":
				l_clone := {}
				param_stack[param] := l_clone
				for key, value in param.ownProps() {
					l_clone.%key% := this._cloneDeep(value, param_stack)
				}
			default:
				return param
		}
		return l_clone
	}
	static cloneDeepWith(param_value?,param_customizer?) {
		if (this.throwExceptions) {
			if (isSet(param_customizer)) {
				this._validateTypes(param_customizer, [this.isFunction])
			}
		}
		return this._cloneDeepWith(param_value?, param_customizer?)
	}
	static _cloneDeepWith(param_value?,param_customizer?) {
		l_hasCustom := false
		if (isSet(param_customizer)) {
			try {
				l_custom := param_customizer(param_value?)
				l_hasCustom := true
			} catch UnsetError {
			}
		}
		if (l_hasCustom) {
			return l_custom
		}
		if (!isSet(param_value) || !isObject(param_value) || this.isFunction(param_value)) {
			if (isSet(param_value)) {
				return param_value
			}
			return
		}
		switch (type(param_value)) {
			case "Array":
				l_clone := []
				for value in param_value {
					l_clone.push(this._cloneDeepWith(value, param_customizer?))
				}
			case "Map":
				l_clone := map()
				for key, value in param_value {
					l_clone[key] := this._cloneDeepWith(value, param_customizer?)
				}
			case "Object":
				l_clone := {}
				for key, value in param_value.ownProps() {
					l_clone.%key% := this._cloneDeepWith(value, param_customizer?)
				}
			default:
				return param_value
		}
		return l_clone
	}
	static cloneWith(param_value?,param_customizer?) {
		if (this.throwExceptions) {
			if (isSet(param_customizer)) {
				this._validateTypes(param_customizer, [this.isFunction])
			}
		}
		l_hasCustom := false
		if (isSet(param_customizer)) {
			try {
				l_custom := param_customizer(param_value?)
				l_hasCustom := true
			} catch UnsetError {
			}
		}
		if (l_hasCustom) {
			return l_custom
		}
		return this.clone(param_value)
	}
	static conformsTo(param_object?,param_source?) {
		if (this.throwExceptions) {
			this._validateTypes(param_source, ["object"])
		}
		if (!isSet(param_object) || !isObject(param_object)) {
			return false
		}
		for key, predicate in param_source.ownProps() {
			if (!param_object.hasProp(key) || !predicate(param_object.%key%)) {
				return false
			}
		}
		return true
	}
	static eq(param_value?,param_other?) {
		if (!isSet(param_value) || !isSet(param_other)) {
			return (!isSet(param_value) && !isSet(param_other))
		}
		if (isObject(param_value) || isObject(param_other)) {
			return (isObject(param_value) && isObject(param_other) && param_value == param_other)
		}
		l_isNumberA := (type(param_value) == "Integer" || type(param_value) == "Float")
		l_isNumberB := (type(param_other) == "Integer" || type(param_other) == "Float")
		if (l_isNumberA || l_isNumberB) {
			return (l_isNumberA && l_isNumberB && param_value == param_other)
		}
		return (strCompare(param_value, param_other, this.stringCaseSense) == 0)
	}
	static gt(param_value,param_other) => (param_value > param_other)
	static gte(param_value,param_other) => (param_value >= param_other)
	static isAlnum(param) {
		if (type(param) == "String") {
			if (isAlnum(param)) {
				return true
			}
		}
		return false
	}
	static isArguments(param_value?) => false
	static isArray(param) => (type(param) == "Array")
	static isArrayBuffer(param_value?) => (type(param_value?) == "Buffer")
	static isArrayLike(param_value?) => (type(param_value?) == "Array" || type(param_value?) == "Buffer" || type(param_value?) == "String")
	static isArrayLikeObject(param_value?) => (this.isObjectLike(param_value?) && this.isArrayLike(param_value?))
	static isBoolean(param) => (this.includes([true, false], param))
	static isBuffer(param_value) => (type(param_value) == "Buffer")
	static isDate(param_value?) => false
	static isElement(param_value?) => false
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
	static isEqual(param_value,param_other*) {
		for value in param_other {
			if (!this._baseIsEqual(param_value, value?, map())) {
				return false
			}
		}
		return true
	}
	static _baseIsEqual(param_a?,param_b?,param_stack:="",param_customizer:="") {
		if (param_customizer) {
			l_hasCustom := false
			try {
				l_custom := param_customizer(param_a?, param_b?)
				l_hasCustom := true
			} catch UnsetError {
			}
			if (l_hasCustom) {
				return (l_custom ? true : false)
			}
		}
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
						if (l_hasA && !this._baseIsEqual(param_a[A_Index], param_b[A_Index], param_stack, param_customizer)) {
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
						if (!param_b.has(key) || !this._baseIsEqual(value, param_b[key], param_stack, param_customizer)) {
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
						if (!param_b.hasOwnProp(key) || !this._baseIsEqual(value, param_b.%key%, param_stack, param_customizer)) {
							l_result := false
							break
						}
					}
				}
		}
		param_stack.delete(param_a)
		return l_result
	}
	static isEqualWith(param_value?,param_other?,param_customizer?) {
		if (this.throwExceptions) {
			if (isSet(param_customizer)) {
				this._validateTypes(param_customizer, [this.isFunction])
			}
		}
		return this._baseIsEqual(param_value?, param_other?, map(), param_customizer?)
	}
	static isError(param_value) {
		return isObject(param_value) && (param_value is Error)
	}
	static isFinite(param_value) => ((type(param_value) == "Integer" || type(param_value) == "Float") && (param_value - param_value == 0))
	static isFloat(param) => (type(param) == "Float")
	static isFunction(param) => (this.includes(["BoundFunc", "Func", "Closure"], type(param)))
	static isInteger(param) => (type(param) == "Integer")
	static isLength(param_value?) => (type(param_value?) == "Integer" && param_value >= 0 && param_value <= 9007199254740991)
	static isMap(param_value?) => (type(param_value) == "Map")
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
	static isMatchWith(param_object?,param_source?,param_customizer?) {
		if (this.throwExceptions) {
			if (isSet(param_customizer)) {
				this._validateTypes(param_customizer, [this.isFunction])
			}
		}
		return this._isMatchWith(param_object?, param_source?, param_customizer?)
	}
	static _isMatchWith(param_object?,param_source?,param_customizer?) {
		if (type(param_source?) != "Object") {
			return this.isMatch(param_object?, param_source?)
		}
		if (!isSet(param_object) || !isObject(param_object)) {
			return false
		}
		for key, srcValue in param_source.ownProps() {
			if (!param_object.hasProp(key)) {
				return false
			}
			objValue := param_object.%key%
			l_hasCustom := false
			if (isSet(param_customizer)) {
				try {
					l_custom := param_customizer(objValue, srcValue)
					l_hasCustom := true
				} catch UnsetError {
				}
			}
			if (l_hasCustom) {
				if (!l_custom) {
					return false
				}
				continue
			}
			if (!this._isMatchWith(objValue, srcValue, param_customizer?)) {
				return false
			}
		}
		return true
	}
	static isNaN(param_value) => ((type(param_value) == "Float") && (param_value != param_value))
	static isNative(param_value) {
		if (this.isFunction(param_value) && param_value.IsBuiltIn == true) {
			return true
		}
		return false
	}
	static isNil(param_value?) => (!isSet(param_value))
	static isNull(param_value?) => (!isSet(param_value))
	static isNumber(param) => isNumber(param)
	static isObject(param) => isObject(param)
	static isObjectLike(param_value?) => (isSet(param_value) && isObject(param_value) && !this.isFunction(param_value))
	static isPlainObject(param_value) => (type(param_value) == "Object")
	static isRegExp(param_value?) => false
	static isSafeInteger(param_value?) {
	    if (!isSet(param_value)) {
	        return false
	    }
	    return (this.isFinite(param_value) && Floor(param_value) == param_value && Abs(param_value) <= 9007199254740991)
	}
	static isSet(param_value?) => false
	static isString(param) => (type(param) == "String")
	static isSymbol(param_value?) => false
	static isTypedArray(param_value?) => false
	static isUndefined(param_value) => (!isSet(param_value))
	static isWeakMap(param_value?) => false
	static isWeakSet(param_value?) => false
	static lt(param_value,param_other) => (param_value < param_other)
	static lte(param_value,param_other) => (param_value <= param_other)
	static toArray(param_value?) {
		if (!isSet(param_value)) {
			return []
		}
		switch (type(param_value)) {
			case "Array":
				return this.clone(param_value)
			case "Map":
				l_array := []
				for key, value in param_value {
					l_array.push([key, value])
				}
				return l_array
			case "Object":
				l_array := []
				for key, value in param_value.ownProps() {
					l_array.push(value)
				}
				return l_array
			case "String":
				return strSplit(param_value)
		}
		return []
	}
	static toFinite(param_value?) {
		l_number := this.toNumber(param_value?)
		if (l_number == "") {
			return 0
		}
		return l_number
	}
	static toInteger(param_value?) {
		l_number := this.toNumber(param_value?)
		if (l_number == "") {
			return 0
		}
		return Integer(l_number)
	}
	static toLength(param_value?) {
		l_int := this.toInteger(param_value?)
		if (l_int < 0) {
			return 0
		}
		if (l_int > 9007199254740991) {
			return 9007199254740991
		}
		return l_int
	}
	static toNumber(param_value?) {
		if (!isSet(param_value)) {
			return ""
		}
		switch (type(param_value)) {
			case "Integer", "Float":
				return param_value
			case "String":
				if (param_value == "") {
					return 0
				}
				if (isNumber(param_value)) {
					return param_value + 0
				}
		}
		return ""
	}
	static toPlainObject(param_value?) {
		if (!isSet(param_value) || !isObject(param_value) || this.isFunction(param_value)) {
			if (isSet(param_value)) {
				return param_value
			}
			return
		}
		l_obj := {}
		if (type(param_value?) == "Object") {
			for key, value in param_value.ownProps() {
				l_obj.%key% := value
			}
		} else {
			for key, value in param_value {
				l_obj.%key% := value
			}
		}
		return l_obj
	}
	static toSafeInteger(param_value?) {
		l_int := this.toInteger(param_value?)
		if (l_int > 9007199254740991) {
			return 9007199254740991
		}
		if (l_int < -9007199254740991) {
			return -9007199254740991
		}
		return l_int
	}
	static toString(param_value) {
		if (isObject(param_value)) {
			l_output := ""
			if (param_value.hasProp("__Item")) {
				for key, value in param_value {
					l_output .= (isSet(value) ? this.toString(value) : "") ","
				}
			} else {
				for key, value in param_value.ownProps() {
					l_output .= (isSet(value) ? this.toString(value) : "") ","
				}
			}
			return subStr(l_output, 1, -1)
		} else {
			return "" param_value
		}
	}
	static typeOf(param_value?) => this.toLower(type(param_value))
	static add(param_augend,param_addend) {
		if (this.throwExceptions) {
			this._validateTypes(param_augend, [isNumber], param_addend, [isNumber])
		}
		return param_augend + param_addend
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
	static mean(param_array) {
		if (this.throwExceptions) {
			this._validateTypes(param_array, ["array"])
		}
		return this.sum(param_array) / this.size(param_array)
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
	static multiply(param_multiplier,param_multiplicand) {
		if (this.throwExceptions) {
			this._validateTypes(param_multiplier, [isNumber], param_multiplicand, [isNumber])
		}
		return param_multiplier * param_multiplicand
	}
	static round(param_number,param_precision:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_number, [isNumber], param_precision, [isNumber])
		}
		return round(param_number, param_precision)
	}
	static subtract(param_minuend,param_subtrahend) {
		if (this.throwExceptions) {
			this._validateTypes(param_minuend, [isNumber], param_subtrahend, [isNumber])
		}
		return param_minuend - param_subtrahend
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
	static random(param_lower:=0,param_upper?,param_floating:=false) {
		if (this.throwExceptions) {
			this._validateTypes(param_lower, [isNumber], param_floating, [this.isBoolean])
			if (isSet(param_upper)) {
				this._validateTypes(param_upper, [isNumber])
			}
		}
		if (param_lower == true && !isSet(param_upper) && param_floating == false) {
			param_lower := 0
			param_floating := true
		}
		if (!isSet(param_upper)) {
			param_upper := 1
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
	static assign(param_object,param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		for source in param_sources {
			for pair in this._objectEntries(source) {
				key := pair[1]
				param_object.%key% := pair[2]
			}
		}
		return param_object
	}
	static assignIn(param_object,param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		for source in param_sources {
			for pair in this._objectEntries(source, true) {
				key := pair[1]
				param_object.%key% := pair[2]
			}
		}
		return param_object
	}
	static assignInWith(param_object, param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_count := param_sources.length
		l_customizer := ""
		if (l_count > 0 && type(param_sources[l_count]) == "Func") {
			l_customizer := param_sources[l_count]
			l_count -= 1
		}
		l_hasCustomizer := (type(l_customizer) == "Func")
		loop l_count {
			l_source := param_sources[A_Index]
			if (this.throwExceptions) {
				this._validateTypes(l_source, ["object"])
			}
			l_enum := (type(l_source) == "Object") ? l_source.ownProps() : l_source
			for key, srcValue in l_enum {
				l_value := srcValue
				if (l_hasCustomizer) {
					l_current := param_object.hasOwnProp(key) ? param_object.%key% : ""
					l_custom := this._invokeArity(l_customizer, [l_current, srcValue, key, param_object, l_source])
					if (!(type(l_custom) == "String" && l_custom == "")) {
						l_value := l_custom
					}
				}
				param_object.%key% := l_value
			}
		}
		return param_object
	}
	static extendWith(param_object, param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_count := param_sources.length
		l_customizer := ""
		if (l_count > 0 && type(param_sources[l_count]) == "Func") {
			l_customizer := param_sources[l_count]
			l_count -= 1
		}
		l_hasCustomizer := (type(l_customizer) == "Func")
		loop l_count {
			l_source := param_sources[A_Index]
			if (this.throwExceptions) {
				this._validateTypes(l_source, ["object"])
			}
			l_enum := (type(l_source) == "Object") ? l_source.ownProps() : l_source
			for key, srcValue in l_enum {
				l_value := srcValue
				if (l_hasCustomizer) {
					l_current := param_object.hasOwnProp(key) ? param_object.%key% : ""
					l_custom := this._invokeArity(l_customizer, [l_current, srcValue, key, param_object, l_source])
					if (!(type(l_custom) == "String" && l_custom == "")) {
						l_value := l_custom
					}
				}
				param_object.%key% := l_value
			}
		}
		return param_object
	}
	static assignWith(param_object, param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_count := param_sources.length
		l_customizer := ""
		if (l_count > 0 && type(param_sources[l_count]) == "Func") {
			l_customizer := param_sources[l_count]
			l_count -= 1
		}
		l_hasCustomizer := (type(l_customizer) == "Func")
		loop l_count {
			l_source := param_sources[A_Index]
			if (this.throwExceptions) {
				this._validateTypes(l_source, ["object"])
			}
			for key, srcValue in l_source.ownProps() {
				l_value := srcValue
				if (l_hasCustomizer) {
					l_current := param_object.hasOwnProp(key) ? param_object.%key% : ""
					l_custom := this._invokeArity(l_customizer, [l_current, srcValue, key, param_object, l_source])
					if (!(type(l_custom) == "String" && l_custom == "")) {
						l_value := l_custom
					}
				}
				param_object.%key% := l_value
			}
		}
		return param_object
	}
	static at(param_object,param_paths*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_paths := (param_paths.length == 1 && this.isArray(param_paths[1])) ? param_paths[1] : param_paths
		l_result := []
		for path in l_paths {
			l_result.push(this.get(param_object, path))
		}
		return l_result
	}
	static create(param_prototype?,param_properties?) {
		if (this.throwExceptions && isSet(param_prototype)) {
			this._validateTypes(param_prototype, ["object"])
		}
		l_object := {}
		if (isSet(param_prototype)) {
			ObjSetBase(l_object, param_prototype)
		}
		if (isSet(param_properties)) {
			this.assign(l_object, param_properties)
		}
		return l_object
	}
	static defaults(param_object,param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		for source in param_sources {
			for pair in this._objectEntries(source) {
				key := pair[1]
				if (!param_object.hasOwnProp(key)) {
					param_object.%key% := pair[2]
				}
			}
		}
		return param_object
	}
	static defaultsDeep(param_object,param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		for source in param_sources {
			this._defaultsDeep(param_object, source)
		}
		return param_object
	}
	static _defaultsDeep(param_target,param_source) {
		for pair in this._objectEntries(param_source) {
			key := pair[1]
			value := pair[2]
			if (!param_target.hasOwnProp(key)) {
				param_target.%key% := this.cloneDeep(value)
			} else if (type(param_target.%key%) == "Object" && type(value) == "Object") {
				this._defaultsDeep(param_target.%key%, value)
			}
		}
	}
	static entriesIn(param_object) => this.toPairsIn(param_object)
	static extend(param_object,param_sources*) => this.assignIn(param_object, param_sources*)
	static findKey(param_object,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_predicate := this._createPredicate(param_predicate?, param_object)
		for pair in this._objectEntries(param_object) {
			if (l_predicate(pair[2], pair[1], param_object)) {
				return pair[1]
			}
		}
		return ""
	}
	static findLastKey(param_object,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_predicate := this._createPredicate(param_predicate?, param_object)
		l_entries := this._objectEntries(param_object)
		loop l_entries.length {
			pair := l_entries[l_entries.length - A_Index + 1]
			if (l_predicate(pair[2], pair[1], param_object)) {
				return pair[1]
			}
		}
		return ""
	}
	static forIn(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_object
		}
		l_iteratee := this._createPredicate(param_iteratee, param_object)
		for pair in this._objectEntries(param_object, true) {
			l_result := l_iteratee(pair[2], pair[1], param_object)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_object
	}
	static forInRight(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_object
		}
		l_iteratee := this._createPredicate(param_iteratee, param_object)
		l_entries := this._objectEntries(param_object, true)
		loop l_entries.length {
			pair := l_entries[l_entries.length - A_Index + 1]
			l_result := l_iteratee(pair[2], pair[1], param_object)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_object
	}
	static forOwn(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_object
		}
		l_iteratee := this._createPredicate(param_iteratee, param_object)
		for pair in this._objectEntries(param_object) {
			l_result := l_iteratee(pair[2], pair[1], param_object)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_object
	}
	static forOwnRight(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			return param_object
		}
		l_iteratee := this._createPredicate(param_iteratee, param_object)
		l_entries := this._objectEntries(param_object)
		loop l_entries.length {
			pair := l_entries[l_entries.length - A_Index + 1]
			l_result := l_iteratee(pair[2], pair[1], param_object)
			if (!isObject(l_result) && l_result == false) {
				break
			}
		}
		return param_object
	}
	static functions(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := []
		for pair in this._objectEntries(param_object) {
			if (this.isFunction(pair[2])) {
				l_result.push(pair[1])
			}
		}
		return l_result
	}
	static functionsIn(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := []
		for pair in this._objectEntries(param_object, true) {
			if (this.isFunction(pair[2])) {
				l_result.push(pair[1])
			}
		}
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
	static has(param_object,param_path) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"], param_path, ["string", "integer", isObject])
		}
		l_missing := {}
		return this.get(param_object, param_path, l_missing) != l_missing
	}
	static hasIn(param_object,param_path) => this.has(param_object, param_path)
	static invert(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := {}
		for pair in this._objectEntries(param_object) {
			key := "" pair[2]
			l_result.%key% := pair[1]
		}
		return l_result
	}
	static invertBy(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_object)
		l_result := {}
		for pair in this._objectEntries(param_object) {
			key := "" l_iteratee(pair[2], pair[1], param_object)
			if (!l_result.hasOwnProp(key)) {
				l_result.%key% := []
			}
			l_result.%key%.push(pair[1])
		}
		return l_result
	}
	static invoke(param_object,param_path,param_args*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"], param_path, ["string", isObject])
		}
		l_path := this.toPath(param_path)
		l_name := l_path[l_path.length]
		l_owner := this.get(param_object, this.initial(l_path))
		l_method := l_owner.%l_name%
		return l_method.call(l_owner, param_args*)
	}
	static keys(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := []
		for pair in this._objectEntries(param_object) {
			l_result.push(pair[1])
		}
		return l_result
	}
	static keysIn(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := []
		for pair in this._objectEntries(param_object, true) {
			l_result.push(pair[1])
		}
		return l_result
	}
	static mapKeys(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_object)
		l_result := {}
		for pair in this._objectEntries(param_object) {
			key := "" l_iteratee(pair[2], pair[1], param_object)
			l_result.%key% := pair[2]
		}
		return l_result
	}
	static mapValues(param_object,param_iteratee?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_iteratee := this._createPredicate(param_iteratee?, param_object)
		l_result := {}
		for pair in this._objectEntries(param_object) {
			key := pair[1]
			l_result.%key% := l_iteratee(pair[2], key, param_object)
		}
		return l_result
	}
	static merge(param_object, param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array"])
		}
		return this.mergeWith(param_object, param_sources*)
	}
	static mergeWith(param_object, param_sources*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array"])
		}
		l_count := param_sources.length
		l_customizer := ""
		if (l_count > 0 && type(param_sources[l_count]) == "Func") {
			l_customizer := param_sources[l_count]
			l_count -= 1
		}
		l_hasCustomizer := (type(l_customizer) == "Func")
		loop l_count {
			l_source := param_sources[A_Index]
			if (this.throwExceptions) {
				this._validateTypes(l_source, ["object", "array"])
			}
			l_enum := (type(l_source) == "Object") ? l_source.ownProps() : l_source
			for key, srcValue in l_enum {
				l_exists := (type(param_object) == "Array") ? (key <= param_object.length) : param_object.hasOwnProp(key)
				l_isArray := (type(param_object) == "Array")
				l_current := ""
				if (l_exists) {
					l_current := l_isArray ? param_object[key] : param_object.%key%
				}
				if (l_hasCustomizer) {
					l_custom := this._invokeArity(l_customizer, [l_current, srcValue, key, param_object, l_source])
					if (!(type(l_custom) == "String" && l_custom == "")) {
						if (l_isArray) {
							param_object[key] := l_custom
						} else {
							param_object.%key% := l_custom
						}
						continue
					}
				}
				if (type(srcValue) == "Object" || type(srcValue) == "Array") {
					if (l_exists && type(l_current) == type(srcValue)) {
						l_target := l_current
					} else {
						l_target := (type(srcValue) == "Array") ? [] : {}
					}
					if (l_hasCustomizer) {
						this.mergeWith(l_target, srcValue, l_customizer)
					} else {
						this.mergeWith(l_target, srcValue)
					}
					if (l_isArray) {
						param_object[key] := l_target
					} else {
						param_object.%key% := l_target
					}
				} else {
					if (l_isArray) {
						param_object[key] := srcValue
					} else {
						param_object.%key% := srcValue
					}
				}
			}
		}
		return param_object
	}
	static omit(param_object,param_paths*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_paths := (param_paths.length == 1 && this.isArray(param_paths[1])) ? param_paths[1] : param_paths
		l_result := this.cloneDeep(param_object)
		for path in l_paths {
			this.unset(l_result, path)
		}
		return l_result
	}
	static omitBy(param_object,param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_predicate := this._createPredicate(param_predicate?, param_object)
		l_result := {}
		for pair in this._objectEntries(param_object) {
			key := pair[1]
			if (!l_predicate(pair[2], key, param_object)) {
				l_result.%key% := pair[2]
			}
		}
		return l_result
	}
	static pick(param_object,param_paths*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_paths := (param_paths.length == 1 && this.isArray(param_paths[1])) ? param_paths[1] : param_paths
		l_result := {}
		for path in l_paths {
			if (this.has(param_object, path)) {
				this.set(l_result, path, this.get(param_object, path))
			}
		}
		return l_result
	}
	static pickBy(param_object, param_predicate?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
			if (isSet(param_predicate)) {
				this._validateTypes(param_predicate, ["string", "integer", "array", "object", "map", this.isFunction])
			}
		}
		l_predicate := this._createPredicate(param_predicate?, param_object)
		l_result := {}
		for key, value in param_object.ownProps() {
			if (l_predicate(value, key, param_object)) {
				l_result.%key% := value
			}
		}
		return l_result
	}
	static propertyOf(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		return (param_path) => this.get(param_object, param_path)
	}
	static result(param_object,param_path,param_defaultValue:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"], param_path, ["string", "integer", isObject])
		}
		l_missing := {}
		l_value := this.get(param_object, param_path, l_missing)
		if (l_value == l_missing) {
			return param_defaultValue
		}
		if (this.isFunction(l_value)) {
			return l_value.call(param_object)
		}
		return l_value
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
	static setWith(paramObject, paramPath, paramValue, paramCustomizer?) {
		if (this.throwExceptions) {
			this._validateTypes(paramObject, [isObject], paramPath, ["string", isObject])
			if (isSet(paramCustomizer)) {
				this._validateTypes(paramCustomizer, [this.isFunction])
			}
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
				l_existing := ""
				switch (type(currentObject)) {
					case "Object":
						if (currentObject.hasOwnProp(part)) {
							l_existing := currentObject.%part%
						}
					case "Array":
						if (part >= currentObject.length) {
							loop (part - currentObject.length) {
								currentObject.push({})
							}
						}
						l_existing := currentObject[part]
				}
				l_next := ""
				if (isSet(paramCustomizer)) {
					l_next := this._invokeArity(paramCustomizer, [l_existing, part, currentObject])
				}
				if (type(l_next) == "String" && l_next == "") {
					if (isObject(l_existing)) {
						l_next := l_existing
					} else {
						l_next := isInteger(paramPath[key + 1]) ? [] : {}
					}
				}
				switch (type(currentObject)) {
					case "Object":
						currentObject.%part% := l_next
					case "Array":
						currentObject[part] := l_next
				}
				currentObject := l_next
			}
		}
		return paramObject
	}
	static toPairs(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		return this._objectEntries(param_object)
	}
	static entries(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		return this._objectEntries(param_object)
	}
	static toPairsIn(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		return this._objectEntries(param_object, true)
	}
	static transform(param_object,param_iteratee?,param_accumulator?) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
			if (isSet(param_iteratee)) {
				this._validateTypes(param_iteratee, [this.isFunction])
			}
		}
		if (!isSet(param_iteratee)) {
			param_iteratee := (acc, *) => acc
		}
		l_accumulator := isSet(param_accumulator) ? param_accumulator : (this.isArray(param_object) ? [] : {})
		for pair in this._objectEntries(param_object) {
			this._invokeArity(param_iteratee, [l_accumulator, pair[2], pair[1], param_object])
		}
		return l_accumulator
	}
	static unset(param_object,param_path) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"], param_path, ["string", "integer", isObject])
		}
		l_path := this.toPath(param_path)
		l_key := l_path[l_path.length]
		l_owner := this.get(param_object, this.initial(l_path))
		switch (type(l_owner)) {
			case "Object":
				if (l_owner.hasOwnProp(l_key)) {
					l_owner.DeleteProp(l_key)
					return true
				}
			case "Map":
				if (l_owner.has(l_key)) {
					l_owner.Delete(l_key)
					return true
				}
			case "Array":
				if (isInteger(l_key) && l_owner.has(Integer(l_key))) {
					l_owner.RemoveAt(Integer(l_key))
					return true
				}
		}
		return false
	}
	static update(param_object,param_path,param_updater) {
		return this.updateWith(param_object, param_path, param_updater)
	}
	static updateWith(paramObject, paramPath, paramUpdater, paramCustomizer?) {
		if (this.throwExceptions) {
			this._validateTypes(paramObject, [isObject], paramPath, ["string", isObject], paramUpdater, [this.isFunction])
			if (isSet(paramCustomizer)) {
				this._validateTypes(paramCustomizer, [this.isFunction])
			}
		}
		l_updated := paramUpdater.call(this.get(paramObject, paramPath))
		if (isSet(paramCustomizer)) {
			return this.setWith(paramObject, paramPath, l_updated, paramCustomizer)
		}
		return this.setWith(paramObject, paramPath, l_updated)
	}
	static values(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := []
		for pair in this._objectEntries(param_object) {
			l_result.push(pair[2])
		}
		return l_result
	}
	static valuesIn(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		l_result := []
		for pair in this._objectEntries(param_object, true) {
			l_result.push(pair[2])
		}
		return l_result
	}
	static chain(param_value) {
		return this.ChainWrapper(param_value, this)
	}
	class ChainWrapper {
		__New(param_data, param_lib) {
			this.data := param_data
			this.lib := param_lib
		}
		value() {
			return this.data
		}
		tap(param_interceptor) {
			this.lib.tap(this.data, param_interceptor)
			return this
		}
		thru(param_interceptor) {
			return this.lib.ChainWrapper(this.lib.thru(this.data, param_interceptor), this.lib)
		}
		__Call(param_name, param_args) {
			l_result := this.lib.%param_name%(this.data, param_args*)
			return this.lib.ChainWrapper(l_result, this.lib)
		}
	}
	static tap(param_value,param_interceptor) {
		if (this.throwExceptions) {
			this._validateTypes(param_interceptor, ["string", "integer", "array", "object", "map", this.isFunction])
		}
		l_interceptor := this._createPredicate(param_interceptor)
		l_interceptor(param_value, "", "")
		return param_value
	}
	static thru(param_value,param_interceptor) {
		if (this.throwExceptions) {
			this._validateTypes(param_interceptor, ["string", "integer", "array", "object", "map", this.isFunction])
		}
		l_interceptor := this._createPredicate(param_interceptor)
		return l_interceptor(param_value, "", "")
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
	static capitalize(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		return this.upperFirst(this.toLower(param_string ""))
	}
	static deburr(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_table := StrSplit("A|A|A|A|A|A|Ae|C|E|E|E|E|I|I|I|I|D|N|O|O|O|O|O||O|U|U|U|U|Y|Th|ss"
			. "|a|a|a|a|a|a|ae|c|e|e|e|e|i|i|i|i|d|n|o|o|o|o|o||o|u|u|u|u|y|th|y", "|")
		l_map := map()
		for index, value in l_table {
			if (value != "") {
				l_map[Chr(0xBF + index)] := value
			}
		}
		l_string := ""
		loop parse, param_string "" {
			l_string .= l_map.has(A_LoopField) ? l_map[A_LoopField] : A_LoopField
		}
		return l_string
	}
	static endsWith(param_string:="",param_needle:="",param_fromIndex:=0) {
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
	static escapeRegExp(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		return regexReplace(param_string "", "[\\^$.*+?()[\]{}|]", "\$0")
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
	static repeat(param_string:="",param_number:=1) {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"], param_number, [isNumber])
		}
		if (param_number <= 0) {
			return ""
		}
		return strReplace(format("{:0" param_number "}", 0), "0", param_string)
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
	static startsWith(param_string:="",param_needle:="",param_fromIndex:=1) {
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
	static template(param_string:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_template := param_string ""
		return (param_data:="") => this._templateRender(l_template, param_data)
	}
	static _templateRender(param_template,param_data) {
		l_output := ""
		l_pos := 1
		while (regexMatch(param_template, "<%([=-])\s*(.+?)\s*%>|\$\{\s*(.+?)\s*\}", &l_match, l_pos)) {
			l_output .= subStr(param_template, l_pos, l_match.pos - l_pos)
			l_path := (l_match[2] != "") ? l_match[2] : l_match[3]
			l_value := isObject(param_data) ? (this.get(param_data, l_path) "") : ""
			l_output .= (l_match[1] == "-") ? this.escape(l_value) : l_value
			l_pos := l_match.pos + l_match.len
		}
		return l_output . subStr(param_template, l_pos)
	}
	static toLower(param_string:="") {
		return strLower(param_string)
	}
	static toUpper(param_string:="") {
		return strUpper(param_string)
	}
	static trim(param_string:="",param_chars:="") {
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
	static trimEnd(param_string:="",param_chars:="") {
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
	static trimStart(param_string:="",param_chars := "") {
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
	static truncate(param_string:="",param_options:="") {
		if (this.throwExceptions) {
			this._validateTypes(param_string, ["string", "integer", "float"])
		}
		l_string := param_string ""
		l_length := 30
		l_omission := "..."
		l_separator := ""
		if (isObject(param_options)) {
			if (param_options.hasOwnProp("length")) {
				l_length := integer(param_options.length)
			}
			if (param_options.hasOwnProp("omission")) {
				l_omission := param_options.omission ""
			}
			if (param_options.hasOwnProp("separator")) {
				l_separator := param_options.separator ""
			}
		}
		if (strLen(l_string) <= l_length) {
			return l_string
		}
		l_end := l_length - strLen(l_omission)
		if (l_end < 1) {
			return l_omission
		}
		l_result := subStr(l_string, 1, l_end)
		if (l_separator == "") {
			return l_result l_omission
		}
		if (regexMatch(l_separator, "s)^/(.*)/([gimsuxy]*)$", &l_reMatch)) {
			l_options := regexReplace(l_reMatch[2], "[guy]")
			l_needle := (l_options != "" ? l_options ")" : "") l_reMatch[1]
			if (regexMatch(subStr(l_string, l_end + 1), l_needle) != 1) {
				l_found := false
				l_cut := 0
				l_size := strLen(l_result)
				l_search := 1
				while (l_search <= l_size + 1 && regexMatch(l_result, l_needle, &l_match, l_search)) {
					l_found := true
					l_cut := l_match.pos - 1
					l_search := l_match.pos + max(l_match.len, 1)
				}
				if (l_found) {
					l_result := subStr(l_result, 1, l_cut)
				}
			}
			return l_result l_omission
		}
		if (inStr(l_string, l_separator, true, l_end + 1) != l_end + 1) {
			l_index := 0
			l_pos := 1
			while (l_found := inStr(l_result, l_separator, true, l_pos)) {
				l_index := l_found
				l_pos := l_found + 1
			}
			if (l_index) {
				l_result := subStr(l_result, 1, l_index - 1)
			}
		}
		return l_result l_omission
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
	static upperFirst(param_string:="") {
		return this.toUpper(subStr(param_string, 1, 1)) subStr(param_string, 2)
	}
	static words(param_string:="",param_pattern:="") {
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
	static attempt(param_func,param_args*) {
		if (this.throwExceptions) {
			this._validateTypes(param_func, [this.isFunction])
		}
		try {
			return param_func.call(param_args*)
		} catch as l_error {
			return l_error
		}
	}
	static bindAll(param_object,param_methodNames*) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object"])
		}
		l_names := (param_methodNames.length == 1 && this.isArray(param_methodNames[1])) ? param_methodNames[1] : param_methodNames
		for name in l_names {
			param_object.%name% := this._bindMethod(param_object, param_object.%name%)
		}
		return param_object
	}
	static _bindMethod(param_object,param_func) {
		return (param_self?, param_args*) => param_func.call(param_object, param_args*)
	}
	static cond(param_pairs) {
		if (this.throwExceptions) {
			this._validateTypes(param_pairs, ["array"])
		}
		fn(param_args*) {
			for pair in param_pairs {
				if (pair[1].call(param_args*)) {
					return pair[2].call(param_args*)
				}
			}
			return ""
		}
		return fn
	}
	static conforms(param_source) {
		if (this.throwExceptions) {
			this._validateTypes(param_source, ["object"])
		}
		return (param_object) => this.conformsTo(param_object, param_source)
	}
	static constant(param_value) {
		return (*) => param_value
	}
	static defaultTo(param_value?,param_defaultValue?) {
		if (!isSet(param_value) || this.isNaN(param_value)) {
			return param_defaultValue
		}
		return param_value
	}
	static flow(param_funcs*) {
		l_funcs := (param_funcs.length == 1 && this.isArray(param_funcs[1])) ? param_funcs[1] : param_funcs
		if (this.throwExceptions) {
			for item in l_funcs {
				this._validateTypes(item, [this.isFunction])
			}
		}
		fn(param_args*) {
			l_value := ""
			loop l_funcs.length {
				l_value := (A_Index = 1) ? l_funcs[A_Index].call(param_args*) : l_funcs[A_Index].call(l_value)
			}
			return l_value
		}
		return fn
	}
	static flowRight(param_funcs*) {
		l_funcs := (param_funcs.length == 1 && this.isArray(param_funcs[1])) ? param_funcs[1] : param_funcs
		if (this.throwExceptions) {
			for item in l_funcs {
				this._validateTypes(item, [this.isFunction])
			}
		}
		fn(param_args*) {
			l_value := ""
			loop l_funcs.length {
				l_func := l_funcs[l_funcs.length - A_Index + 1]
				l_value := (A_Index = 1) ? l_func.call(param_args*) : l_func.call(l_value)
			}
			return l_value
		}
		return fn
	}
	static identity(param_value) => param_value
	static iteratee(param_func?) {
		return this._createPredicate(param_func?, "")
	}
	static matches(param_source) {
		if (this.throwExceptions) {
			this._validateTypes(param_source, ["object", "array", "map"])
		}
		l_source := this.cloneDeep(param_source)
		return (param_itaree) => this.isMatch(param_itaree, l_source)
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
	static method(param_path,param_args*) {
		return (param_object) => this.invoke(param_object, param_path, param_args*)
	}
	static methodOf(param_object) {
		if (this.throwExceptions) {
			this._validateTypes(param_object, ["object", "array", "map"])
		}
		return (param_path, param_args*) => this.invoke(param_object, param_path, param_args*)
	}
	static mixin(param_object?,param_source?) {
		if (isSet(param_source)) {
			l_target := param_object
			l_source := param_source
		} else {
			l_target := this
			l_source := param_object
		}
		if (this.throwExceptions) {
			this._validateTypes(l_source, ["object"])
		}
		for pair in this._objectEntries(l_source) {
			if (this.isFunction(pair[2])) {
				key := pair[1]
				l_target.%key% := pair[2]
			}
		}
		return l_target
	}
	static noConflict() => this
	static noop(param_args*) => ""
	static nthArg(param_n:=0) {
		if (this.throwExceptions) {
			this._validateTypes(param_n, [this.isNumber])
		}
		fn(param_args*) {
			l_index := (param_n >= 0) ? param_n + 1 : param_args.length + param_n + 1
			return (l_index >= 1 && l_index <= param_args.length) ? param_args[l_index] : ""
		}
		return fn
	}
	static over(param_iteratees*) {
		l_iteratees := (param_iteratees.length == 1 && this.isArray(param_iteratees[1])) ? param_iteratees[1] : param_iteratees
		if (this.throwExceptions) {
			for item in l_iteratees {
				this._validateTypes(item, [this.isFunction])
			}
		}
		fn(param_args*) {
			l_result := []
			for iteratee in l_iteratees {
				l_result.push(iteratee.call(param_args*))
			}
			return l_result
		}
		return fn
	}
	static overEvery(param_predicates*) {
		l_predicates := (param_predicates.length == 1 && this.isArray(param_predicates[1])) ? param_predicates[1] : param_predicates
		if (this.throwExceptions) {
			for item in l_predicates {
				this._validateTypes(item, [this.isFunction])
			}
		}
		fn(param_args*) {
			for predicate in l_predicates {
				if (!predicate.call(param_args*)) {
					return false
				}
			}
			return true
		}
		return fn
	}
	static overSome(param_predicates*) {
		l_predicates := (param_predicates.length == 1 && this.isArray(param_predicates[1])) ? param_predicates[1] : param_predicates
		if (this.throwExceptions) {
			for item in l_predicates {
				this._validateTypes(item, [this.isFunction])
			}
		}
		fn(param_args*) {
			for predicate in l_predicates {
				if (predicate.call(param_args*)) {
					return true
				}
			}
			return false
		}
		return fn
	}
	static property(param_path) {
		if (this.throwExceptions) {
			this._validateTypes(param_path, ["string", "integer", isObject])
		}
		l_path := isObject(param_path) ? param_path : this.toPath(string(param_path))
		return (param_itaree) => (isObject(param_itaree) ? this.get(param_itaree, l_path) : "")
	}
	static range(param_start:=0,param_end?,param_step?) {
		if (this.throwExceptions) {
			this._validateTypes(param_start, [this.isNumber])
			if (isSet(param_end)) {
				this._validateTypes(param_end, [this.isNumber])
			}
			if (isSet(param_step)) {
				this._validateTypes(param_step, [this.isNumber])
			}
		}
		if (!isSet(param_end)) {
			l_end := param_start
			l_start := 0
		} else {
			l_start := param_start
			l_end := param_end
		}
		l_step := isSet(param_step) ? param_step : (l_start < l_end ? 1 : -1)
		l_length := Max(Ceil((l_end - l_start) / (l_step == 0 ? 1 : l_step)), 0)
		l_array := []
		loop Integer(l_length) {
			l_array.push(l_start + (A_Index - 1) * l_step)
		}
		return l_array
	}
	static rangeRight(param_start:=0,param_end?,param_step?) {
		l_range := this.range(param_start, param_end?, param_step?)
		l_array := []
		loop l_range.length {
			l_array.push(l_range[l_range.length - A_Index + 1])
		}
		return l_array
	}
	static runInContext(param_context?) => this
	static stubArray() => []
	static stubFalse() => false
	static stubObject() {
		return {}
	}
	static stubString() => ""
	static stubTrue() => true
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
	static uniqueId(param_prefix:="") {
		l_last := this.HasOwnProp("_uniqueIdCounter") ? this._uniqueIdCounter : 0
		this._uniqueIdCounter := l_last + 1
		return "" param_prefix this._uniqueIdCounter
	}
}
