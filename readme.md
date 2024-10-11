# **Array methods**
## .chunk
Creates an array of elements split into groups the length of size. If array can't be split evenly, the final chunk will be the remaining elements.


#### Arguments
array (Array): The array to process.

[size:=1] (number): The length of each chunk


#### Returns
(Array): Returns the new array of chunks.


#### Example

```autohotkey
_.chunk(["a", "b", "c", "d"], 2)
; => [["a", "b"], ["c", "d"]]

_.chunk(["a", "b", "c", "d"], 3)
; => [["a", "b", "c"], ["d"]]

```



## .compact
Creates an array with all falsey values removed. The values false, 0, and "" are falsey.


#### Arguments
array (Array): The array to compact.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.compact([0, 1, false, 2, "", 3])
; => [1, 2, 3]

```



## .depthOf
This method is explores the array and returns the maximum depth.


#### Arguments
array (Array): The array to inspect.


#### Returns
(number): Returns the maximum depth.


#### Example

```autohotkey
_.depthOf([1])
; => 1

_.depthOf([1, [2]])
; => 2

_.depthOf([1, [[2]]])
; => 3

_.depthOf([1, [2, [3, [4]], 5]])
; => 4

```



## .difference
Creates an array of array values not included in the other given arrays. The order of result values are determined by the first array.

#### Arguments
array (Array): The array to inspect.

values (...Array): The values to exclude.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.difference([2, 1], [2, 3])
; => [1]

```



## .drop
Creates a slice of array with n elements dropped from the beginning.


#### Arguments
array (Array): The array to query.

[n:=1] (number): The number of elements to drop.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.drop([1, 2, 3])
; => [2, 3]

_.drop([1, 2, 3], 2)
; => [3]

_.drop([1, 2, 3], 5)
; => []

_.drop([1, 2, 3], 0)
; => [1, 2, 3]

_.drop("fred")
; => ["r", "e", "d"]

_.drop(100)
; => ["0", "0"]

```



## .dropRight
Creates a slice of array with n elements dropped from the end.


#### Arguments
array (Array): The array to query.

[n:=1] (number): The number of elements to drop.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.dropRight([1, 2, 3])
; => [1, 2]

_.dropRight([1, 2, 3], 2)
; => [1]

_.dropRight([1, 2, 3], 5)
; => []

_.dropRight([1, 2, 3], 0)
; => [1, 2, 3]

_.dropRight("fred")
; => ["f", "r", "e"]

_.dropRight(100)
; => ["1", "0"]

```



## .fill
Fills elements of array with value from start up to, but not including, end.

> [!Note]
> This method mutates array.


#### Arguments
array (Array): The array to fill.

value (*): The value to fill array with.

[start:=1] (number): The start position.

[end:=array.length] (number): The end position.


#### Returns
(Array): Returns array.


#### Example

```autohotkey
arr := [1, 2, 3]
_.fill(arr, "a")
; => ["a", "a", "a"]

_.fill([4, 6, 8, 10], "*", 2, 3)
; => [4, "*", "*", 10]

```



## .flatten
Flattens array a single level deep.


#### Arguments
array (Array): The array to flatten.


#### Returns
(Array): Returns the new flattened array.


#### Example

```autohotkey
_.flatten([1, [2, [3, [4]], 5]])
; => [1, 2, [3, [4]], 5]

_.flatten([[1, 2, 3], [4, 5, 6]])
; => [1, 2, 3, 4, 5, 6]

```



## .flattenDeep
Recursively flattens array.


#### Arguments
array (Array): The array to flatten.


#### Returns
(Array): Returns the new flattened array.


#### Example

```autohotkey
_.flattenDeep([1])
; => [1]

_.flattenDeep([1, [2]])
; => [1, 2]

_.flattenDeep([1, [2, [3, [4]], 5]])
; => [1, 2, 3, 4, 5]

```



## .flattenDepth
Recursively flatten array up to depth times.


#### Arguments
array (Array): The array to flatten.

[depth:=1] (number): The maximum recursion depth.


#### Returns
(Array): Returns the new flattened array.


#### Example

```autohotkey
_.flattenDepth([1, [2, [3, [4]], 5]], 1)
; => [1, 2, [3, [4]], 5]

_.flattenDepth([1, [2, [3, [4]], 5]], 2)
; => [1, 2, 3, [4], 5]

```



## .fromPairs
The inverse of _.toPairs; this method returns an object composed from key-value pairs.

#### Arguments
pairs (Array): The key-value pairs.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.fromPairs([["a", 1], ["b", 2]])
; => {a: 1, b: 2}

```



## .head
Gets the first element of array.

#### Aliases
`.first`

#### Arguments
array (Array): The array to query.


#### Returns
(*): Returns the first element of array.


#### Example

```autohotkey
_.head([1, 2, 3])
; => 1

_.head([])
; => ""

_.head("fred")
; => "f"

_.head(100)
; => "1"

```

## .includes
Checks if `value` is in `collection`. If `collection` is a string, it's checked for a substring of value.


#### Arguments
collection (Array|Object|string): The collection to inspect.

value (*): The value to search for.

[fromIndex:=1] (number): The index to search from.


#### Returns
(boolean): Returns true if value is found, else false.


#### Example

```autohotkey
_.includes([1, 2, 3], 1)
; => true

_.includes("inStr", "Str")
; => true

_.stringCaseSense := true
_.includes("inStr", "str")
; => false
```


## .indexOf
Gets the index at which the first occurrence of value is found in array. If fromIndex is negative, it's used as the offset from the end of array.


#### Arguments
array (Array): The array to inspect.

value (*): The value to search for.

[fromIndex:=1] (number): The index to search from.


#### Returns
(number): Returns the index of the matched value, else -1.


#### Example

```autohotkey
_.indexOf([1, 2, 1, 2], 2)
; => 2

; Search from the `fromIndex`.
_.indexOf([1, 2, 1, 2], 2, 3)
; => 4

_.indexOf(["fred", "barney"], "pebbles")
; => -1

_.stringCaseSense := true
_.indexOf(["fred", "barney"], "Fred")
; => -1

```



## .initial
Gets all but the last element of array.


#### Arguments
array (Array): The array to query.

#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.initial([1, 2, 3])
; => [1, 2]

_.initial("fred")
; => ["f", "r", "e"]

_.initial(100)
; => ["1", "0"]

```



## .intersection
Creates an array of unique values that are included in all given arrays. The order of result values are determined by the first array.


#### Arguments
[arrays*] (...Array): The arrays to inspect.


#### Returns
(Array): Returns the new array of intersecting values.


#### Example

```autohotkey
_.intersection([2, 1], [2, 3])
; => [2]

```



## .join
Converts all elements in array into a string separated by separator.


#### Arguments
array (Array): The array to convert.

[separator:=","] (string): The element separator.


#### Returns
(string): Returns the joined string.


#### Example

```autohotkey
_.join(["a", "b", "c"], "~")
; => "a~b~c"

_.join(["a", "b", "c"])
; => "a,b,c"

```



## .last
Gets the last element of array.


#### Arguments
array (Array): The array to query.


#### Returns
(*): Returns the last element of array.


#### Example

```autohotkey
_.last([1, 2, 3])
; => 3

_.last([])
; => ""

_.last("fred")
; => "d"

_.last(100)
; => "0"

```



## .lastIndexOf
This method is like [_.indexOf](/docs?id=indexof) except that it iterates over elements of array from right to left.


#### Arguments
array (Array): The array to inspect.

value (*): The value to search for.

[fromIndex:=array.length] (number): The index to search from.


#### Returns
(number): Returns the index of the matched value, else -1.


#### Example

```autohotkey
_.lastIndexOf([1, 2, 1, 2], 2)
; => 4

; Search from the `fromIndex`.
_.lastIndexOf([1, 2, 1, 2], 1, 2)
; => 1

_.stringCaseSense := true
_.lastIndexOf(["fred", "barney"], "Fred")
; => -1

```



## .nth
Gets the element at index n of array. If n is negative, the nth element from the end is returned.


#### Arguments
array (Array): The array to query.

[n:=1] (number): The index of the element to return.


#### Returns
(*): Returns the nth element of array.


#### Example

```autohotkey
_.nth([1, 2, 3])
; => 1

_.nth([1, 2, 3], -3)
; => 1

_.nth([1, 2, 3], 5)
; => ""

_.nth("fred")
; => "f"

_.nth(100)
; => "1"

_.nth([1, 2, 3], 0)
; => 1

```



## .reverse
Reverses array so that the first element becomes the last, the second element becomes the second to last, and so on.


#### Arguments
array (Array): The array to modify.


#### Returns
(Array): Returns array.


#### Example

```autohotkey
_.reverse(["a", "b", "c"])
; => ["c", "b", "a"]

_.reverse([{foo: "bar"}, "b", "c"])
; => ["c", "b", {foo: "bar"}]

_.reverse([[1, 2, 3], "b", "c"])
; => ["c", "b", [1, 2, 3]]

```



## .slice
Creates a slice of array from start up to end.


#### Arguments
array (Array): The array to slice.

[start:=1] (number): The start position.

[end:=array.length] (number): The end position.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.slice([1, 2, 3], 1, 2)
; => [1, 2]

_.slice([1, 2, 3], 1)
; => [1, 2, 3]

_.slice([1, 2, 3], 5)
; => []

_.slice("fred")
; => ["f", "r", "e", "d"]

_.slice(100)
; => ["1", "0", "0"]

```



## .sortedIndex
Uses a search to determine the lowest index at which value should be inserted into array in order to maintain its sort order.


#### Arguments
array (Array): The sorted array to inspect.

value (*): The value to evaluate.


#### Returns
(number): Returns the index at which value should be inserted into array.


#### Example

```autohotkey
_.sortedIndex([30, 50], 40)
; => 2

_.sortedIndex([30, 50], 20)
; => 1

_.sortedIndex([30, 50], 99)
; => 3

```



## .sortedUniq
This method is like [_.uniq](/docs?id=uniq) except that it's optimized for sorted arrays.


#### Arguments
array (Array): The sorted array to inspect.


#### Returns
(array): Returns the new duplicate free array.


#### Example

```autohotkey
_.sortedUniq([1, 1, 2])
; => [1, 2]

```



## .tail
Gets all but the first element of array.


#### Arguments
array (Array): The array to query.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.tail([1, 2, 3])
; => [2, 3]

_.tail("fred")
; => ["r", "e", "d"]

_.tail(100)
; => ["0", "0"]

```



## .take
Creates a slice of array with n elements taken from the beginning.


#### Arguments
array (Array): The array to query.

[n:=1] (number): The number of elements to take.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.take([1, 2, 3])
; => [1]

_.take([1, 2, 3], 2)
; => [1, 2]

_.take([1, 2, 3], 5)
; => [1, 2, 3]

_.take([1, 2, 3], 0)
; => []

_.take("fred")
; => ["f"]

_.take(100)
; => ["1"]

```



## .takeRight
Creates a slice of array with n elements taken from the end.


#### Arguments
array (Array): The array to query.

[n:=1] (number): The number of elements to take.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.takeRight([1, 2, 3])
; => [3]

_.takeRight([1, 2, 3], 2)
; => [2, 3]

_.takeRight([1, 2, 3], 5)
; => [1, 2, 3]

_.takeRight([1, 2, 3], 0)
; => []

_.takeRight("fred")
; => ["d"]

_.takeRight(100)
; => ["0"]

```



## .union
Creates an array of unique values, in order, from all given arrays.


#### Arguments
[arrays] (...Array): The arrays to inspect.


#### Returns
(Array): Returns the new array of combined values.


#### Example

```autohotkey
_.union([2], [1, 2])
; => [2, 1]

```



## .uniq
Creates a duplicate-free version of an array, in which only the first occurrence of each element is kept. The order of result values is determined by the order they occur in the array.


#### Arguments
array (Array): The array to inspect.


#### Returns
(Array): Returns the new duplicate free array.

#### Example

```autohotkey
_.uniq([2, 1, 2])
; => [2, 1]

```



## .unzip
This method is like [_.zip](/docs?id=zip) except that it accepts an array of grouped elements and creates an array regrouping the elements to their pre-zip configuration.

#### Arguments
array (Array): The array of grouped elements to process.


#### Returns

(Array): Returns the new array of regrouped elements.

#### Example

```autohotkey
zipped := _.zip(["a", "b"], [1, 2], [true, false])
; => [["a", 1, true], ["b", 2, true]]
_.unzip(zipped)
; => [["a", "b"], [1, 2], [true, false]]

```



## .without
Creates an array excluding all given values.

#### Arguments
array (Array): The array to inspect.

[values] (...*): The values to exclude.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.without([2, 1, 2, 3], 1, 2)
; => [3]

```



## .zip
Creates an array of grouped elements, the first of which contains the first elements of the given arrays, the second of which contains the second elements of the given arrays, and so on.

> [!Warning]
> This method has not reached pairity with Lodash.
> Output will not match Lodash output in the event the length of all supplied arrays are not the same.

#### Arguments
[arrays*] (...Array): The arrays to process.


#### Returns

(Array): Returns the new array of grouped elements.

#### Example

```autohotkey
_.zip(["a", "b"], [1, 2], [true, true])
; => [["a", 1, true], ["b", 2, true]]

```



## .zipObject
This method is like [_.fromPairs](/docs?id=frompairs) except that it accepts two arrays, one of property identifiers and one of corresponding values.


#### Arguments
[props:=[]] (Array): The property identifiers.

[values:=[]] (Array): The property values.


#### Returns

(Object): Returns the new object.


#### Example

```autohotkey
_.zipObject(["a", "b"], [1, 2])
; => {a: 1, b: 2}

```

# **Collection methods**
## .map
Creates an array of values by running each element in `collection` thru `iteratee`. The iteratee is invoked with three arguments: (value, index|key, collection).


#### Arguments
collection (Array|Object): The collection to iterate over.

[iteratee:=.identity] (Function): The function invoked per iteration.


#### Returns
(Array): Returns the new mapped array.


#### Example

```autohotkey

_.map([4, 8], fn_square)
; => [16, 64]

fn_square(n) {
	return n * n
}
```




# **Lang methods**
## .clone
Creates a shallow clone of `value`. Supports cloning arrays, objects, numbers, strings.

#### Arguments
value (*): The value to clone.


#### Returns
(*): Returns the cloned value.


#### Example
```autohotkey
object := [{ "a": 1 }, { "b": 2 }]
shallowclone := A.clone(object)
object.a := 2

;object
; => [{ "a": 2 }, { "b": 2 }]

;shallowclone
; => [{ "a": 1 }, { "b": 2 }]
```

## .cloneDeep
This method is like [_.clone](/docs?id=clone) except that it recursively clones `value`.


#### Arguments
value (*): The value to recursively clone.


#### Returns
(*): Returns the deep cloned value.


#### Example

```autohotkey
object := [{ "a": [[1, 2, 3]] }, { "b": 2 }]
deepclone := A.cloneDeep(object)
object[1].a := 2

; object
; => [{ "a": 2 }, { "b": 2 }]

; deepclone
; => [{ "a": [[1, 2, 3]] }, { "b": 2 }]
```


## .isAlnum
Checks if value is an alnum.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is an alnum, else false.


#### Example

```autohotkey
_.isAlnum(1)
; => true

_.isAlnum("hello")
; => true

_.isAlnum([])
; => false

_.isAlnum({})
; => false

```



## .isArray
Checks if value is an Array obj.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is an array, else false.


#### Example

```autohotkey
_.isArray([1, 2, 3])
; => true

_.isArray("abc")
; => false

_.isArray({key: "value"})
; => true

```



## .isBoolean
Checks if value is classified as a boolean.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is a boolean, else false.


#### Example

```autohotkey
_.isBoolean(true)
; => true

_.isBoolean(1)
; => true

_.isBoolean(false)
; => true

_.isBoolean(0)
; => true

```



## .isEqual
Performs a deep comparison between two values to determine if they are equivalent.

This method supports comparing strings and objects.


#### Arguments
value (*): The value to compare.

other (...*): The other value to compare.


#### Returns
(boolean): Returns true if the values are equivalent, else false.


#### Example

```autohotkey
_.isEqual(1, 1)
; => true

_.isEqual({ a: 1 }, { a: 1 })
; => true

_.isEqual(1, 1, 2)
; => false

_.stringCaseSense := true
_.isEqual({ a: "a" }, { a: "A" })
; => false

```



## .isFloat
Checks if value is a float.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is a float, else false.


#### Example

```autohotkey
_.isFloat(1.0)
; => true

_.isFloat(1)
; => false

```



## .isFunction
Checks if `value` is callable as a function object, bound function, or object method.


#### Arguments
value (*): The `value` to check.


#### Returns
(boolean): Returns `true` if `value` is callable, else `false`.


#### Example

```autohotkey
bndFunc := strLen.bind("one")
_.isFunction(bndFunc)
; => true

isFunc(bndFunc)
; => false

_.isFunction(_.isString)
; => true

_.isFunction(_.matchesProperty("a", 1))
; => true

_.isFunction([1, 2, 3])
; => false

```



## .isInteger
Checks if value is an integer.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is an integer, else false.


#### Example

```autohotkey
_.isInteger(1)
; => true

_.isInteger("1")
; => false

```



## .isMatch
Performs a partial deep comparison between object and source to determine if object contains equivalent property values.

Partial comparisons will match empty array and empty object source values against any array or object value, respectively. See [_.isEqual](/docs?id=isEqual) for a list of supported value comparisons.


#### Arguments
object obj: The object to inspect.

source obj: The object of property values to match.


#### Returns
(boolean): Returns true if object is a match, else false.

#### Example

```autohotkey
obj := { a: 1, b: 2, c: 3 }
_.isMatch(object, {b: 2})
; => true

_.isMatch(object, {b: 2, c: 3})
; => true

_.isMatch(object, {b: 1})
; => false

_.isMatch(object, {b: 2, z: 99})
; => false

```



## .isNumber
Checks if value is a number.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is a number, else false.


#### Example

```autohotkey
_.isNumber(1)
; => true

_.isNumber("1")
; => true

_.isNumber("1.001")
; => true

```



## .isObject
Checks if value is an obj.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is an object, else false.


#### Example

```autohotkey
_.isObject({})
; => true

_.isObject([1, 2, 3])
; => true

_.isObject("")
; => false

```



## .isString
Checks if value is classified as a string.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is a string, else false.


#### Example

```autohotkey
_.isString("abc")
; => true

_.isString(1)
; => false

```



## .isUndefined
Checks if value is unset or undefined.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is undefined, else false.


#### Example

```autohotkey
_.isUndefined("")
; => false

_.isUndefined(non_existant_var)
; => true

_.isUndefined({})
; => false

_.isUndefined(" ")
; => false

_.isUndefined(0)
; => false

_.isUndefined(false)
; => false

```






# **Number methods**
## .clamp
Clamps number within the inclusive lower and upper bounds.


#### Arguments
number (number): The number to clamp.

lower (number): The lower bound.

upper (number): The upper bound.


#### Returns
(number): Returns the clamped number.


#### Example

```autohotkey
_.clamp(-10, -5, 5)
; => -5

_.clamp(10, -5, 5)
; => 5

```



## .random
Produces a random number between the inclusive lower and upper bounds. If floating is true, or either lower or upper are floats, a floating-point number is returned instead of an integer. Uses AutoHotkey's pseudo-random [Random](https://www.autohotkey.com/docs/commands/Random.htm) command.


#### Arguments
[lower:=0] (number): The lower bound.

[upper:=1] (number): The upper bound.

[floating:=false] (boolean): Specify returning a floating-point number.


#### Returns
(number): Returns the random number.


#### Example
```autohotkey
_.random(0, 5)
; => an integer between 0 and 5

_.random(5)
; => an integer between 0 and 5

_.random(1.2, 5.2)
; => a floating-point number between 1.2 and 5.2
```



