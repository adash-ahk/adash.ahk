class adash {
	; --- Static Variables ---
	static stringCaseSense := false
	static throwExceptions := true
	static limit := -1
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
	static chunk(param_array,param_size:=1) {
		if ((!isObject(param_array) && !this.isString(param_array)) || !this.isNumber(param_size)) {
			this._throwTypeException()
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
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		l_array := []
		for key, value in param_array {
			if (value == "" || value == 0) {
				continue
			}
			l_array.push(value)
		}
		return l_array
	}
	static depthOf(param, param_depth := 1) {
		if (!isObject(param)) {
			this._throwTypeException()
		}
		if (param.hasProp("__Item")) {
			for key, value in param {
				if (isObject(value)) {
					param_depth := this.depthOf(value, param_depth + 1)
				}
			}
		} else {
			for key, value in param.ownProps() {
				if (isObject(value)) {
					param_depth := this.depthOf(value, param_depth + 1)
				}
			}
		}
		return param_depth
	}
	static difference(param_array,param_values*) {
		if (!isObject(param_array)) {
			this._throwTypeException()
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
	static drop(param_array, param_n := 1) {
		if (!this.isNumber(param_n)) {
			this._throwTypeException()
		}
		if (param_array == [] || param_array == "") {
			return []
		}
		if (param_n == 0) {
			return param_array
		}
		if (isObject(param_array)) {
			l_array := this.clone(param_array)
		} else {
			l_array := strSplit(param_array)
		}
		param_n := this.clamp(param_n, 1, l_array.length)
		loop (param_n) {
			l_array.removeAt(1)
		}
		return l_array
	}
	static dropRight(param_array,param_n:=1) {
		if (!this.isNumber(param_n)) {
			this._throwTypeException()
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
	static fill(param_array,param_value:="",param_start:=1,param_end:=-1) {
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		if (param_end == -1) {
			param_end := this.size(param_array)
		}
		for key, value in param_array {
			if (key >= param_start && key <= param_end) {
				param_array[key] := param_value
			}
		}
		return param_array
	}
	static flatten(param_array) {
		if (!isObject(param_array)) {
			this._throwTypeException()
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
		if (!isObject(param_array)) {
			this._throwTypeException()
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
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		l_obj := this.cloneDeep(param_array)
		loop (param_depth) {
			l_obj := this.flatten(l_obj)
		}
		return l_obj
	}
	static fromPairs(param_pairs) {
		if (!isObject(param_pairs)) {
			this._throwTypeException()
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
	static indexOf(param_array,param_value,fromIndex:=1) {
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		if (isObject(param_value)) {
			param_value := this._hash(param_value)
			param_array := this.map(param_array, this._hash)
		}
		if (param_array.hasProp("__Item")) {
			for key, value in param_array {
				if (A_Index < fromIndex) {
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
		} else {
			for key, value in param_array.ownProps() {
				if (A_Index < fromIndex) {
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
		if (!isObject(param_arrays[1])) {
			this._throwTypeException()
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
	static join(param_array,param_separator:=",") {
		if (!isObject(param_array) || isObject(param_separator)) {
			this._throwTypeException()
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
		if (param_fromIndex == 0) {
			param_fromIndex := param_array.length
		}
		for index, value in param_array {
			index -= 1
			l_negativeIndex := param_array.length - index
			if (l_negativeIndex > param_fromIndex) {
				continue
			}
			if (this.isEqual(param_array[l_negativeIndex], param_value)) {
				return l_negativeIndex
			}
		}
		return -1
	}
	static nth(param_array,param_n:=1) {
		if (!this.isNumber(param_n)) {
			this._throwTypeException()
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
	static reverse(param_collection) {
		if (!isObject(param_collection)) {
			this._throwTypeException()
		}
		l_collection := this.cloneDeep(param_collection)
		l_array := []
		while (l_collection.length != 0) {
			l_array.push(l_collection.pop())
		}
		return l_array
	}
	static slice(param_array,param_start:=1,param_end:=0) {
		if (!this.isNumber(param_start)) {
			this._throwTypeException()
		}
		if (!this.isNumber(param_end)) {
			this._throwTypeException()
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
	static sortedIndex(param_array, param_value) {
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
	static sortedUniq(param_collection) {
		if (!isObject(param_collection)) {
			this._throwTypeException()
		}
		l_array := []
		l_temp := ""
		for key, value in param_collection {
			printedelement := this._stringify(param_collection[key])
			if (!this.isEqual(l_temp, printedelement)) {
				l_temp := printedelement
				l_array.push(value)
			}
		}
		return l_array
	}
	static tail(param_array) {
		return this.drop(param_array)
	}
	static take(param_array,param_n:=1) {
		if (!this.isNumber(param_n)) {
			this._throwTypeException()
		}
		if (isObject(param_array)) {
			param_array := this.clone(param_array)
		} else {
			param_array := strSplit(param_array)
		}
		l_array := []
		for index, value in param_array {
			if (index > param_n) {
				break
			}
			l_array.push(value)
		}
		if (l_array.length == 0 || param_n == 0) {
			return []
		}
		return l_array
	}
	static takeRight(param_array, param_n:=1) {
		if (!this.isNumber(param_n)) {
			this._throwTypeException()
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
	static union(arrays*) {
		combinedArray := []
		for each, value in arrays {
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
	static uniq(param_collection) {
		if (!isObject(param_collection)) {
			this._throwTypeException()
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
	static without(param_array,param_values*) {
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		l_array := this.clone(param_array)
		for i, val in param_values {
			while (foundindex := this.indexOf(l_array, val) != -1) {
				l_array.removeAt(foundindex)
			}
		}
		return l_array
	}
	static zip(param_arrays*) {
		if (!isObject(param_arrays)) {
			this._throwTypeException()
		}
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
	static zipObject(param_props,param_values) {
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
	static includes(param_collection,param_value,param_fromIndex:=1) {
		if (!this.isNumber(param_fromIndex)) {
			this._throwTypeException()
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
	static map(param_collection,param_iteratee:="__identity") {
		if (!isObject(param_collection) && !this.isString(param_collection)) {
			this._throwTypeException()
		}
		if (this.isString(param_collection)) {
			l_collection := strSplit(param_collection)
		} else {
			l_collection := this.cloneDeep(param_collection)
		}
		l_array := []
		valType := type(l_collection)
		switch (valType) {
			case "Object":
				for key, value in l_collection.ownProps() {
					l_array.push(this._applyPredicate(l_collection, key, value, param_iteratee))
				}
			default:
				for key, value in l_collection {
					l_array.push(this._applyPredicate(l_collection, key, value, param_iteratee))
				}
		}
		return l_array
	}
	static sample(param_collection) {
		if (!this.isString(param_collection) && !isObject(param_collection)) {
			this._throwTypeException()
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
	static shuffle(param_collection) {
		if (!isObject(param_collection)) {
			this._throwTypeException()
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
	static size(param_collection) {
		switch type(param_collection), false {
			case "array":
				return param_collection.length
			case "object":
				return objOwnPropCount(param_collection)
			case "string":
				return strLen(param_collection)
			case "map":
				return param_collection.count
			default:
				return 0
		}
		return ""
	}
	static _applyPredicate(param_collection,param_key,param_value,param_predicate) {
		if (param_predicate == "__identity") {
			param_predicate := this.identity
		}
		guarded := this._findGuarded(param_predicate)
		switch (guarded.type) {
			case "self":
				switch (guarded.maxParams) {
					case 1:
						return param_predicate.call(this, param_value)
					case 2:
						return param_predicate.call(this, param_value, param_key)
					case 3:
						return param_predicate.call(this, param_value, param_key, param_collection)
				}
			case "function":
				switch (guarded.maxParams) {
					case 1:
						return param_predicate.call(param_value)
					case 2:
						return param_predicate.call(param_value, param_key)
					case 3:
						return param_predicate.call(param_value, param_key, param_collection)
				}
		}
		if (this.includes(param_predicate.name, this.prototype.__class ".")) {
			switch (param_predicate.maxParams) {
				case 2:
					return param_predicate.call(this, param_value)
				case 3:
					return param_predicate.call(this, param_value, param_key)
				case 4:
					return param_predicate.call(this, param_value, param_key, param_collection)
			}
		}
		switch (param_predicate.maxParams) {
			case 1:
				return param_predicate.call(param_value)
			case 2:
				return param_predicate.call(param_value, param_key)
			case 3:
				return param_predicate.call(param_value, param_key, param_collection)
		}
	}
	static _findGuarded(target) {
		if (this._guarded.has(target.name)) {
			return this._guarded[target.name]
		}
		return {type: "none"}
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
				try selfValue := this.toString(param_value.ToString())
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
	static clone(param_value) {
		if (IsObject(param_value)) {
			newObj := param_value.clone()
			for key, value in param_value {
				newObj[key] := value
			}
			return newObj
		} else {
			return param_value
		}
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
	static isAlnum(param) {
		if (type(param) == "String") {
			if (isAlnum(param)) {
				return true
			}
		}
		return false
	}
	static isArray(param) {
		if (type(param) == "Array") {
			return true
		}
		return false
	}
	static isBoolean(param) {
		if (param == 1) {
			return true
		}
		if (param == 0) {
			return true
		}
		return false
	}
	static isBuffer(param_value) {
		if (type(param_value) == "Buffer") {
			return true
		}
		return false
	}
	static isEqual(param_value,param_other*) {
		if (isObject(param_value)) {
			l_array := this.map(param_other, this._stringify)
			param_value := this._stringify(param_value)
		} else {
			l_array := this.cloneDeep(param_other)
		}
		if (this.isNumber(param_value)) {
			for key, value in l_array {
				if (param_value != value) {
					return false
				}
			}
			return true
		}
		for key, value in l_array {
			if (isObject(value)) {
				value := this._stringify(value)
				msgbox(value)
			}
			if (strCompare(param_value, value, this.stringCaseSense) != 0) {
				return false
			}
		}
		return true
	}
	static isFloat(param) {
		if(type(param) == "Float") {
			return true
		}
		return false
	}
	static isFunction(param) {
		if (this.includes(["BoundFunc", "Func"], type(param))) {
			return true
		}
		return false
	}
	static isInteger(param) {
		if(type(param) == "Integer") {
			return true
		}
		return false
	}
	static isMatch(param_object,param_source) {
		if (param_source.hasProp("__Item")) {
			for key, value in param_source {
				if (value == param_object[key]) {
					continue
				} else {
					return false
				}
			}
		} else {
			for key, value in param_source.ownProps() {
				if (!param_object.hasProp(key)) {
					return false
				}
				if (value == param_object.%key%) {
					continue
				} else {
					return false
				}
			}
		}
		return true
	}
	static isNumber(param) {
		if (isNumber(param)) {
			return true
		}
		return false
	}
	static isObject(param) {
		if (isObject(param)) {
			return true
		}
		return false
	}
	static isString(param) {
		if (type(param) == "String") {
			return true
		}
		return false
	}
	static isUndefined(param_value) {
		if (!isSet(param_value)) {
			return true
		}
		return false
	}
	static toString(param_value) {
		if (isObject(param_value)) {
			return this.join(param_value, ",")
		} else {
			return "" param_value
		}
	}
	static typeOf(param_value?) {
		return this.toLower(type(param_value))
	}
	static add(param_augend,param_addend) {
		if (!this.isNumber(param_augend) || !this.isNumber(param_addend)) {
			this._throwTypeException()
		}
		return param_augend + param_addend
	}
	static ceil(param_number, param_precision := 0) {
		if (!this.isNumber(param_number) || !this.isNumber(param_precision)) {
			this._throwTypeException()
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
		if (!this.isNumber(param_dividend) || !this.isNumber(param_divisor)) {
			this._throwTypeException()
		}
		if (param_divisor == 0) {
			return ""
		}
		return param_dividend / param_divisor
	}
	static floor(param_number,param_precision:=0) {
		if (!this.isNumber(param_number) || !this.isNumber(param_precision)) {
			this._throwTypeException()
		}
		if (param_precision == 0) { ; regular floor
			return floor(param_number)
		}
		l_offset := -0.5 / (10**param_precision)
		if (param_number < 0 && param_precision >= 1) {
			l_offset /= 10 ; adjust offset for negative numbers and positive param_precision
		}
		if (param_precision >= 1) {
			l_decChar := strLen( substr(param_number, inStr(param_number, ".") + 1) ) ; count the number of decimal characters
			l_sum := format("{:." this.max([l_decChar, param_precision]) + 1 "f}", param_number + l_offset)
		} else {
			l_sum := param_number + l_offset
		}
		l_sum := trim(l_sum, "0") ; trim zeroes
		l_value := (subStr(l_sum, 0) = "5") && param_number != l_sum ? subStr(l_sum, 1, -1) : l_sum ; if last char is 5 then remove it unless it is part of the original string
		return round(l_value, param_precision)
	}
	static max(param_array) {
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		if (this.size(param_array) == 0 || !this.isArray(param_array)) {
			return ""
		}
		return max(param_array*)
	}
	static mean(param_array) {
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		return this.sum(param_array) / this.size(param_array)
	}
	static min(paramArray) {
		if (!this.isArray(paramArray)) {
			this._throwTypeException()
		}
		if (paramArray.length == 0) {
			return ""
		}
		for key, value in paramArray {
			if (isSet(value) && value != "") {
				l_min := value
				break
			}
		}
		if (!isSet(l_min)) {
			return ""
		}
		for key, value in paramArray {
			if (isSet(value) && value != "" && value < l_min) {
				l_min := value
			}
		}
		return l_min
	}
	static multiply(param_multiplier,param_multiplicand) {
		if (!this.isNumber(param_multiplier) || !this.isNumber(param_multiplicand)) {
			this._throwTypeException()
		}
		return param_multiplier * param_multiplicand
	}
	static round(param_number,param_precision:=0) {
		if (!this.isNumber(param_number) || !this.isNumber(param_precision)) {
			this._throwTypeException()
		}
		return round(param_number, param_precision)
	}
	static subtract(param_minuend,param_subtrahend) {
		if (!this.isNumber(param_minuend) || !this.isNumber(param_subtrahend)) {
			this._throwTypeException()
		}
		return param_minuend - param_subtrahend
	}
	static sum(param_array) {
		if (!isObject(param_array)) {
			this._throwTypeException()
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
	static clamp(param_number,param_lower,param_upper) {
		if (!this.isNumber(param_number) || !this.isNumber(param_lower) || !this.isNumber(param_upper)) {
			this._throwTypeException()
		}
		if (param_number < param_lower) {
			param_number := param_lower
		}
		if (param_number > param_upper) {
			param_number := param_upper
		}
		return param_number
	}
	static random(param_lower:=0,param_upper:=1,param_floating:=false) {
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
	static endsWith(param_string,param_needle,param_fromIndex:=0) {
		if (!this.isString(param_string) || !this.isString(param_needle) || !this.isNumber(param_fromIndex)) {
			this._throwTypeException()
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
		if (!this.isString(param_string)) {
			this._throwTypeException()
		}
		HTMLmap := [["&","&amp;"], ["<","&lt;"], [">","&gt;"], ["`"","&quot;"], ["'","&#39;"]]
		for key, value in HTMLmap {
			param_string := strReplace(param_string, value[1], value[2], true, , -1)
		}
		return param_string
	}
	static lowerFirst(paramString := "") {
		if (!this.isString(paramString)) {
			this._throwTypeException()
		}
		if (paramString == "") {
			return ""
		}
		firstChar := subStr(paramString, 1, 1)
		restOfString := subStr(paramString, 2)
		return StrLower(firstChar) . restOfString
	}
	static pad(param_string:="",param_length:=0,param_chars:=" ") {
		if (!this.isString(param_string) || !this.isNumber(param_length) || !this.isString(param_chars)) {
			this._throwTypeException()
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
	static padEnd(paramString := "", paramLength := 0, paramChars := " ") {
		if (!this.isString(paramString) || !this.isNumber(paramLength) || !this.isString(paramChars)) {
			this._throwTypeException()
		}
		stringLength := strLen(paramString)
		if (paramLength <= stringLength) {
			return paramString
		}
		padLength := paramLength - stringLength
		padChars := paramChars
		while (strLen(padChars) < padLength) {
			padChars .= padChars
		}
		return paramString . subStr(padChars, 1, padLength)
	}
	static padStart(paramString := "", paramLength := 0, paramChars := " ") {
		if (!this.isString(paramString) || !this.isNumber(paramLength) || !this.isString(paramChars)) {
			this._throwTypeException()
		}
		stringLength := strLen(paramString)
		if (paramLength <= stringLength) {
			return paramString
		}
		padLength := paramLength - stringLength
		padChars := paramChars
		while (strLen(padChars) < padLength) {
			padChars .= padChars
		}
		return subStr(padChars, 1, padLength) . paramString
	}
	static parseInt(param_string,param_radix:=0) {
		inputString := "" param_string
		inputString := this.trimStart(inputString, A_Tab A_Space)
		sign := 1
		if (inputString != "" && subStr(inputString, 1, 1) == "-") {
			sign := -1
			inputString := subStr(inputString, 2)
		} else if (inputString != "" && subStr(inputString, 1, 1) == "+") {
			inputString := subStr(sign, 2)
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
	static repeat(param_string,param_number:=1) {
		if (!this.isString(param_string) || (!this.isNumber(param_number))) {
			this._throwTypeException()
		}
		if (param_number <= 0) {
			return ""
		}
		return strReplace(format("{:0" param_number "}", 0), "0", param_string)
	}
	static startsWith(param_string,param_needle,param_fromIndex:=1) {
		if (!this.isString(param_string) || !this.isString(param_needle) || !this.isNumber(param_fromIndex)) {
			this._throwTypeException()
		}
		l_startString := subStr(param_string, param_fromIndex, strLen(param_needle))
		if (this.isEqual(l_startString, param_needle)) {
			return true
		}
		return false
	}
	static toLower(param_string) {
		return strLower(param_string)
	}
	static toUpper(param_string) {
		if (!this.isString(param_string)) {
			this._throwTypeException()
		}
		return strUpper(param_string)
	}
	static trim(param_string,param_chars:="") {
		if (!this.isString(param_string) || !this.isString(param_chars)) {
			this._throwTypeException()
		}
		if (param_chars == "") {
			return this.trim(param_string, "`r`n" A_space A_tab)
		} else {
			l_string := this.trimStart(param_string, param_chars)
			l_string := this.trimEnd(l_string, param_chars)
			return l_string
		}
	}
	static trimEnd(paramString, paramChars := "") {
		if (!this.isString(paramString) || !this.isString(paramChars)) {
			this._throwTypeException()
		}
		if (paramChars == "") {
			return rtrim(paramString)
		}
		stringLength := strLen(paramString)
		endIndex := stringLength
		while (endIndex > 0 && inStr(paramChars, subStr(paramString, endIndex, 1))) {
			endIndex--
		}
		return subStr(paramString, 1, endIndex)
	}
	static trimStart(param_string, param_chars := "") {
		if (!this.isString(param_string) || !this.isString(param_chars)) {
			this._throwTypeException()
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
	static truncate(param_string,param_options:="") {
		if (!this.isString(param_string)) {
			this._throwTypeException()
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
	static unescape(param_string:="") {
		if (!this.isString(param_string)) {
			this._throwTypeException()
		}
		HTMLmap := [["&","&amp;"], ["<","&lt;"], [">","&gt;"], ["`"","&quot;"], ["'","&#39;"]]
		for key, value in HTMLmap {
			param_string := strReplace(param_string, value[2], value[1], true, , -1)
		}
		return param_string
	}
	static upperFirst(param_string:="") {
		if (!this.isString(param_string)) {
			this._throwTypeException()
		}
		return this.toUpper(subStr(param_string, 1, 1)) subStr(param_string, 2)
	}
	static words(param_string,param_pattern:="") {
		if (!this.isString(param_string) || !this.isString(param_pattern)) {
			this.throwTypeException()
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
	static identity(param_value) {
		return param_value
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
	static _throwTypeException() {
		if (this.throwExceptions == true) {
			throw valueError("Type Error", -2)
		}
	}
}
