class adash {
	static stringCaseSense := true
	static throwExceptions := true
	static limit := -1
	static chunk(param_array,param_size:=1) {
		if (!isObject(param_array) || !this.isNumber(param_size)) {
			this._throwTypeException()
		}
		l_array := []
		param_array := this.clone(param_array)
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
	static clone(param_value) {
		if (isObject(param_value)) {
			return param_value.clone()
		} else {
			return param_value
		}
	}
	static cloneDeep(param) {
		if (!isObject(param)) {
			return param
		}
		clone := param.clone()
		if (clone.hasProp("__Item")) {
			for key, value in clone {
				if (isObject(value)) {
					clone[key] := this.cloneDeep(value)
				}
			}
		} else {
			for key, value in clone.ownProps() {
				if (isObject(value)) {
					clone.defineProp(key, this.cloneDeep(value))
				}
			}
		}
		return clone
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
		param_n := this.clamp(param_n, 1, l_array.length)
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
		for index, object in param_array.ownProps() {
			if (isObject(object)) {
				for index2, object2 in object {
					l_obj.push(object2)
				}
			} else {
				l_obj.push(object)
			}
		}
		return l_obj
	}
	static flattenDeep(param_array) {
		if (!isObject(param_array)) {
			this._throwTypeException()
		}
		l_obj := []
		if (param_array.hasProp("__Item")) {
			for index, object in param_array {
				if (isObject(object)) {
					l_obj.push(this.flatten(object)*)
				} else {
					l_obj.push(object)
				}
			}
		} else {
			for key, object in param_array.ownProps() {
				if (isObject(object)) {
					l_obj.push(this.flatten(object)*)
				} else {
					l_obj.push(object)
				}
			}
		}
		return l_obj
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
	static fromPairs(param_pairs) {
		if (!isObject(param_pairs)) {
			this._throwTypeException()
		}
		l_obj := {}
		for key, value in param_pairs.ownProps() {
			l_obj.defineProp(value[1], value[2])
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
	static map(param_collection,param_iteratee:="__identity") {
		if (!isObject(param_collection)) {
			this._throwTypeException()
		}
		l_collection := this.cloneDeep(param_collection)
		l_array := []
		if (this.includes(param_iteratee.name, this.prototype.__class ".")) {
			for key, value in param_collection {
				switch (param_iteratee.maxParams) {
					case 2:
						l_array.push(param_iteratee.call(this, value))
					case 3:
						l_array.push(param_iteratee.call(this, value, key))
					case 4:
						l_array.push(param_iteratee.call(this, value, key, l_collection))
				}
			}
			return l_array
		}
		for key, value in param_collection {
			switch (param_iteratee.maxParams) {
				case 1:
					l_array.push(param_iteratee.call(value))
				case 2:
					l_array.push(param_iteratee.call(value, key))
				case 3:
					l_array.push(param_iteratee.call(value, key, l_collection))
			}
		}
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
	static toString(val?) {
		if (!IsSet(val)) {
			return "unset"
		}
		valType := Type(val)
		switch valType, 0 {
			case "String":
				return "'" val "'"
			case "Integer", "Float":
				return val
			default:
				self := "", iter := "", out := ""
				try self := this.toString(val.ToString())
				if valType != "Array" {
					try {
						enum := val.__Enum(2) 
						while (enum.Call(&val1, &val2))
							iter .= this.toString(val1) ":" this.toString(val2?) ", "
					}
				}
				if !IsSet(enum) {
					try {
						enum := val.__Enum(1)
						while (enum.Call(&enumVal))
							iter .= this.toString(enumVal?) ", "
					}
				}
				if !IsSet(enum) && (valType = "Object") && !self {
					for k, v in val.OwnProps()
						iter .= SubStr(this.toString(k), 2, -1) ":" this.toString(v?) ", "
				}
				iter := SubStr(iter, 1, StrLen(iter)-2)
				if !self && !iter && !((valType = "Array" && val.Length = 0) || (valType = "Map" && val.Count = 0) || (valType = "Object" && ObjOwnPropCount(val) = 0))
					return valType
				else if self && iter
					out .= "value:" self ", iter:[" iter "]"
				else
					out .= self iter
				return (valType = "Object") ? "{" out "}" : (valType = "Array") ? "[" out "]" : valType "(" out ")"
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
					if (this._isEqual(value, param_value)) {
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
					if (this._isEqual(value, param_value)) {
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
	static size(param_collection) {
		if (type(param_collection) == "Object") {
			return ObjOwnPropCount(param_collection)
		} else if (type(param_collection) == "String") {
			return strLen(param_collection)
		}
		return param_collection.length
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
			printedelement := this.toString(param_collection[key])
			if (l_temp != printedelement) {
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
		for index, value in param_array.ownProps() {
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
		for each, arr in arrays {
			if (isObject(arr)) {
				for key, value in arr {
					combinedArray.push(value)
				}
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
		maxLength := 0
		for key, value in param_arrays {
			maxLength := max(maxLength, value.length)
		}
		loop maxLength {
			l_current := []
			for key, value in param_arrays {
				l_current.push(value)
			}
			l_array.push(l_current)
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
		if (param_props.hasProp("__Item")) {
			for key, value in param_props {
				if (isObject(value)) {
					l_obj[value] := value.clone()
				}
			}
		} else {
			for key, value in param_props.ownProps() {
				if (isObject(value)) {
					param_props.defineProp(key, this.cloneDeep(value))
				}
			}
		}
		return l_obj
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
	static isEqual(param_value,param_other*) {
		if (isObject(param_value)) {
			l_array := this.map(param_other, this._hash)
			param_value := this._hash(param_value)
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
				value := this.toString(value)
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
		if(type(param) == "Func") {
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
			throw ValueError("Type Error", -2)
		}
	}
}