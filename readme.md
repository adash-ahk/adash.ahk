
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
Creates an array with all falsey values removed. The values `false`, `0`, `""`, and `unset` are falsey.


#### Arguments
array (Array): The array to compact.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.compact([0, 1, false, 2, "", 3])
; => [1, 2, 3]

```



## .concat
Creates a new array concatenating array with any additional arrays and/or values.

#### Arguments
array (Array): The array to concatenate.

[values] (...*): The values to concatenate.


#### Returns
(Array): Returns the new concatenated array.


#### Example

```autohotkey
arr := [1]
_.concat(arr, 2, [3], [[4]])
; => [1, 2, 3, [4]]

_.concat(arr)
; => [1]

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
Creates an array of `array` values not included in the other given arrays. The order of result values are determined by the first array.

#### Arguments
array (Array): The array to inspect.

values (Array*): The values to exclude.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.difference([2, 1], [2, 3])
; => [1]

```



## .differenceBy
This method is like [_.difference](/?id=difference) except that it accepts `iteratee` which is invoked for each element of each array to generate the criterion by which they're compared. The iteratee is invoked with three arguments: (value, index, array). Values are taken from the first array.


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the iteratee if it is not an array.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.differenceBy([2.1, 1.2], [2.3, 3.4], floor)
; => [1.2]

_.differenceBy([{x: 2}, {x: 1}], [{x: 1}], "x")
; => [{x: 2}]

```



## .differenceWith
This method is like `.difference` except that it accepts `comparator` which is invoked to compare elements of `array` to `values`. The comparator is invoked with two arguments: (arrVal, othVal).


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the comparator if it is a function.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.differenceWith([1, 2, 3], [1, 2], (a, b) => a == b)
; => [3]

users := [{x: 1, y: 2}, {x: 2, y: 1}]
_.differenceWith(users, [{x: 1, y: 2}], _.isEqual)
; => [{x: 2, y: 1}]

```



## .drop
Creates a slice of `array` with `n` elements dropped from the beginning.


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

_.drop("neo")
; => ["e", "o"]

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

_.dropRight("neo")
; => ["n", "e"]

_.dropRight(100)
; => ["1", "0"]

```



## .dropRightWhile
Creates a slice of array excluding elements dropped from the end. Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The array to query.

[predicate:=.identity] (Function): The function invoked per iteration.


#### Returns

(Array): Returns the slice of array.


#### Example

```autohotkey
users := [ {user: "morpheus", active: true}
		, {user: "neo", active: false}
		, {user: "trinity", active: false} ]
_.dropRightWhile(users, fn_dropRightWhile)
; => [{user: "morpheus", active: true}]

fn_dropRightWhile(o)
	return !o.active
; The _.matches iteratee shorthand.
_.dropRightWhile(users, {user: "trinity", active: false})
; => [{user: "morpheus", active: true}, {user: "neo", active: false}]

; The _.matchesProperty iteratee shorthand.
_.dropRightWhile(users, ["active", false])
; => [{user: "morpheus", active: true}]

; The _.property iteratee shorthand.
_.dropRightWhile(users, "active")
; => [{user: "morpheus", active: true}, {user: "neo", active: false}, {user: "trinity", active: false}]

```



## .dropWhile
Creates a slice of array excluding elements dropped from the beginning. Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The array to query.

[predicate:=.identity] (Function): The function invoked per iteration.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
users := [ {user: "morpheus", active: false}
		, {user: "neo", active: false}
		, {user: "trinity", active: true} ]
_.dropWhile(users, fn_dropWhile)
; => [{user: "trinity", active: true}]

fn_dropWhile(o)
	return !o.active
; The _.matches iteratee shorthand.
_.dropWhile(users, {user: "morpheus", active: false})
; => [{user: "neo", active: false}, {user: "trinity", active: true}]

; The _.matchesProperty iteratee shorthand.
_.dropWhile(users, ["active", false])
; => [{user: "trinity", active: true}]

; The _.property iteratee shorthand.
_.dropWhile(users, "active")
; => [{user: "morpheus", active: false}, {user: "neo", active: false}, {user: "trinity", active: true}]

```



## .fill
Fills elements of array with `value` from start up to, but not including, end.

> [!Note]
> This method mutates the array.


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

_.fill([4, 6, 8, 10], "*", 2, 4)
; => [4, "*", "*", 10]

```



## .findIndex
This method is like [_.find](/?id=find) except that it returns the index of the first element predicate returns truthy for instead of the element itself.


#### Arguments
array (Array): The array to inspect.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.

[fromIndex:=1] (number): The index to search from. Negative values count back from the end.


#### Returns
(number): Returns the index of the found element, else -1.


#### Example

```autohotkey
users := [{user: "cypher", active: false}
		, {user: "tank", active: false}
		, {user: "trinity", active: true}]
_.findIndex(users, (o) => o.user == "cypher")
; => 1

; The _.matches iteratee shorthand.
_.findIndex(users, {user: "tank", active: false})
; => 2

; The _.matchesProperty iteratee shorthand.
_.findIndex(users, ["active", false])
; => 1

; The _.property iteratee shorthand.
_.findIndex(users, "active")
; => 3

```



## .findLastIndex
This method is like [_.findIndex](/?id=findindex) except that it iterates over elements of array from right to left.

#### Arguments
array (Array): The array to inspect.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.

[fromIndex:=array.length] (number): The index to search from. Negative values count back from the end.


#### Returns
(number): Returns the index of the found element, else -1.


#### Example

```autohotkey
users := [{user: "morpheus", active: true}
		, {user: "neo", active: false}
		, {user: "trinity", active: false}]
_.findLastIndex(users, {user: "morpheus", active: true})
; => 1

_.findLastIndex(users, ["active", true])
; => 1

_.findLastIndex(users, "active")
; => 1

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

_.head({a: 1, b: 2, c:3})
; => 1

_.head("Neo")
; => "N"

```



## .indexOf
Gets the index at which the first occurrence of `value` is found in `array`. If `fromIndex` is negative, it's used as the offset from the end of `array`.


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

_.stringCaseSense := true
_.indexOf(["neo", "morpheus"], "Neo")
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

_.initial("neo")
; => ["n", "e"]

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



## .intersectionBy
This method is like [_.intersection](/?id=intersection) except that it accepts `iteratee` which is invoked for each element of each array to generate the criterion by which they're compared. The iteratee is invoked with three arguments: (value, index, array). Values are taken from the first array.


#### Arguments
[arrays] (Array): The arrays to inspect. The last argument may be the iteratee if it is not an array.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(Array): Returns the new array of intersecting values.


#### Example

```autohotkey
_.intersectionBy([2.1, 1.2], [2.3, 3.4], floor)
; => [2.1]

_.intersectionBy([{x: 1}], [{x: 2}, {x: 1}], "x")
; => [{x: 1}]

```



## .intersectionWith
This method is like `.intersection` except that it accepts `comparator` which is invoked to compare elements of the arrays. The comparator is invoked with two arguments: (arrVal, othVal). Values are taken from the first array.


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the comparator if it is a function.


#### Returns
(Array): Returns the new array of intersecting values.


#### Example

```autohotkey
_.intersectionWith([1, 2, 3], [1.1, 4], (a, b) => abs(a - b) < 0.5)
; => [1]

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

_.last("neo")
; => "o"

_.last(100)
; => 0

```



## .lastIndexOf
This method is like [_.indexOf](/?id=indexof) except that it iterates over elements of array from right to left.


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
_.lastIndexOf([1, 2, 1, 2], 1, 3)
; => 3

_.stringCaseSense := true
_.lastIndexOf(["neo", "morpheus"], "Neo")
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

_.nth("neo")
; => "n"

_.nth(100)
; => "1"

_.nth([1, 2, 3], 0)
; => 1

```



## .pull
Removes all given values from `array`.

> [!Note]
> Unlike `.without`, this method mutates `array`.


#### Arguments
array (Array): The array to modify.

[values] (...*): The values to remove.


#### Returns
(Array): Returns `array`.


#### Example

```autohotkey
arr := ["a", "b", "c", "a", "b", "c"]
_.pull(arr, "a", "c")
arr
; => ["b", "b"]

```



## .pullAll
This method is like `.pull` except that it accepts an array of values to remove.

> [!Note]
> Unlike `.difference`, this method mutates `array`.


#### Arguments
array (Array): The array to modify.

values (Array): The values to remove.


#### Returns
(Array): Returns `array`.


#### Example

```autohotkey
arr := ["a", "b", "c", "a", "b", "c"]
_.pullAll(arr, ["a", "c"])
arr
; => ["b", "b"]

```



## .pullAllBy
This method is like `.pullAll` except that it accepts `iteratee` which is invoked for each element of `array` and `values` to generate the criterion by which they're compared. The iteratee is invoked with one argument: (value).

> [!Note]
> This method mutates `array`.


#### Arguments
array (Array): The array to modify.

values (Array): The values to remove.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element. A string uses the `.property` shorthand.


#### Returns
(Array): Returns `array`.


#### Example

```autohotkey
arr := [{x: 1}, {x: 2}, {x: 3}, {x: 1}]
_.pullAllBy(arr, [{x: 1}, {x: 3}], "x")
arr
; => [{x: 2}]

```



## .pullAllWith
This method is like `.pullAll` except that it accepts `comparator` which is invoked to compare elements of `array` to `values`. The comparator is invoked with two arguments: (arrVal, othVal).

> [!Note]
> This method mutates `array`.


#### Arguments
array (Array): The array to modify.

values (Array): The values to remove.

[comparator] (Function): The comparator invoked per element.


#### Returns
(Array): Returns `array`.


#### Example

```autohotkey
arr := [{x: 1, y: 2}, {x: 3, y: 4}, {x: 5, y: 6}]
_.pullAllWith(arr, [{x: 3, y: 4}], _.isEqual)
arr
; => [{x: 1, y: 2}, {x: 5, y: 6}]

```



## .pullAt
Removes elements from `array` at the given indexes and returns the removed elements in the order the indexes were given. Indexes are 1-based and out of range indexes are ignored.

> [!Note]
> This method mutates `array`.


#### Arguments
array (Array): The array to modify.

[indexes] (...number|Array): The indexes of the elements to remove.


#### Returns
(Array): Returns the array of removed elements.


#### Example

```autohotkey
arr := ["a", "b", "c", "d"]
_.pullAt(arr, 1, 3)
; => ["a", "c"]

arr
; => ["b", "d"]

```



## .remove
Removes all elements from `array` that `predicate` returns truthy for, and returns the removed elements. The predicate is invoked with three arguments: (value, index, array).

> [!Note]
> This method mutates `array`.


#### Arguments
array (Array): The array to modify.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(Array): Returns the new array of removed elements.


#### Example

```autohotkey
arr := [1, 2, 3, 4]
evens := _.remove(arr, (n) => mod(n, 2) == 0)
arr
; => [1, 3]

evens
; => [2, 4]

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

_.slice("neo")
; => ["n", "e", "o"]

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



## .sortedIndexBy
This method is like `.sortedIndex` except that it accepts `iteratee` which is invoked for `value` and each element of `array` to compute their sort ranking. The iteratee is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The sorted array to inspect.

value (*): The value to evaluate.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element.


#### Returns
(number): Returns the index at which value should be inserted into array.


#### Example

```autohotkey
_.sortedIndexBy([{x: 4}, {x: 5}], {x: 4}, "x")
; => 1

_.sortedIndexBy([{x: 4}, {x: 5}], {x: 6}, "x")
; => 3

_.sortedIndexBy([30, 50], 40, (v) => floor(v / 10))
; => 2

```



## .sortedIndexOf
This method is like `.indexOf` except that it performs a binary search on a sorted `array`. Returns the index of the first matching value, otherwise `-1`.


#### Arguments
array (Array): The sorted array to inspect.

value (*): The value to search for.


#### Returns
(number): Returns the index of the matched value, else `-1`.


#### Example

```autohotkey
_.sortedIndexOf([4, 5, 5, 5, 6], 5)
; => 2

```



## .sortedLastIndex
This method is like `.sortedIndex` except that it returns the highest index at which `value` should be inserted into `array` to maintain its sort order.


#### Arguments
array (Array): The sorted array to inspect.

value (*): The value to evaluate.


#### Returns
(number): Returns the index at which value should be inserted into array.


#### Example

```autohotkey
_.sortedLastIndex([4, 5, 5, 5, 6], 5)
; => 5

```



## .sortedLastIndexBy
This method is like `.sortedLastIndex` except that it accepts `iteratee` which is invoked for `value` and each element of `array` to compute their sort ranking. The iteratee is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The sorted array to inspect.

value (*): The value to evaluate.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element.


#### Returns
(number): Returns the index at which value should be inserted into array.


#### Example

```autohotkey
_.sortedLastIndexBy([{x: 4}, {x: 5}], {x: 4}, "x")
; => 2

_.sortedLastIndexBy([30, 50], 40, (v) => floor(v / 10))
; => 2

```



## .sortedLastIndexOf
This method is like `.lastIndexOf` except that it performs a binary search on a sorted `array`. Returns the index of the last matching value, otherwise `-1`.


#### Arguments
array (Array): The sorted array to inspect.

value (*): The value to search for.


#### Returns
(number): Returns the index of the matched value, else `-1`.


#### Example

```autohotkey
_.sortedLastIndexOf([4, 5, 5, 5, 6], 5)
; => 4

```



## .sortedUniq
This method is like [_.uniq](/?id=uniq) except that it's optimized for sorted arrays.


#### Arguments
array (Array): The sorted array to inspect.


#### Returns
(array): Returns the new duplicate free array.


#### Example

```autohotkey
_.sortedUniq([1, 1, 2])
; => [1, 2]

```



## .sortedUniqBy
This method is like `.sortedUniq` except that it accepts `iteratee` which is invoked for each element of `array` to compute the criterion by which they're compared. The iteratee is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The sorted array to inspect.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element.


#### Returns
(array): Returns the new duplicate free array.


#### Example

```autohotkey
_.sortedUniqBy([1, 1.2, 2, 2.9, 3], floor)
; => [1, 2, 3]

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

_.tail("neo")
; => ["e", "o"]

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

_.take("neo")
; => ["n"]

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

_.takeRight("neo")
; => ["o"]

_.takeRight(100)
; => ["0"]

```



## .takeRightWhile
Creates a slice of `array` with elements taken from the end. Elements are taken until `predicate` returns falsey. The predicate is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The array to query.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.takeRightWhile([1, 2, 3, 4], (v) => v > 2)
; => [3, 4]

users := [{user: "cypher", active: false}, {user: "tank", active: true}, {user: "trinity", active: true}]
_.takeRightWhile(users, "active")
; => [{user: "tank", active: true}, {user: "trinity", active: true}]

```



## .takeWhile
Creates a slice of `array` with elements taken from the beginning. Elements are taken until `predicate` returns falsey. The predicate is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The array to query.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(Array): Returns the slice of array.


#### Example

```autohotkey
_.takeWhile([1, 2, 3, 0, 4], (v) => v < 3)
; => [1, 2]

users := [{user: "cypher", active: true}, {user: "tank", active: true}, {user: "trinity", active: false}]
_.takeWhile(users, "active")
; => [{user: "cypher", active: true}, {user: "tank", active: true}]

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



## .unionBy
This method is like `.union` except that it accepts `iteratee` which is invoked for each element of each array to generate the criterion by which uniqueness is computed. The iteratee is invoked with three arguments: (value, index, array).


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the iteratee if it is not an array.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element.


#### Returns
(Array): Returns the new array of combined values.


#### Example

```autohotkey
_.unionBy([2.1], [1.2, 2.3], floor)
; => [2.1, 1.2]

_.unionBy([{x: 1}], [{x: 2}, {x: 1}], "x")
; => [{x: 1}, {x: 2}]

```



## .unionWith
This method is like `.union` except that it accepts `comparator` which is invoked to compare elements of the arrays. The comparator is invoked with two arguments: (arrVal, othVal).


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the comparator if it is a function.


#### Returns
(Array): Returns the new array of combined values.


#### Example

```autohotkey
_.unionWith([1, 2], [1.1, 3], (a, b) => abs(a - b) < 0.5)
; => [1, 2, 3]

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



## .uniqBy
This method is like `.uniq` except that it accepts `iteratee` which is invoked for each element of `array` to generate the criterion by which uniqueness is computed. The order of result values is determined by the order they occur in the array. The iteratee is invoked with three arguments: (value, index, array).


#### Arguments
array (Array): The array to inspect.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element.


#### Returns
(Array): Returns the new duplicate free array.


#### Example

```autohotkey
_.uniqBy([2.1, 1.2, 2.3], floor)
; => [2.1, 1.2]

_.uniqBy([{x: 1}, {x: 2}, {x: 1}], "x")
; => [{x: 1}, {x: 2}]

```



## .uniqWith
This method is like `.uniq` except that it accepts `comparator` which is invoked to compare elements of `array`. The order of result values is determined by the order they occur in the array. The comparator is invoked with two arguments: (arrVal, othVal).


#### Arguments
array (Array): The array to inspect.

[comparator] (Function): The comparator invoked per element.


#### Returns
(Array): Returns the new duplicate free array.


#### Example

```autohotkey
objects := [{x: 1, y: 2}, {x: 1, y: 2}, {x: 2, y: 1}]
_.uniqWith(objects, _.isEqual)
; => [{x: 1, y: 2}, {x: 2, y: 1}]

_.uniqWith([1, 2, 1.1, 3], (a, b) => abs(a - b) < 0.5)
; => [1, 2, 3]

```



## .unzip
This method is like [_.zip](/?id=zip) except that it accepts an array of grouped elements and creates an array regrouping the elements to their pre-zip configuration.

#### Arguments
array (Array): The array of grouped elements to process.


#### Returns

(Array): Returns the new array of regrouped elements.

#### Example

```autohotkey
zipped := _.zip(["a", "b"], [1, 2], [true, false])
; => [["a", 1, true], ["b", 2, false]]
_.unzip(zipped)
; => [["a", "b"], [1, 2], [true, false]]

```



## .unzipWith
This method is like `.unzip` except that it accepts `iteratee` to specify how regrouped values should be combined. The iteratee is invoked with the elements of each regrouped array as its arguments.


#### Arguments
array (Array): The array of grouped elements to process.

[iteratee] (Function): The function to combine each regrouped array.


#### Returns
(Array): Returns the new array of regrouped elements.


#### Example

```autohotkey
_.unzipWith([[1, 10, 100], [2, 20, 200]], (a, b) => a + b)
; => [3, 30, 300]

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



## .xor
Creates an array of unique values that is the [symmetric difference](https://en.wikipedia.org/wiki/Symmetric_difference) of the given arrays. The order of result values is determined by the order they occur in the arrays.


#### Arguments
[arrays] (...Array): The arrays to inspect.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.xor([2, 1], [2, 3])
; => [1, 3]

```



## .xorBy
This method is like `.xor` except that it accepts `iteratee` which is invoked for each element of each array to generate the criterion by which they're compared. The order of result values is determined by the order they occur in the arrays. The iteratee is invoked with three arguments: (value, index, array).


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the iteratee if it is not an array.

[iteratee:=.identity] (Function|Object|Array|string): The iteratee invoked per element.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.xorBy([2.1, 1.2], [2.3, 3.4], floor)
; => [1.2, 3.4]

_.xorBy([{x: 1}, {x: 2}], [{x: 2}, {x: 3}], "x")
; => [{x: 1}, {x: 3}]

```



## .xorWith
This method is like `.xor` except that it accepts `comparator` which is invoked to compare elements of the arrays. The order of result values is determined by the order they occur in the arrays. The comparator is invoked with two arguments: (arrVal, othVal).


#### Arguments
[arrays] (...Array): The arrays to inspect. The last argument may be the comparator if it is a function.


#### Returns
(Array): Returns the new array of filtered values.


#### Example

```autohotkey
_.xorWith([1, 2], [2, 3], (a, b) => a == b)
; => [1, 3]

_.xorWith([{x: 1}, {x: 2}], [{x: 1}], _.isEqual)
; => [{x: 2}]

```



## .zip
Creates an array of grouped elements, the first of which contains the first elements of the given arrays, the second of which contains the second elements of the given arrays, and so on.


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
This method is like [_.fromPairs](/?id=frompairs) except that it accepts two arrays, one of property identifiers and one of corresponding values.


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



## .zipObjectDeep
This method is like `.zipObject` except that it supports property paths. Deep paths create nested objects and arrays. Array indexes in a path are 1-based, matching AutoHotkey arrays.


#### Arguments
[paths:=[]] (Array): The property paths.

[values:=[]] (Array): The property values.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.zipObjectDeep(["a.b[1].c", "a.b[2].d"], [1, 2])
; => {a: {b: [{c: 1}, {d: 2}]}}

_.zipObjectDeep(["x.y", "z"], [1, 2])
; => {x: {y: 1}, z: 2}

```



## .zipWith
This method is like `.zip` except that it accepts `iteratee` to specify how grouped values should be combined. The iteratee is invoked with the elements of each group as its arguments.


#### Arguments
[arrays] (...Array): The arrays to process. The last argument may be the iteratee if it is a function.


#### Returns
(Array): Returns the new array of grouped elements, or of iteratee results.


#### Example

```autohotkey
_.zipWith([1, 2], [10, 20], (a, b) => a + b)
; => [11, 22]

```




# **Collection methods**
## .countBy
Creates an object composed of keys generated from the results of running each element of `collection` thru `iteratee`. The value of each key is the number of elements that produced it.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[iteratee=_.identity] (Function|string|Array|Object): The iteratee to transform each element into a key.


#### Returns
(Object): Returns the composed object.


#### Example

```autohotkey
_.countBy([1, 2, 3, 4], (n) => mod(n, 2) == 0 ? "odd" : "even")
; => {even: 2, odd: 2}

```



## .every
Checks if `predicate` returns truthy for all elements of `collection`. Iteration stops once `predicate` returns falsy.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[predicate=_.identity] (Function|string|Array|Object): The function invoked per element.


#### Returns
(Boolean): Returns `true` if all elements pass the predicate, else `false`.


#### Example

```autohotkey
_.every([2, 4, 6], (n) => mod(n, 2) == 0)
; => true

_.every([2, 3, 6], (n) => mod(n, 2) == 0)
; => false

```



## .filter
Iterates over elements of `collection`, returning an array of all elements `predicate` returns truthy for. The predicate is invoked with three arguments: (value, index|key, collection).


#### Arguments
collection (Array|Object|Map): The collection to iterate over.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.

#### Returns
(Array): Returns the new filtered array.


#### Example

```autohotkey
users := [{user: "cypher", age: 36, active: true}, {user: "tank", age: 40, active: false}]
_.filter(users, fn_filterFunc)
; => [{user: "cypher", age: 36, active: true}]

fn_filterFunc(param_iteratee) {
	if (param_iteratee.active) {
		return true
	}
; The _.matches shorthand
_.filter(users, {age: 36, active: true})
; => [{user: "cypher", age: 36, active: true}]

; The _.matchesProperty shorthand
_.filter(users, ["active", false])
; => [{user: "tank", age: 40, active: false}]

; The _.property shorthand
_.filter(users, "active")
; => [{user: "cypher", age: 36, active: true}]

```



## .find
Iterates over elements of `collection`, returning the first element `predicate` returns truthy for. The predicate is invoked with three arguments: (value, index|key, collection).


#### Arguments
collection (Array|Object): The collection to inspect.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.

[fromIndex:=1] (number): The index to search from.


#### Returns
(*): Returns the matched element, else `""`.


#### Example

```autohotkey
users := [{user: "cypher", age: 36, active: true}
	, {user: "tank", age: 40, active: false}
	, {user: "trinity", age: 1, active: true}]
_.find(users, (o) => o.age < 40)
; => {user: "cypher", age: 36, active: true}

; The _.matches iteratee shorthand.
_.find(users, {age: 1, active: true})
; => {user: "trinity", age: 1, active: true}

; The _.matchesProperty iteratee shorthand.
_.find(users, ["active", false])
; => {user: "tank", age: 40, active: false}

; The _.property iteratee shorthand.
_.find(users, "active")
; => {user: "cypher", age: 36, active: true}

```



## .findLast
Iterates over `collection` from right to left and returns the first element that `predicate` returns truthy for.


#### Arguments
collection (Array|Object|Map|string): The collection to search.

[predicate=_.identity] (Function|string|Array|Object): The function invoked per element.

[fromIndex] (integer): The 1-based index to start searching from. Negative values count back from the end. Defaults to the last element.


#### Returns
(*): Returns the matched element, or an empty string if none matches.


#### Example

```autohotkey
_.findLast([1, 2, 3, 4], (n) => mod(n, 2) == 1)
; => 3

```



## .flatMap
Creates a flattened array of values by running each element in collection thru iteratee and flattening the mapped results. The iteratee is invoked with three arguments: (value, index|key, collection).


#### Arguments
collection (Array|Object): The collection to iterate over.

[iteratee:=.identity] (Function): The function invoked per iteration.


#### Returns
(Array): Returns the new flattened array.


#### Example

```autohotkey
fn_flatMapDuplicate(n) {
	return [n, n]
_.flatMap([1, 2], fn_flatMapDuplicate)
; => [1, 1, 2, 2]

```



## .flatMapDeep
This method is like `.flatMap` except that it recursively flattens the mapped results.


#### Arguments
collection (Array|Object): The collection to iterate over.

[iteratee:=.identity] (Function): The function invoked per iteration.


#### Returns
(Array): Returns the new flattened array.


#### Example

```autohotkey
fn_flatMapDeepDuplicate(n) {
	return [[[n, n]]]
_.flatMapDeep([1, 2], fn_flatMapDeepDuplicate)
; => [1, 1, 2, 2]

```



## .flatMapDepth
This method is like `.flatMap` except that it recursively flattens the mapped results up to depth times.


#### Arguments
collection (Array|Object): The collection to iterate over.

[iteratee:=.identity] (Function): The function invoked per iteration.

[depth:=1] (number): The maximum recursion depth.


#### Returns
(Array): Returns the new flattened array.


#### Example

```autohotkey
fn_flatMapDepthDuplicate(n) {
	return [[[n, n]]]
_.flatMapDepth([1, 2], fn_flatMapDepthDuplicate, 2)
; => [[1, 1], [2, 2]]

_.flatMapDepth([1, 2], fn_flatMapDepthDuplicate, 1)
; => [[[1, 1]], [[2, 2]]]

```



## .forEach
Iterates over elements of `collection` and invokes `iteratee` for each element. The iteratee is invoked with three arguments: (value, index|key, collection). Iteratee functions may exit iteration early by explicitly returning `false`.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[iteratee:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(*): Returns `collection`.


#### Aliases
.each


#### Example

```autohotkey
output := []
_.forEach([1, 2], (value) => output.push(value))
output
; => [1, 2]

output := []
_.forEach({a: 1, b: 2}, (value, key) => output.push(key))
output
; => ["a", "b"]

```



## .forEachRight
Iterates over `collection` from right to left, invoking `iteratee` for each element. Returning `false` from `iteratee` exits early.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[iteratee=_.identity] (Function): The function invoked per element.


#### Returns
(*): Returns `collection`.


#### Example

```autohotkey
output := []
_.forEachRight([1, 2, 3], (value) => output.push(value))
output
; => [3, 2, 1]

```



## .groupBy
Creates an object composed of keys generated from the results of running each element of `collection` thru `iteratee`. The value of each key is an array of the elements responsible for generating the key.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[iteratee=_.identity] (Function|string|Array|Object): The iteratee to transform each element into a key.


#### Returns
(Object): Returns the composed object.


#### Example

```autohotkey
_.groupBy(["one", "two", "three"], (s) => (strLen(s) == 3 ? "short" : "long"))
; => {short: ["one", "two"], long: ["three"]}

```



## .includes
Checks if value is in collection. If collection is a string, it's checked for a substring of value.


#### Arguments
collection (Array|Object|string): The collection to inspect.

value (*): The value to search for.

[fromIndex:=1] (number): The index to search from.


#### Returns
(boolean): Returns true if value is found, else false.


#### Example

```autohotkey
```



## .invokeMap
Invokes the method at `path` of each element in `collection`, returning an array of the results of each invoked method. Any additional arguments are provided to each invoked method. If `path` is a function, it's invoked with each element as the first argument, followed by `args`.

When an element doesn't have the method (for example, strings and numbers), the adash method of the same name is used instead, with the element as its first argument.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

path (Array|Function|string): The path of the method to invoke or the function invoked per iteration.

[args] (...*): The arguments to invoke each method with.


#### Returns
(Array): Returns the array of results.




## .keyBy
Creates an object composed of keys generated from the results of running each element of `collection` thru `iteratee`. The corresponding value of each key is the last element responsible for generating the key.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[iteratee=_.identity] (Function|string|Array|Object): The iteratee to transform each element into a key.


#### Returns
(Object): Returns the composed object.


#### Example

```autohotkey
keyByData := [{dir: "left", code: 97}, {dir: "right", code: 100}]
_.keyBy(keyByData, "dir")
; => {left: {dir: "left", code: 97}, right: {dir: "right", code: 100}}

```



## .map
Creates an array of values by running each element in collection thru iteratee. The iteratee is invoked with three arguments: (value, index|key, collection).

Many adash.ahk methods are guarded to work as iteratees

The guarded methods are:
trimEnd, trimStart, parseInt, chunk, take, takeRight, drop, sampleSize, words, random

#### Arguments
collection (Array|Object): The collection to iterate over.

[iteratee:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(Array): Returns the new mapped array.


#### Example

```autohotkey
fn_square(n) {
	return n * n
_.map([4, 8], fn_square)
; => [16, 64]

_.map({ a: 4, b: 8 }, fn_square)
; => [16, 64]

data_array := ["Neo", "Morpheus", "Trinity"]
_.map(data_array, (value) => ({name: value, id: A_Index}))
; => [{name: "Neo", id: 1}, {name: "Morpheus", id: 2}, {name: "Trinity", id: 3}]

```



## .orderBy
Creates an array of elements sorted by the results of running each element of `collection` thru each iteratee. Sort orders are applied per iteratee, in order. Ties fall back to the original order.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[iteratees:=identity] (Function|string|Array|Object): The iteratees to sort by.

[orders] (string|Array): The sort direction for each iteratee, `"asc"` or `"desc"`. Iteratees without an order sort ascending.


#### Returns
(Array): Returns the new sorted array.


#### Example

```autohotkey
orderData := [{n: "b", a: 2}, {n: "a", a: 2}, {n: "c", a: 1}]
_.orderBy(orderData, ["a", "n"], ["desc", "asc"])
; => [{n: "a", a: 2}, {n: "b", a: 2}, {n: "c", a: 1}]

```



## .partition
Creates an array of two arrays: the first holds the elements `predicate` returns truthy for, and the second holds the rest.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[predicate=_.identity] (Function|string|Array|Object): The function invoked per element.


#### Returns
(Array): Returns the array of two partitions.


#### Example

```autohotkey
_.partition([1, 2, 3, 4], (n) => mod(n, 2) == 1)
; => [[1, 3], [2, 4]]

```



## .reduce
Reduces `collection` to a single value. Each step passes the accumulator, the element value, its key, and the collection to `iteratee`. Without an accumulator, the first element is used as the starting value.


#### Arguments
collection (Array|Object|Map|string): The collection to reduce.

[iteratee:=identity] (Function): The function invoked per element.

[accumulator] (*): The initial value.


#### Returns
(*): Returns the accumulated value.


#### Example

```autohotkey
_.reduce([1, 2, 3], (acc, n) => acc + n)
; => 6

_.reduce([1, 2, 3], (acc, n) => acc + n, 10)
; => 16

```



## .reduceRight
Like `reduce`, but walks `collection` from right to left.


#### Arguments
collection (Array|Object|Map|string): The collection to reduce.

[iteratee:=identity] (Function): The function invoked per element.

[accumulator] (*): The initial value.


#### Returns
(*): Returns the accumulated value.


#### Example

```autohotkey
_.reduceRight(["a", "b", "c"], (acc, v) => acc v, "")
; => "cba"

```



## .reject
The opposite of `filter`. Returns the elements of `collection` that `predicate` does not return truthy for.


#### Arguments
collection (Array|Object|Map|string): The collection to iterate over.

[predicate=_.identity] (Function|string|Array|Object): The function invoked per element.


#### Returns
(Array): Returns the new array of rejected elements.


#### Example

```autohotkey
_.reject([1, 2, 3, 4], (n) => mod(n, 2) == 1)
; => [2, 4]

```



## .sample
Gets a single random element from `collection`.

#### Arguments
collection (Array|Object|String): The collection to sample.


#### Returns
(*): Returns the random element.


#### Example
```autohotkey
_.sample([1, 2, 3, 4])
; => 2
```




## .sampleSize
Gets `n` random elements at unique keys from `collection` up to the size of `collection`.


#### Arguments
collection (Array|Object|String): The collection to sample.

[n:=1] (number): The number of elements to sample.


#### Returns
(Array): Returns the random elements.


#### Example
```autohotkey
_.sampleSize([1, 2, 3], 2)
; => [3, 1]

_.sampleSize([1, 2, 3], 4)
; => [2, 3, 1]
```




## .shuffle
Creates an array of shuffled values, using a version of the [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher-Yates_shuffle).

#### Arguments
collection (Array|Object): The collection to shuffle.


#### Returns
(Array): Returns the new shuffled array.


#### Example
```autohotkey
_.shuffle([1, 2, 3, 4])
; => [4, 1, 3, 2]

_.shuffle(["morpheus", "neo", "trinity"])
; => ["trinity", "morpheus", "neo"]
```




## .size
Gets the size of `collection` by returning its length for array-like values or the number of own enumerable string keyed properties for objects.


#### Arguments
collection (Array|Object|string): The collection to inspect.


#### Returns
(number): Returns the collection size.


#### Example

```autohotkey
_.size([1, 2, 3])
; => 3

_.size({ a: 1, b: 2 })
; => 2

_.size("trinity")
; => 7

```



## .some
Checks if `predicate` returns truthy for **any** element of `collection`. Iteration is stopped once `predicate` returns truthy. The predicate is invoked with three arguments: (value, index|key, collection).


#### Arguments
collection (Array|Object): The collection to iterate over.

[predicate:=.identity] (Function|Object|Array|string): The function invoked per iteration. An Object uses the `.matches` shorthand, an Array uses `.matchesProperty`, and a string uses `.property`.


#### Returns
(boolean): Returns true if any element passes the predicate check, else false.


#### Example

```autohotkey
_.some(["foo", "bar", 42], _.isNumber)
; => true

```



## .sortBy
Creates an array of elements, sorted in ascending order by the results of running each element in a collection thru each iteratee. This method performs a stable sort, that is, it preserves the original sort order of equal elements. The iteratees are invoked with one argument: (value).

Numbers sort numerically and before strings; strings follow `_.stringCaseSense`.


#### Arguments
collection (Array|Object|string): The collection to iterate over.

[iteratees:=.identity] (Function|string|Array): The iteratees to sort by. A string sorts by that property path; an array of iteratees sorts by each in priority order.


#### Returns
(Array): Returns the new sorted array.


#### Example

```autohotkey
users := [{name: "tank", age: 48}
	, {name: "cypher", age: 36}
	, {name: "tank", age: 40}
	, {name: "cypher", age: 34}]
_.sortBy(users, "age")
; => [{name: "cypher", age: 34}, {name: "cypher", age: 36}, {name: "tank", age: 40}, {name: "tank", age: 48}]

_.sortBy(users, ["name", "age"])
; => [{name: "cypher", age: 34}, {name: "cypher", age: 36}, {name: "tank", age: 40}, {name: "tank", age: 48}]

_.sortBy(users, (o) => o.name)
; => [{name: "cypher", age: 36}, {name: "cypher", age: 34}, {name: "tank", age: 48}, {name: "tank", age: 40}]

_.sortBy(["b", "f", "e", "c", "d", "a"])
; => ["a", "b", "c", "d", "e", "f"]

_.sortBy(["ab", "a", " abc", "abc"], _.size)
; => ["a", "ab", "abc", " abc"]

```




# **Functions methods**
## .after
The opposite of `_.before`; this method creates a function that invokes `func` once it's called `n` or more times. Calls before that return `""`.


#### Arguments
n (number): The number of calls before `func` is invoked.

func (Function): The function to restrict.


#### Returns
(Function): Returns the new restricted function.


#### Example

```autohotkey
counter := {n: 0}
fn := _.after(3, (*) => ++counter.n)
fn.call()
; => ""

fn.call()
; => ""

fn.call()
; => 1

fn.call()
; => 2

```



## .ary
Creates a function that invokes `func` with at most `n` arguments. Any additional arguments are ignored.


#### Arguments
func (Function): The function to cap the arguments of.

[n:=func.maxParams] (integer): The maximum number of arguments to pass. Defaults to the parameter count of `func`.


#### Returns
(Function): Returns the new capped function.


#### Example

```autohotkey
aryAdd := (a, b := 0, c := 0) => a + b + c
_.ary(aryAdd, 2).call(1, 2, 3)
; => 3

_.ary(aryAdd, 1).call(5, 6, 7)
; => 5

```



## .before
Creates a function that invokes `func`, with the arguments of the created function, while it's called less than `n` times. Subsequent calls to the created function return the result of the last `func` invocation.


#### Arguments
n (number): The number of calls at which `func` is no longer invoked.

func (Function): The function to restrict.


#### Returns
(Function): Returns the new restricted function.


#### Example

```autohotkey
counter := {n: 0}
fn := _.before(3, (*) => ++counter.n)
fn.call()
; => 1

fn.call()
; => 2

fn.call()
; => 2

```



## .bind
Creates a function that invokes `func` with `thisArg` as its first argument (the `this` value for methods), followed by any partial arguments and then the arguments of the created function.


#### Arguments
func (Function): The function to bind.

thisArg (Any): The value passed as the first argument, which is `this` for methods.

[partials*] (Any): Arguments to pass before the arguments of the created function.


#### Returns
(Function): Returns the new bound function.


#### Example

```autohotkey
bindSum := (self, a, b) => self.x + a + b
_.bind(bindSum, {x: 1}, 2).call(3)
; => 6

```



## .bindKey
Creates a function that invokes the method `object[key]` with `object` as its `this` value. The method is looked up each time the created function is called, so reassigning it changes what runs.


#### Arguments
object (Object): The object that owns the method.

key (string): The name of the method.

[partials*] (Any): Arguments to pass before the arguments of the created function.


#### Returns
(Function): Returns the new bound function.


#### Example

```autohotkey
bindObj := {n: 5, sum: (self, x, y) => self.n + x + y}
_.bindKey(bindObj, "sum", 2).call(3)
; => 10

```



## .curry
Creates a function that collects arguments across calls until it has `arity` of them, then invokes `func` with all collected arguments. Until then, each call returns a new function that keeps the arguments collected so far.


#### Arguments
func (Function): The function to curry.

[arity:=func.maxParams] (integer): The number of arguments needed before `func` is invoked. Defaults to the parameter count of `func`.


#### Returns
(Function): Returns the new curried function.


#### Example

```autohotkey
curryAdd := (a, b, c) => a + b + c
curried := _.curry(curryAdd)
curried.call(1).call(2).call(3)
; => 6

curried.call(1, 2).call(3)
; => 6

curried.call(1, 2, 3)
; => 6

```



## .curryRight
Like `curry`, but arguments are applied from the right. Each call's arguments are placed before the arguments already collected, as with `partialRight`. Once `arity` arguments are collected, `func` is invoked.


#### Arguments
func (Function): The function to curry.

[arity:=func.maxParams] (integer): The number of arguments needed before `func` is invoked. Defaults to the parameter count of `func`.


#### Returns
(Function): Returns the new curried function.


#### Example

```autohotkey
curryRightDigits := (a, b, c) => a * 100 + b * 10 + c
curriedRight := _.curryRight(curryRightDigits)
curriedRight.call(3).call(2).call(1)
; => 123

curriedRight.call(2, 3).call(1)
; => 123

```



## .debounce
Creates a debounced function that delays invoking `func` until `wait` milliseconds have passed since its last call. Each call restarts the wait. The created function returns the result of the most recent invocation of `func`.


#### Arguments
func (Function): The function to debounce.

[wait:=0] (integer): The number of milliseconds to wait after the last call.


#### Returns
(Function): Returns the new debounced function.


#### Example

```autohotkey
debounceCounter := {n: 0}
debounced := _.debounce((*) => ++debounceCounter.n, 100)
debounced.call()
; => ""

```



## .defer
Defers invoking `func` until the current thread is idle. The created call returns immediately and `func` runs afterward with the remaining arguments.


#### Arguments
func (Function): The function to defer.

[args*] (Any): Arguments to pass to `func`.


#### Returns
(String): Returns an empty string.


#### Example

```autohotkey
_.defer((*) => 1)
; => ""

```



## .delay
Invokes `func` after `wait` milliseconds with the remaining arguments. The call returns immediately.


#### Arguments
func (Function): The function to delay.

wait (integer): The number of milliseconds to wait before invoking `func`.

[args*] (Any): Arguments to pass to `func`.


#### Returns
(String): Returns an empty string.


#### Example

```autohotkey
_.delay((*) => 1, 10)
; => ""

```



## .flip
Creates a function that invokes `func` with its arguments reversed.


#### Arguments
func (Function): The function to flip.


#### Returns
(Function): Returns the new flipped function.


#### Example

```autohotkey
flipSubtract := (a, b) => a - b
_.flip(flipSubtract).call(1, 10)
; => 9

```



## .memoize
Creates a function that caches the results of `func`. Results are cached by the first argument, or by the result of `resolver` when one is given. Object keys are compared by reference.


#### Arguments
func (Function): The function to memoize.

[resolver] (Function): The function that returns the cache key. It receives the same arguments as `func`.


#### Returns
(Function): Returns the new memoized function.


#### Example

```autohotkey
fn_memoDouble(n) {
	memoCounter.n++
	return n * 2
memoCounter := {n: 0}
memoDouble := _.memoize(fn_memoDouble)
memoDouble.call(2)
; => 4

memoDouble.call(3)
; => 6

```



## .negate
Creates a function that negates the result of `predicate`.


#### Arguments
predicate (Function): The predicate to negate.


#### Returns
(Function): Returns the new negated function.


#### Example

```autohotkey
negatePositive := (n) => n > 0
_.negate(negatePositive).call(-1)
; => true

_.negate(negatePositive).call(1)
; => false

```



## .now
Gets the number of milliseconds that have elapsed since the Unix epoch (1970-01-01 UTC).


#### Returns
(Integer): Returns the current time in milliseconds.


#### Example

```autohotkey
assert.true(_.now() > 1700000000000)
```



## .once
Creates a function that is restricted to invoking `func` once. Repeat calls to the function return the value of the first invocation. `func` is invoked with the arguments of the created function.


#### Arguments
func (Function): The function to restrict.


#### Returns
(Function): Returns the new restricted function.


#### Example

```autohotkey
counter := {n: 0}
initialize := _.once((*) => ++counter.n)
initialize.call()
; => 1

initialize.call()
; => 1

```



## .overArgs
Creates a function that passes each argument through the matching function in `transforms` before invoking `func`. Arguments past the end of `transforms` are passed unchanged.


#### Arguments
func (Function): The function to wrap.

[transforms:=[]] (Array): The functions that transform each argument, in order.


#### Returns
(Function): Returns the new function.


#### Example

```autohotkey
overArgsAdd := (x, y) => x + y
_.overArgs(overArgsAdd, [(n) => n * 2, (n) => n * 10]).call(1, 2)
; => 22

```



## .partial
Creates a function that invokes `func` with `partials` prepended to the arguments it receives.


#### Arguments
func (Function): The function to partially apply.

[partials*] (Any): Arguments to pass before the arguments of the created function.


#### Returns
(Function): Returns the new partially applied function.


#### Example

```autohotkey
partialAdd := (a, b, c) => a + b + c
_.partial(partialAdd, 1, 2).call(3)
; => 6

```



## .partialRight
Creates a function that invokes `func` with the arguments it receives followed by `partials`.


#### Arguments
func (Function): The function to partially apply.

[partials*] (Any): Arguments to pass after the arguments of the created function.


#### Returns
(Function): Returns the new partially applied function.


#### Example

```autohotkey
partialRightSub := (a, b) => a - b
_.partialRight(partialRightSub, 1).call(10)
; => 9

```



## .rearg
Creates a function that invokes `func` with its arguments reordered. Position `i` receives the argument at zero-based position `indexes[i]`. Positions without an index keep their own argument.


#### Arguments
func (Function): The function to rearrange arguments for.

indexes (Array): The zero-based argument positions, in the order they should be passed.


#### Returns
(Function): Returns the new rearranged function.


#### Example

```autohotkey
rearDigits := (a, b, c) => a * 100 + b * 10 + c
_.rearg(rearDigits, [2, 0, 1]).call(1, 2, 3)
; => 312

```



## .rest
Creates a function that invokes `func` with the arguments from `start` onward gathered into an array, which is passed as the final parameter.


#### Arguments
func (Function): The function to apply the rest parameter to.

[start:=func.maxParams-1] (integer): The position the rest parameter starts at. Defaults to the last parameter of `func`.


#### Returns
(Function): Returns the new function.


#### Example

```autohotkey
restLength := (a, b) => a + b.length
_.rest(restLength, 1).call(10, 1, 2, 3)
; => 13

```



## .spread
Creates a function that spreads the array argument at position `start` into separate arguments for `func`. Arguments before `start` are passed as they are, and arguments after the array are dropped.


#### Arguments
func (Function): The function to spread arguments into.

[start:=0] (integer): The position of the array argument.


#### Returns
(Function): Returns the new spreading function.


#### Example

```autohotkey
spreadAdd := (a, b) => a + b
_.spread(spreadAdd).call([1, 2])
; => 3

```



## .throttle
Creates a throttled function that invokes `func` at most once per `wait` milliseconds. The first call invokes `func` immediately. Calls inside the wait window return the result of the last invocation without calling `func`.


#### Arguments
func (Function): The function to throttle.

[wait:=0] (integer): The number of milliseconds to wait between invocations.


#### Returns
(Function): Returns the new throttled function.


#### Example

```autohotkey
throttleCounter := {n: 0}
throttled := _.throttle((*) => ++throttleCounter.n, 1000)
throttled.call()
; => 1

throttled.call()
; => 1

```



## .unary
Creates a function that accepts any number of arguments but invokes `func` with only the first.


#### Arguments
func (Function): The function to cap at one argument.


#### Returns
(Function): Returns the new unary function.


#### Example

```autohotkey
unaryOptional := (a, b := 0) => a + b
_.unary(unaryOptional).call(1, 5)
; => 1

```



## .wrap
Creates a function that invokes `wrapper` with `value` as its first argument, followed by the arguments of the created function.


#### Arguments
value (Any): The value to pass as the first argument to `wrapper`.

[wrapper:=identity] (Function): The function to wrap the value with.


#### Returns
(Function): Returns the new wrapped function.


#### Example

```autohotkey
_.wrap(10, (v, n) => v * n).call(3)
; => 30

```




# **Lang methods**
## .castArray
Casts `value` to an array if it is not one already. Arrays are returned as they are, unset returns an empty array, and any other value is wrapped in an array.


#### Arguments
value (*): The value to cast.


#### Returns
(Array): Returns the cast array.


#### Example

```autohotkey
_.castArray(1)
; => [1]

_.castArray("a")
; => ["a"]

```



## .clone
Creates a shallow clone of `value`. Supports arrays, maps, and objects. Nested values are shared with the original. Primitives and functions are returned as is.


#### Arguments
value (*): The value to clone.


#### Returns
(*): Returns the cloned value.


#### Example

```autohotkey
objects := [{ a: 1 }, { b: 2 }]
shallow := _.clone(objects)
_.isEqual(objects, shallow)
; => true

```



## .cloneDeep
This method is like [_.clone](/?id=clone) except that it recursively clones `value`. Arrays, maps, and objects are cloned at every level, and circular references are preserved. Primitives and functions are returned as is.


#### Arguments
value (*): The value to recursively clone.


#### Returns
(*): Returns the deep cloned value.


#### Example

```autohotkey
obj := [{ a: [[1, 2, 3]] }, { b: 2 }]
deepclone := _.cloneDeep(obj)
obj[1].a := 2
; object
; => [{ "a": 2 }, { "b": 2 }]
; deepclone
; => [{ "a": [[1, 2, 3]] }, { "b": 2 }]
```



## .cloneDeepWith
This method is like `.cloneDeep` except that it accepts a `customizer` which is invoked with each value (including the root). If the customizer returns a value, that value is used; if it returns `unset`, the default deep clone is used.


#### Arguments
value (*): The value to deep clone.

customizer (Function): The function to customize cloning. Receives the value and returns the clone, or `unset` to use the default.


#### Returns
(*): Returns the deep cloned value.


#### Example

```autohotkey
```



## .cloneWith
This method is like `.clone` except that it accepts a `customizer` which is invoked with the value. If the customizer returns a value, that value is used; if it returns `unset`, a shallow clone is returned.


#### Arguments
value (*): The value to clone.

customizer (Function): The function to customize cloning. Receives the value and returns the clone, or `unset` to use the default.


#### Returns
(*): Returns the cloned value.


#### Example

```autohotkey
```



## .conformsTo
Checks if `object` conforms to `source` by invoking each predicate property of `source` with the corresponding property value of `object`.


#### Arguments
object (Object): The object to inspect.

source (Object): The object of property predicates to conform to.


#### Returns
(boolean): Returns `true` if object conforms to source, else `false`.


#### Example

```autohotkey
fn_conformsToGreaterThanOne(param_n) {
	return param_n > 1
source := {b: fn_conformsToGreaterThanOne}
_.conformsTo({a: 1, b: 2}, source)
; => true

_.conformsTo({a: 1, b: 1}, source)
; => false

```



## .eq
Performs a `SameValueZero`-style comparison between two values. Objects are equal only when they are the same reference. Numbers compare numerically, and a number never equals a string.


#### Arguments
value (*): The value to compare.

other (*): The other value to compare.


#### Returns
(boolean): Returns `true` if the values are equal, else `false`.


#### Example

```autohotkey
_.eq(1, 1)
; => true

_.eq(1, 1.0)
; => true

_.eq(1, "1")
; => false

_.eq("neo", "trinity")
; => false

obj := {a: 1}
_.eq(obj, obj)
; => true

```



## .gt
Checks if `value` is greater than `other`.


#### Arguments
value (*): The value to compare.

other (*): The other value to compare.


#### Returns
(boolean): Returns `true` if value is greater than other, else `false`.


#### Example

```autohotkey
_.gt(3, 1)
; => true

_.gt(1, 3)
; => false

```



## .gte
Checks if `value` is greater than or equal to `other`.


#### Arguments
value (*): The value to compare.

other (*): The other value to compare.


#### Returns
(boolean): Returns `true` if value is greater than or equal to other, else `false`.


#### Example

```autohotkey
_.gte(3, 3)
; => true

_.gte(2, 3)
; => false

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
; => false

_.isAlnum("hello")
; => true

_.isAlnum([])
; => false

_.isAlnum({})
; => false

```



## .isArguments
Checks if `value` is an arguments object. AHK has no arguments object (variadic parameters are Arrays), so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isArguments([1, 2, 3])
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
; => false

```



## .isArrayBuffer
Checks if `value` is classified as an ArrayBuffer. AHK's `Buffer` is treated as the equivalent.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is a Buffer, else `false`.


#### Example

```autohotkey
myBuffer := buffer(20, 100)
_.isArrayBuffer(myBuffer)
; => true

```



## .isArrayLike
Checks if `value` is array-like. A value is array-like if it is an Array, a Buffer, or a String.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is array-like, else `false`.


#### Example

```autohotkey
_.isArrayLike([1, 2])
; => true

_.isArrayLike("abc")
; => true

_.isArrayLike(map())
; => false

```



## .isArrayLikeObject
Checks if `value` is array-like and object-like. Strings and functions are not array-like objects.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is an array-like object, else `false`.


#### Example

```autohotkey
_.isArrayLikeObject([1])
; => true

_.isArrayLikeObject("abc")
; => false

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



## .isBuffer
Checks if `value` is a buffer.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is a buffer, else false.


#### Example

```autohotkey
myBuffer := buffer(20, 100)
_.isBuffer(myBuffer)
; => true

```



## .isDate
Checks if `value` is a Date object. AHK has no Date type (timestamps are plain strings), so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isDate(A_Now)
; => false

```



## .isElement
Checks if `value` is a DOM element. AHK has no DOM, so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isElement({})
; => false

```



## .isEmpty
Checks if `value` is an empty object, array, or map.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is empty, else `false.


#### Example

```autohotkey
_.isEmpty([])
; => true

_.isEmpty({})
; => true

_.isEmpty(map())
; => true

```



## .isEqual
Performs a deep comparison between two values to determine if they are equivalent.

This method supports comparing numbers, strings, Arrays, Maps, plain objects, and class instances (by their own properties). Numbers and numeric strings compare numerically, other strings follow `.stringCaseSense`, key order does not matter, and circular references are handled. Functions and other built-in objects are only equal to themselves.


#### Arguments
value (*): The value to compare.

other (...*): The other values to compare.


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



## .isEqualWith
This method is like `.isEqual` except that it accepts a `customizer` which is invoked to compare values at every level. If the customizer returns a boolean, that result is used; if it returns `unset`, the default comparison is used.


#### Arguments
value (*): The value to compare.

other (*): The other value to compare.

customizer (Function): The function to customize comparisons. Receives the two values and returns a boolean, or `unset` to use the default.


#### Returns
(boolean): Returns `true` if the values are equivalent, else `false`.


#### Example

```autohotkey
```



## .isError
Checks if value is an exception error obj.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is an exception object, else false.


#### Example

```autohotkey
_.isError(Error("something broke"))
; => true

_.isError(ValueError("bad value"))
; => true

```



## .isFinite
Checks if `value` is a finite primitive number. Numeric strings are not numbers, so they return `false`.


#### Arguments
value (*): The value to check.


#### Returns
(Boolean): Returns `true` if `value` is a finite number, else `false`.


#### Example

```autohotkey
_.isFinite(1)
; => true

_.isFinite(1.5)
; => true

_.isFinite("1")
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
value (*): The value to check.


#### Returns
(boolean): Returns `true` if `value` is callable, else `false`.


#### Example

```autohotkey
bndFunc := strLen.bind("one")
_.isFunction(bndFunc)
; => true

_.isFunction(_.size)
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



## .isLength
Checks if `value` is a valid array-like length: an integer from `0` to `9007199254740991`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is a valid length, else `false`.


#### Example

```autohotkey
_.isLength(0)
; => true

_.isLength(3)
; => true

_.isLength(-1)
; => false

```



## .isMap
Checks if `value` is classified as a Map object.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if `value` is a native function, else `false`.


#### Example

```autohotkey
_.isMap(map(1, "Neo"))
; => true

_.isMap([])
; => false

```



## .isMatch
Performs a partial deep comparison between `object` and source to determine if `object` contains equivalent property values.

Partial comparisons will match empty array and empty object `source` values against any array or object value, respectively. See [_.isEqual](/?id=isEqual).


#### Arguments
object obj: The object to inspect.

source obj: The object of property values to match.


#### Returns
(boolean): Returns true if object is a match, else false.

#### Example

```autohotkey
obj := { a: 1, b: 2, c: 3 }
_.isMatch(obj, {b: 2})
; => true

_.isMatch(obj, {b: 2, c: 3})
; => true

_.isMatch(obj, {b: 1})
; => false

_.isMatch(obj, {b: 2, z: 99})
; => false

```



## .isMatchWith
This method is like `.isMatch` except that it accepts a `customizer` which is invoked with each property value of `object` and the matching property value of `source`. If the customizer returns a boolean, that result is used; if it returns `unset`, the default comparison is used.


#### Arguments
object (Object): The object to inspect.

source (Object): The object of property values to match.

customizer (Function): The function to customize comparisons. Receives the object value and source value, and returns a boolean, or `unset` to use the default.


#### Returns
(boolean): Returns `true` if object is a match, else `false`.


#### Example

```autohotkey
```



## .isNaN
Checks if `value` is `NaN`. Only float values can be `NaN`, so every other type returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(Boolean): Returns `true` if `value` is `NaN`, else `false`.


#### Example

```autohotkey
_.isNaN(1)
; => false

_.isNaN(1.5)
; => false

_.isNaN("nan")
; => false

```



## .isNative
Checks if `value` is a pristine native function. A bound built-in (from `.bind()`) also reports as native, because AutoHotkey marks it as built-in.


#### Arguments
value (*): The value to check.



#### Returns
(boolean): Returns `true` if `value` is a native function, else `false`.


#### Example

```autohotkey
_.isNative(isFloat)
; => true

boundFn := inStr.bind()
_.isNative(boundFn)
; => false

_.isNative(_)
; => false

```



## .isNil
Checks if `value` is `nil`. AutoHotkey has no `null` value, so `nil` means unset.


#### Arguments
value (*): The value to check.


#### Returns
(Boolean): Returns `true` if `value` is unset, else `false`.


#### Example

```autohotkey
_.isNil(unset)
; => true

_.isNil("")
; => false

_.isNil(0)
; => false

_.isNil({})
; => false

```



## .isNull
Checks if `value` is `null`. AutoHotkey has no `null` value, so `null` is treated the same as unset. This matches `isNil`.


#### Arguments
value (*): The value to check.


#### Returns
(Boolean): Returns `true` if `value` is unset, else `false`.


#### Example

```autohotkey
_.isNull(unset)
; => true

_.isNull("")
; => false

_.isNull(0)
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



## .isObjectLike
Checks if `value` is object-like. A value is object-like if it is an object and not a function.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is object-like, else `false`.


#### Example

```autohotkey
_.isObjectLike({})
; => true

_.isObjectLike([1])
; => true

_.isObjectLike("abc")
; => false

```



## .isPlainObject
Checks if `value` is a plain object created with `{}`. Arrays, maps, and class instances return `false`.


#### Arguments
value (*): The value to check.


#### Returns
(Boolean): Returns `true` if `value` is a plain object, else `false`.


#### Example

```autohotkey
_.isPlainObject({a: 1})
; => true

_.isPlainObject([1])
; => false

```



## .isRegExp
Checks if `value` is a RegExp object. AHK has no RegExp object (patterns are strings), so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isRegExp("abc")
; => false

```



## .isSafeInteger
Checks if `value` is a safe integer: an integer (or whole-number float) whose absolute value is at most `9007199254740991`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `true` if value is a safe integer, else `false`.


#### Example

```autohotkey
_.isSafeInteger(3)
; => true

_.isSafeInteger(3.5)
; => false

```



## .isSet
Checks if `value` is a Set object. AHK has no Set type, so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isSet(map())
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



## .isSymbol
Checks if `value` is a Symbol. AHK has no Symbol type, so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isSymbol("abc")
; => false

```



## .isTypedArray
Checks if `value` is a typed array. AHK has no typed arrays, so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isTypedArray(buffer(8))
; => false

```



## .isUndefined
Checks if value is undefined or blank.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns true if value is undefined, else false.


#### Example

```autohotkey
_.isUndefined(non_existant_var)
; => true

_.isUndefined("")
; => false

_.isUndefined({})
; => false

_.isUndefined(" ")
; => false

_.isUndefined(0)
; => false

_.isUndefined(false)
; => false

```



## .isWeakMap
Checks if `value` is a WeakMap object. AHK has no WeakMap type, so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isWeakMap(map())
; => false

```



## .isWeakSet
Checks if `value` is a WeakSet object. AHK has no WeakSet type, so this always returns `false`.


#### Arguments
value (*): The value to check.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.isWeakSet([1])
; => false

```



## .lt
Checks if `value` is less than `other`.


#### Arguments
value (*): The value to compare.

other (*): The other value to compare.


#### Returns
(boolean): Returns `true` if value is less than other, else `false`.


#### Example

```autohotkey
_.lt(1, 3)
; => true

_.lt(3, 1)
; => false

```



## .lte
Checks if `value` is less than or equal to `other`.


#### Arguments
value (*): The value to compare.

other (*): The other value to compare.


#### Returns
(boolean): Returns `true` if value is less than or equal to other, else `false`.


#### Example

```autohotkey
_.lte(3, 3)
; => true

_.lte(4, 3)
; => false

```



## .toArray
Converts `value` to an array. Arrays are shallow copied, strings are split into characters, objects return their values, and maps return `[key, value]` pairs. Unset and other primitive values return an empty array.


#### Arguments
value (*): The value to convert.


#### Returns
(Array): Returns the new array.


#### Example

```autohotkey
_.toArray([1, 2])
; => [1, 2]

_.toArray("ab")
; => ["a", "b"]

_.toArray({a: 1, b: 2})
; => [1, 2]

```



## .toFinite
Converts `value` to a finite number. Values that cannot be converted return `0`.


#### Arguments
value (*): The value to convert.


#### Returns
(number): Returns the converted number.


#### Example

```autohotkey
_.toFinite(3.2)
; => 3.2

_.toFinite("3")
; => 3

```



## .toInteger
Converts `value` to an integer by truncating toward zero. Values that cannot be converted return `0`.


#### Arguments
value (*): The value to convert.


#### Returns
(Integer): Returns the converted integer.


#### Example

```autohotkey
_.toInteger("3.7")
; => 3

```



## .toLength
Converts `value` to an integer suitable for use as an array-like length, clamped to `0` through `9007199254740991`.


#### Arguments
value (*): The value to convert.


#### Returns
(Integer): Returns the converted length.


#### Example

```autohotkey
_.toLength(3.7)
; => 3

_.toLength(-5)
; => 0

```



## .toNumber
Converts `value` to a number. Empty strings return `0`. Values that cannot be converted return an empty string, since AutoHotkey has no `NaN` for this case.


#### Arguments
value (*): The value to convert.


#### Returns
(Number|string): Returns the converted number, or an empty string if conversion is not possible.


#### Example

```autohotkey
_.toNumber("3.5")
; => 3.5

_.toNumber(true)
; => 1

_.toNumber("")
; => 0

```



## .toPlainObject
Converts `value` to a plain object by copying its properties (or Map entries) into a new object. Non-object values are returned as is.


#### Arguments
value (*): The value to convert.


#### Returns
(Object): Returns the plain object.


#### Example

```autohotkey
_.toPlainObject(map("a", 1, "b", 2))
; => {a: 1, b: 2}

```



## .toSafeInteger
Converts `value` to a safe integer by truncating toward zero and clamping to `-9007199254740991` through `9007199254740991`. Values that cannot be converted return `0`.


#### Arguments
value (*): The value to convert.


#### Returns
(Integer): Returns the converted safe integer.


#### Example

```autohotkey
_.toSafeInteger(3.7)
; => 3

_.toSafeInteger(-3.7)
; => -3

```



## .toString
Converts value to a string. An empty string is returned for undefined values. The sign of `-0` is preserved.


#### Arguments
value (*): The value to convert.


#### Returns
(boolean): Returns the converted string.


#### Example

```autohotkey
```



## .typeOf
This method returns a string indicating the type of `value`.


#### Arguments
value (*): the value to check.


#### Returns
(string): Returns value's type.


#### Example

```autohotkey
_.typeOf(42)
; => "integer"

_.typeOf(0.25)
; => "float"

_.typeOf("0.25")
; => "string"

_.typeOf("blubber")
; => "string"

_.typeOf([])
; => "array"

_.typeOf({})
; => "object"

_.typeOf(map())
; => "map"

_.typeOf(object)
; => "class"

_.typeOf(_)
; => "class"

```




# **Math methods**
## .add
Adds two numbers.


#### Arguments
augend (number): The first number in an addition.

addend (number): The second number in an addition.


#### Returns
(number): Returns the total.


#### Example

```autohotkey
_.add(6, 4)
; => 10

```



## .ceil
Computes `number` rounded up to `precision`.


#### Arguments
number (number): The number to round up.

[precision:=0] (number): The precision to round up to.


#### Returns
(number): Returns the rounded up number.


#### Example

```autohotkey
_.ceil(4.006)
; => 5

_.ceil(6.004, 2)
; => 6.01

_.ceil(6040, -2)
; => 6100

```



## .divide
Divide two numbers.


#### Arguments
dividend (number): The first number in a division.

divisor (number): The second number in a division.


#### Returns
(number): Returns the quotient.


#### Example

```autohotkey
_.divide(6, 4)
; => 1.5

```



## .floor
Computes `number` rounded down to `precision`.


#### Arguments
number (number): The number to round down.

[precision:=0] (number): The precision to round down to.


#### Returns
(number): Returns the rounded down number.

#### Example

```autohotkey
_.floor(4.006)
; => 4

_.floor(0.046, 2)
; => 0.04

_.floor(4060, -2)
; => 4000

```



## .max
Computes the maximum value of `array`. If `array` is empty or falsey, `""` is returned.


#### Arguments
array (Array): The array to iterate over.


#### Returns
(*): Returns the maximum value.


#### Example

```autohotkey
_.max([4, 2, 8, 6])
; => 8

_.max([])
; => ""

```



## .maxBy
This method is like [_.max](/?id=max) except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which the value is ranked. The iteratee is invoked with one argument: (value).

#### Arguments
array (Array): The array to iterate over.

[iteratee:=.identity] (Function): The iteratee invoked per element.


#### Returns
(*): Returns the maximum value.

#### Example

```autohotkey
objects := [ {n: 4 }, { n: 2 }, { n: 8 }, { n: 6 } ]
_.maxBy(objects, fn_maxByFunc)
; => {n: 8}

fn_maxByFunc(o)
	return o.n
; The _.property iteratee shorthand
_.maxBy(objects, "n")
; => {n: 8}

```



## .mean
Computes the mean of the values in `array`.


#### Arguments
array (Array): The array to iterate over.


#### Returns
(number): Returns the mean.


#### Example

```autohotkey
_.mean([4, 2, 8, 6])
; => 5

```



## .meanBy
This method is like [_.mean](/?id=mean) except that it accepts `iteratee` which is invoked for each element in `array` to generate the value to be averaged. The iteratee is invoked with one argument: (value).

#### Arguments
array (Array): The array to iterate over.

[iteratee:=.identity] (Function): The iteratee invoked per element.


#### Returns
(number): Returns the mean.

#### Example

```autohotkey
objects := [{n: 4}, {n: 2}, {n: 8}, {n: 6}]
_.meanBy(objects, fn_meanByFunc)
; => 5

fn_meanByFunc(o)
	return o.n
; The _.property iteratee shorthand.
_.meanBy(objects, "n")
; => 5

```



## .min
Computes the minimum value of `array`. If array is empty or falsey, `""` is returned.


#### Arguments
array (Array): The array to iterate over.


#### Returns
(*): Returns the minimum value.


#### Example

```autohotkey
_.min([4, 2, 8, 6])
; => 2

_.min([])
; => ""

```



## .minBy
This method is like [_.min](/?id=min) except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which the value is ranked. The iteratee is invoked with one argument: (value).

#### Arguments
array (Array): The array to iterate over.

[iteratee:=.identity] (Function): The iteratee invoked per element.


#### Returns
(*): Returns the minimum value.

#### Example

```autohotkey
objects := [ {n: 4 }, { n: 2 }, { n: 8 }, { n: 6 } ]
_.minBy(objects, fn_minByFunc)
; => {n: 2}

fn_minByFunc(o)
	return o.n
; The _.property iteratee shorthand
_.minBy(objects, "n")
; => {n: 2}

```



## .multiply
Multiply two numbers.


#### Arguments
multiplier (number): The first number in a multiplication.

multiplicand (number): The second number in a multiplication.


#### Returns
(number): Returns the product.


#### Example

```autohotkey
_.multiply(6, 4)
; => 24

```



## .round
Computes `number` rounded to `precision`.


#### Arguments
number (number): The number to round.

[precision:=0] (number): The precision to round to.


#### Returns
(number): Returns the rounded number.


#### Example

```autohotkey
_.round(4.006)
; => 4

_.round(4.006, 2)
; => 4.01

_.round(4060, -2)
; => 4100

```



## .subtract
Subtract two numbers.


#### Arguments
minuend (number): The first number in a subtraction.

subtrahend (number): The second number in a subtraction.


#### Returns
(number): Returns the difference.


#### Example

```autohotkey
_.subtract(6, 4)
; => 2

```



## .sum
Computes the sum of the values in `array`.


#### Arguments
array (Array): The array to iterate over.


#### Returns
(number): Returns the sum.


#### Example

```autohotkey
_.sum([4, 2, 8, 6])
; => 20

```



## .sumBy
This method is like [_.sum](/?id=sum) except that it accepts `iteratee` which is invoked for each element in `array` to generate the value to be summed. The iteratee is invoked with one argument: (value).


#### Arguments
array (Array): The array to iterate over.
[iteratee:=.identity] (Function): The iteratee invoked per element.


#### Returns
(number): Returns the sum.


#### Example

```autohotkey
objects := [{n: 4}, {n: 2}, {n: 8}, {n: 6}]
_.sumBy(objects, fn_sumByFunc)
; => 20

fn_sumByFunc(o)
	return o.n
; The _.property iteratee shorthand
_.sumBy(objects, "n")
; => 20

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



## .inRange
Checks if `n` is between `start` and up to, but not including, `end`. If end is not specified, it's set to start with start then set to 0. If start is greater than end the params are swapped to support negative ranges.


#### Arguments
number (number): The number to check.

start (number): The start of the range.

end (number): The end of the range.


#### Returns
(boolean): Returns true if number is in the range, else false.


#### Example

```autohotkey
_.inRange(3, 2, 4)
; => true

_.inRange(4, 8)
; => true

_.inRange(4, 2)
; => false

_.inRange(2, 2)
; => false

_.inRange(1.2, 2)
; => true

_.inRange(5.2, 4)
; => false

_.inRange(-3, -2, -6)
; => true

```



## .random
Produces a random number between the inclusive lower and upper bounds. If floating is true, or either lower or upper are floats, a floating-point number is returned instead of an integer. Uses AutoHotkey's pseudo-random [Random](https://www.autohotkey.com/docs/v2/lib/Random.htm) command.


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

_.map(_.random([10, 10, 10]))
; => an array of random numbers between 0 and 10
```




# **Object methods**
## .assign
Assigns own enumerable properties of source objects to the destination object. Later sources overwrite earlier ones.


#### Arguments
object (Object): The destination object.

[sources] (...Object): The source objects.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
obj := {a: 1}
_.assign(obj, {b: 2}, {a: 3})
; => {a: 3, b: 2}

```



## .assignIn
Like `.assign`, but also copies inherited properties of the source objects.


#### Arguments
object (Object): The destination object.

[sources] (...Object): The source objects.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
_.assignIn({}, {a: 1}, {b: 2})
; => {a: 1, b: 2}

```



## .assignInWith
Assigns the enumerable properties of each source to `object`, using `customizer` to produce each value. The customizer receives the current value of the property, the source value, the key, the object, and the source. If the customizer returns an empty string, the source value is assigned.


#### Arguments
object (Object): The destination object.

[sources*] (Object): The source objects.

[customizer] (Function): The function that produces each assigned value. It is the last argument.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
fn_assignInWithKeep(objValue, srcValue) {
	if (type(objValue) == "String" && objValue == "") {
		return srcValue
	}
	return objValue
assignInWithTarget := {a: 1}
_.assignInWith(assignInWithTarget, {a: 5, b: 2}, fn_assignInWithKeep)
; => {a: 1, b: 2}

```



## .assignWith
Assigns the own properties of each source to `object`, using `customizer` to produce each value. The customizer receives the current value of the property, the source value, the key, the object, and the source. If the customizer returns an empty string, the source value is assigned.


#### Arguments
object (Object): The destination object.

[sources*] (Object): The source objects.

[customizer] (Function): The function that produces each assigned value. It is the last argument.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
fn_assignWithKeep(objValue, srcValue) {
	if (type(objValue) == "String" && objValue == "") {
		return srcValue
	}
	return objValue
assignWithTarget := {a: 1}
_.assignWith(assignWithTarget, {a: 5, b: 2}, fn_assignWithKeep)
; => {a: 1, b: 2}

```



## .at
Creates an array of values at each path of `object`. Missing paths give an empty string.


#### Arguments
object (Object): The object to iterate over.

[paths] (...string): The property paths to pick, either as separate arguments or as one array.


#### Returns
(Array): Returns the picked values.


#### Example

```autohotkey
_.at({a: {b: 1}, c: 2}, "a.b", "c")
; => [1, 2]

```



## .create
Creates a new object that inherits from `prototype`, optionally assigning `properties` to it.


#### Arguments
[prototype] (Object): The object to inherit from.

[properties] (Object): The properties to assign to the new object.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
proto := {greet: "hi"}
created := _.create(proto, {name: "neo"})
created.name
; => "neo"

```



## .defaults
Assigns source properties to the destination object for every property that the destination does not already have.


#### Arguments
object (Object): The destination object.

[sources] (...Object): The source objects.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
_.defaults({a: 1}, {a: 2, b: 2})
; => {a: 1, b: 2}

```



## .defaultsDeep
Like `.defaults`, but recursively fills in nested plain objects instead of only top-level properties.


#### Arguments
object (Object): The destination object.

[sources] (...Object): The source objects.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
_.defaultsDeep({a: {b: 1}}, {a: {b: 2, c: 3}})
; => {a: {b: 1, c: 3}}

```



## .entriesIn
Alias of `.toPairsIn`. Creates an array of `[key, value]` pairs for the own and inherited properties of `object`.


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the key-value pairs.


#### Example

```autohotkey
_.entriesIn({a: 1})
; => [["a", 1]]

```



## .extend
Alias of `.assignIn`. Copies own and inherited properties of the source objects onto the destination object.


#### Arguments
object (Object): The destination object.

[sources] (...Object): The source objects.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
_.extend({}, {a: 1}, {b: 2})
; => {a: 1, b: 2}

```



## .findKey
Returns the key of the first property of `object` for which `predicate` returns truthy.


#### Arguments
object (Object): The object to search.

[predicate] (Function|string|Object): The function invoked per property, or a shorthand.


#### Returns
(*): Returns the key of the matched property, or an empty string if none matched.


#### Example

```autohotkey
users := {cypher: {age: 36, active: true}, tank: {age: 40, active: false}, trinity: {age: 1, active: true}}
_.findKey(users, (o) => o.age < 2)
; => "trinity"

```



## .findLastKey
Like `.findKey`, but walks the properties from last to first and returns the key of the last match.


#### Arguments
object (Object): The object to search.

[predicate] (Function|string|Object): The function invoked per property, or a shorthand.


#### Returns
(*): Returns the key of the matched property, or an empty string if none matched.


#### Example

```autohotkey
users := {cypher: {age: 36, active: true}, tank: {age: 40, active: false}, trinity: {age: 1, active: true}}
_.findLastKey(users, (o) => o.active)
; => "trinity"

```



## .forIn
Iterates over the own and inherited properties of `object`, invoking `iteratee` with each value, key and the object. Returning `false` exits early.


#### Arguments
object (Object): The object to iterate over.

[iteratee] (Function): The function invoked per property.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
output := []
_.forIn({a: 1, b: 2}, (value, key) => output.push(key))
output
; => ["a", "b"]

```



## .forInRight
Like `.forIn`, but iterates from the last property to the first. Returning `false` exits early.


#### Arguments
object (Object): The object to iterate over.

[iteratee] (Function): The function invoked per property.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
output := []
_.forInRight({a: 1, b: 2}, (value, key) => output.push(key))
output
; => ["b", "a"]

```



## .forOwn
Iterates over the own properties of `object`, invoking `iteratee` with each value, key and the object. Returning `false` exits early.


#### Arguments
object (Object): The object to iterate over.

[iteratee] (Function): The function invoked per property.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
output := []
_.forOwn({a: 1, b: 2}, (value, key) => output.push(key))
output
; => ["a", "b"]

```



## .forOwnRight
Like `.forOwn`, but iterates from the last property to the first. Returning `false` exits early.


#### Arguments
object (Object): The object to iterate over.

[iteratee] (Function): The function invoked per property.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
output := []
_.forOwnRight({a: 1, b: 2}, (value, key) => output.push(key))
output
; => ["b", "a"]

```



## .functions
Creates an array of the own property names of `object` whose values are functions.


#### Arguments
object (Object): The object to inspect.


#### Returns
(Array): Returns the function property names.


#### Example

```autohotkey
_.functions({a: 1, f: strLen})
; => ["f"]

```



## .functionsIn
Creates an array of the own and inherited property names of `object` whose values are functions.


#### Arguments
object (Object): The object to inspect.


#### Returns
(Array): Returns the function property names.


#### Example

```autohotkey
_.functionsIn({a: 1, f: strLen})
; => ["f"]

```



## .get
Gets the value at `path` of `object`. If the resolved value is `unset`, the `defaultValue` is returned in its place.


#### Arguments
object (Object): The object to query.

path (Array|string): The path of the property to get.

[defaultValue] (*): The value returned for undefined resolved values.


#### Returns
(*): Returns the resolved value.


#### Example

```autohotkey
obj := {a: [{b: {c: 3}}]}
_.get(obj, "a[1].b.c")
; => 3

_.get(obj, ["a", "1", "b", "c"])
; => 3

_.get(obj, "a.b.c", "default")
; => "default"

```



## .has
Checks if `path` is a property path of `object`.


#### Arguments
object (Object): The object to query.

path (string|Array): The path to check.


#### Returns
(boolean): Returns `true` if the path exists, else `false`.


#### Example

```autohotkey
_.has({a: {b: 1}}, "a.b")
; => true

_.has({a: 1}, "b")
; => false

```



## .hasIn
Checks if `path` is a property path of `object`, including inherited properties. Matches `.has` for plain objects.


#### Arguments
object (Object): The object to query.

path (string|Array): The path to check.


#### Returns
(boolean): Returns `true` if the path exists, else `false`.


#### Example

```autohotkey
_.hasIn({a: {b: 1}}, "a.b")
; => true

```



## .invert
Creates an object composed of the inverted keys and values of `object`. Values are converted to strings to become keys.


#### Arguments
object (Object): The object to invert.


#### Returns
(Object): Returns the inverted object.


#### Example

```autohotkey
_.invert({a: "x", b: "y"})
; => {x: "a", y: "b"}

```



## .invertBy
Like `.invert`, but each inverted key holds an array of the original keys. The `iteratee` computes the new key for each value.


#### Arguments
object (Object): The object to invert.

[iteratee] (Function|string): The function invoked per value to produce the new key. Defaults to the value itself.


#### Returns
(Object): Returns the grouped object.


#### Example

```autohotkey
_.invertBy({a: "x", b: "y", c: "x"})
; => {x: ["a", "c"], y: ["b"]}

```



## .invoke
Invokes the method at `path` of `object` with the given arguments. The method receives its owning object as its first argument.


#### Arguments
object (Object): The object to query.

path (string|Array): The path of the method.

[args] (...*): The arguments to pass to the method, after the owning object.


#### Returns
(*): Returns the result of the method.


#### Example

```autohotkey
fn_invokeAdd(param_self, param_x) {
	return param_self.n + param_x
invokeObj := {n: 5, add: fn_invokeAdd}
_.invoke(invokeObj, "add", 2)
; => 7

```



## .keys
Creates an array of the own property names of `object`. Array indexes are returned as integers.


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the property names.


#### Example

```autohotkey
_.keys({a: 1, b: 2})
; => ["a", "b"]

```



## .keysIn
Creates an array of the own and inherited property names of `object`.


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the property names.


#### Example

```autohotkey
_.keysIn({a: 1})
; => ["a"]

```



## .mapKeys
Creates an object with the same values as `object`, with each key produced by `iteratee`.


#### Arguments
object (Object): The object to iterate over.

[iteratee] (Function|string): The function invoked per property with the value, key and object. Defaults to the value.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.mapKeys({a: 1, b: 2}, (value, key) => "x" key)
; => {xa: 1, xb: 2}

```



## .mapValues
Creates an object with the same keys as `object`, with each value produced by `iteratee`.


#### Arguments
object (Object): The object to iterate over.

[iteratee] (Function|string): The function invoked per property with the value, key and object. Defaults to the value.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.mapValues({a: 1, b: 2}, (v) => v * 2)
; => {a: 2, b: 4}

```



## .merge
Recursively merges the own properties of each source into `object`. Objects and arrays are merged recursively, and other values are assigned. Later sources override earlier ones.


#### Arguments
object (Object): The destination object.

[sources*] (Object): The source objects.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
_.merge({a: {x: 1}}, {a: {y: 2}})
; => {a: {x: 1, y: 2}}

```



## .mergeWith
Recursively merges the own properties of each source into `object`. Objects and arrays are merged recursively, and other values are assigned. `customizer` is called for each property first. If it returns an empty string, the default merge is used.


#### Arguments
object (Object): The destination object.

[sources*] (Object): The source objects.

[customizer] (Function): The function that produces each merged value. It receives the current value, the source value, the key, the object, and the source. It is the last argument.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
fn_mergeWithConcat(objValue, srcValue) {
	if (type(objValue) == "Array") {
		combined := []
		for value in objValue {
			combined.push(value)
		}
		for value in srcValue {
			combined.push(value)
		}
		return combined
	}
_.mergeWith({a: {x: 1}}, {a: {y: 2}})
; => {a: {x: 1, y: 2}}

_.mergeWith({a: [1], b: [2]}, {a: [3], b: [4]}, fn_mergeWithConcat)
; => {a: [1, 3], b: [2, 4]}

```



## .omit
Creates a copy of `object` without the properties at the given paths.


#### Arguments
object (Object): The object to omit from.

[paths] (...string): The property paths to omit, either as separate arguments or as one array.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.omit({a: 1, b: 2, c: 3}, "a", "c")
; => {b: 2}

```



## .omitBy
Creates an object of the properties of `object` that `predicate` does not match. This is the inverse of `.pickBy`.


#### Arguments
object (Object): The object to iterate over.

[predicate] (Function|string): The function invoked per property with the value, key and object. Defaults to the value.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.omitBy({a: 1, b: 2, c: 3}, (v) => v >= 2)
; => {a: 1}

```



## .pick
Creates an object composed of the picked properties of `object`. Paths that do not exist are skipped.


#### Arguments
object (Object): The source object.

[paths] (...string): The property paths to pick, either as separate arguments or as one array.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
_.pick({a: 1, b: 2, c: 3}, "a", "c")
; => {a: 1, c: 3}

```



## .pickBy
Creates an object composed of the own properties of `object` that `predicate` returns truthy for. The predicate is invoked with each property's value and key.


#### Arguments
object (Object): The source object.

[predicate=_.identity] (Function|string|Array|Object): The function invoked per property. Defaults to returning the value itself. Shorthands for `.property`, `.matchesProperty`, and `.matches` are supported.


#### Returns
(Object): Returns the new object.


#### Example

```autohotkey
pickObj := {a: 1, b: 2, c: 3}
_.pickBy(pickObj, fn_pickByFunc)
; => {b: 2, c: 3}

fn_pickByFunc(value, key) {
	return value >= 2
```



## .propertyOf
The opposite of `.property`; creates a function that returns the value at a given path of `object`.


#### Arguments
object (Object): The object to query.


#### Returns
(Function): Returns the new accessor function, which takes a path.


#### Example

```autohotkey
propFn := _.propertyOf({a: {b: 2}})
propFn.call("a.b")
; => 2

```



## .result
Resolves the value at `path` of `object`. If the value is a function, it is invoked with `object` as `this` and its result is returned.


#### Arguments
object (Object): The object to query.

path (string|Array): The path of the value to resolve.

[defaultValue:=""] (*): The value returned when the path does not exist.


#### Returns
(*): Returns the resolved value.


#### Example

```autohotkey
fn_resultGetNext(param_self) {
	return param_self.n + 1
resultObj := {n: 1, next: fn_resultGetNext}
_.result(resultObj, "next")
; => 2

```



## .set
Sets the value at `path` of `object`. If a portion of `path` doesn't exist, it's created. Objects are created for all missing properties.

> [!Note]
> This method mutates `object`.

#### Arguments
object (Object): The object to modify.

path (Array|string): The path of the property to set.

value (*): The value to set.

#### Returns
(Object): Returns object.


#### Example

```autohotkey
obj := {a: [{b: {c: 3}}]}
_.set(obj, "a[1].b.c", 4)
obj.a[1].b.c
; => 4

_.set(obj, ["x", "1", "y", "z"], 5)
obj.x[1].y.z
; => 5

```



## .setWith
Sets the value at `path` of `object`. Like `set`, missing intermediate objects are created. `customizer` is called for each intermediate level with the existing value, the key, and the parent object. If it returns an empty string, the existing object is kept, or a new one is created.


#### Arguments
object (Object): The object to modify.

path (Array|string): The path of the property to set.

value (*): The value to set.

[customizer] (Function): The function that produces each intermediate value. It receives the existing value (empty string when missing), the key, and the parent object.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
setWithObj := {}
_.setWith(setWithObj, "a.b.c", 1, (*) => Object())
_.get(setWithObj, "a.b.c")
; => 1

```



## .toPairs
Creates an array of `[key, value]` pairs for the own properties of `object`.


#### Aliases
`.entries`


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the key-value pairs.


#### Example

```autohotkey
_.toPairs({a: 1, b: 2})
; => [["a", 1], ["b", 2]]

```



## .toPairsIn
Creates an array of `[key, value]` pairs for the own and inherited properties of `object`.


#### Aliases
`.entriesIn`


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the key-value pairs.


#### Example

```autohotkey
_.toPairsIn({a: 1})
; => [["a", 1]]

```



## .transform
Transforms `object` by invoking `iteratee` for each property with an accumulator, which the iteratee mutates. The accumulator is returned.


#### Arguments
object (Object|Array): The object to iterate over.

[iteratee:=identity] (Function): The function invoked per property with the accumulator, value, key and object.

[accumulator] (*): The initial accumulator. Defaults to a new array for arrays and a new object otherwise.


#### Returns
(*): Returns the accumulated value.


#### Example

```autohotkey
fn_transformDouble(param_accumulator, param_value, param_key) {
	param_accumulator.%param_key% := param_value * 2
_.transform({a: 1, b: 2}, fn_transformDouble)
; => {a: 2, b: 4}

```



## .unset
Removes the property at `path` of `object`. Removing an array element shifts the later elements down.


#### Arguments
object (Object): The object to modify.

path (string|Array): The path of the property to remove.


#### Returns
(boolean): Returns `true` if the property was removed, else `false`.


#### Example

```autohotkey
unsetObj := {a: 1, b: 2}
_.unset(unsetObj, "a")
; => true

unsetObj
; => {b: 2}

```



## .update
Updates the value at `path` of `object` with the result of `updater`, which receives the current value. Missing intermediate objects are created.


#### Arguments
object (Object): The object to modify.

path (string|Array): The path of the value to update.

updater (Function): The function that receives the current value and returns the new value.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
updateObj := {a: {b: 1}}
_.update(updateObj, "a.b", (v) => v + 1)
updateObj.a.b
; => 2

```



## .updateWith
Updates the value at `path` of `object`. The current value is passed to `updater`, and its result is set at `path`. `customizer` is used when creating intermediate values, as with `setWith`.


#### Arguments
object (Object): The object to modify.

path (Array|string): The path of the property to update.

updater (Function): The function that receives the current value and returns the new value.

[customizer] (Function): The function that produces each intermediate value, as with `setWith`.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
updateObj := {a: {b: 1}}
_.updateWith(updateObj, "a.b", (v) => v + 1)
updateObj.a.b
; => 2

```



## .values
Creates an array of the own property values of `object`.


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the property values.


#### Example

```autohotkey
_.values({a: 1, b: 2})
; => [1, 2]

```



## .valuesIn
Creates an array of the own and inherited property values of `object`.


#### Arguments
object (Object): The object to query.


#### Returns
(Array): Returns the property values.


#### Example

```autohotkey
_.valuesIn({a: 1})
; => [1]

```




# **Seq methods**
## .chain
Creates a `chain` wrapper around `value`. Library methods called on the wrapper receive the wrapped value as their first argument, and each result is wrapped again so calls can be sequenced. Call `.value()` to unwrap the final result.

Unlike lodash, chained calls run eagerly, one at a time, rather than being deferred until `.value()`.


#### Arguments
value (*): The value to wrap.


#### Returns
(ChainWrapper): Returns the wrapper. Use `.value()` to get the result.


#### Example
```autohotkey
_.chain([1, 2, 3]).map((v) => v * 2).value()
; => [2, 4, 6]
```




## .tap
Invokes `interceptor` with `value` and returns `value`. Useful for performing an action in the middle of a chain of methods.


#### Arguments
value (*): The value to provide to `interceptor`.

interceptor (Function|Object|Array|string): The function to invoke. The interceptor is invoked with one argument: (value).


#### Returns
(*): Returns `value`.


#### Example
```autohotkey
_.tap([1, 2, 3], (v) => v.push(4))
; => [1, 2, 3, 4]
```




## .thru
This method is like [_.tap](/?id=tap) except that it returns the result of `interceptor`. The interceptor is invoked with one argument: (value).


#### Arguments
value (*): The value to provide to `interceptor`.

interceptor (Function|Object|Array|string): The function to invoke.


#### Returns
(*): Returns the result of `interceptor`.


#### Example

```autohotkey
_.thru(5, (v) => v * 2)
; => 10

_.thru([1, 2], (a) => a.length)
; => 2

```




# **String methods**
## .camelCase
Converts string to camel case.

#### Arguments
[string:=""] (string): The string to convert.

#### Returns
(string): Returns the camel cased string.


#### Example

```autohotkey
_.camelCase("--foo-bar--")
; => "fooBar"

_.camelCase("fooBar")
; => "fooBar"

_.camelCase("__FOO_BAR__")
; => "fooBar"

```



## .capitalize
Converts the first character of `string` to upper case and the remaining characters to lower case.


#### Arguments
[string:=""] (string): The string to capitalize.


#### Returns
(string): Returns the capitalized string.


#### Example

```autohotkey
_.capitalize("TANK")
; => "Tank"

_.capitalize("fooBar")
; => "Foobar"

_.capitalize("")
; => ""

```



## .deburr
Converts Latin-1 Supplement letters in `string` to basic Latin letters, for example `é` becomes `e` and `ß` becomes `ss`. Characters outside that range are left unchanged.


#### Arguments
[string:=""] (string): The string to deburr.


#### Returns
(string): Returns the deburred string.




## .endsWith
Checks if `string` ends with the given target string.


#### Arguments
[string:=""] (string): The string to inspect.

[target] (string): The string to search for.

[position:=strLen()] (number): The position to search up to.


#### Returns
(boolean): Returns true if string ends with target, else false.


#### Example

```autohotkey
_.endsWith("abc", "c")
; => true

_.endsWith("abc", "b")
; => false

_.endsWith("abc", "b", 2)
; => true

```



## .escape
Converts the characters "&", "<", ">", '"', and "'" in `string` to their corresponding HTML entities.

> [!Note]
> No other characters are escaped. To escape additional characters use a third-party library.

Though the ">" character is escaped for symmetry, characters like ">" and "/" don't need escaping in HTML and have no special meaning unless they're part of a tag or unquoted attribute value. See Mathias [Bynens's article](https://mathiasbynens.be/notes/ambiguous-ampersands) (under "semi-related fun fact") for more details.

When working with HTML you should always quote attribute values to reduce XSS vectors.


#### Arguments
[string:=""] (string): The string to escape.


#### Returns
(string): Returns the escaped string.


#### Example

```autohotkey
str := "neo, morpheus, & trinity"
_.escape(str)
; => "neo, morpheus, &amp; trinity"

```



## .escapeRegExp
Escapes the `RegExp` special characters `^`, `$`, `\`, `.`, `*`, `+`, `?`, `(`, `)`, `[`, `]`, `{`, `}`, and `|` in `string`, so the string can be used as a literal pattern.


#### Arguments
[string:=""] (string): The string to escape.


#### Returns
(string): Returns the escaped string.


#### Example
```autohotkey
_.escapeRegExp("a.b*c")
; => "a\.b\*c"
```




## .kebabCase
Converts `string` to kebab case.


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the kebab cased string.


#### Example

```autohotkey
_.kebabCase("Foo Bar")
; => "foo-bar"

_.kebabCase("fooBar")
; => "foo-bar"

_.kebabCase("--FOO_BAR--")
; => "foo-bar"

```



## .lowerCase
Converts `string`, as space separated words, to lower case.


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the lower cased string.


#### Example

```autohotkey
_.lowerCase("--Foo-Bar--")
; => "foo bar"

_.lowerCase("fooBar")
; => "foo bar"

_.lowerCase("__FOO_BAR__")
; => "foo bar"

```



## .lowerFirst
Converts the first character of `string` to lower case.


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the converted string.


#### Example

```autohotkey
_.lowerFirst("Neo")
; => "neo"

_.lowerFirst("TANK")
; => "tANK"

```



## .pad
Pads `string` on the left and right sides if it's shorter than `length`. Padding characters are truncated if they can't be evenly divided by length.

#### Arguments
[string:=""] (string): The string to pad.

[length:=0] (number): The padding length.

[chars:=" "] (string): The string used as padding.


#### Returns
(string): Returns the padded string.


#### Example

```autohotkey
_.pad("abc", 8)
; => "  abc   "

_.pad("abc", 8, "_-")
; => "_-abc_-_"

_.pad("abc", 3)
; => "abc"

```



## .padEnd
Pads `string` on the right side if it's shorter than `length`. Padding characters are truncated if they exceed length.

#### Arguments
[string:=""] (string): The string to pad.

[length:=0] (number): The padding length.

[chars:=" "] (string): The string used as padding.


#### Returns
(string): Returns the padded string.


#### Example

```autohotkey
_.padEnd("abc", 6)
; => "abc   "

_.padEnd("abc", 6, "_-")
; => "abc_-_"

```



## .padStart
Pads `string` on the left side if it's shorter than `length`. Padding characters are truncated if they exceed length.

#### Arguments
[string:=""] (string): The string to pad.

[length:=0] (number): The padding length.

[chars:=" "] (string): The string used as padding.


#### Returns
(string): Returns the padded string.


#### Example

```autohotkey
_.padStart("abc", 6)
; => "   abc"

_.padStart("abc", 6, "_-")
; => "_-_abc"

```



## .parseInt
Converts string to an integer of the specified radix. If radix is `""` undefined or `0`, a radix of `10` is used unless value is a hexadecimal, in which case a radix of `16` is used.

#### Arguments
string (string): The string to convert.

[radix:=10] (number): The radix to interpret value by.


#### Returns

(number): Returns the converted integer.


#### Example

```autohotkey
_.parseInt("08")
; => 8

_.map(["6", "08", "10"], _.parseInt)
; => [6, 8, 10]

```



## .repeat
Repeats the given string `n` times.


#### Arguments
[string:=""] (string): The string to repeat.

[n:=1] (number): The number of times to repeat the string.

#### Returns

(string): Returns the repeated string.


#### Example

```autohotkey
_.repeat("*", 3)
; => "***"

_.repeat("abc", 2)
; => "abcabc"

_.repeat("abc", 0)
; => ""

```



## .replace
Replaces the first match of `pattern` in `string` with `replacement`. A `pattern` wrapped in slashes (for example `"/\d+/"`) is treated as a regular expression, and its flags (`i`, `m`, `s`, `x`) are supported.

#### Arguments
string (string): The string to modify.

pattern (RegExp|string): The pattern to replace.

replacement (string): The match replacement.

#### Returns

(string): Returns the modified string.




## .snakeCase
Converts `string` to snake case.

#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the snake cased string.


#### Example

```autohotkey
_.snakeCase("Foo Bar")
; => "foo_bar"

_.snakeCase("fooBar")
; => "foo_bar"

_.snakeCase("--FOO-BAR--")
; => "foo_bar"

```



## .split
Splits `string` by `separator`.

> [!Note]
> This method is based on [`String#split`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/split).


#### Arguments
[string:=""] (string): The string to split.

separator (RegExp|string): The separator pattern to split by. Use `"/pattern/flags"` for a regular expression. An empty string splits into characters; omitting it returns the whole string as the only element.

[limit] (number): The length to truncate results to.

#### Returns
(Array): Returns the string segments.


#### Example

```autohotkey
_.split("a-b-c", "-", 2)
; => ["a", "b"]

_.split("a--b-c", "/-+/")
; => ["a", "b", "c"]

```



## .startCase
Converts `string` to start case.

#### Arguments
[string:=""] (string): The string to convert.

#### Returns
(string): Returns the start cased string.


#### Example

```autohotkey
_.startCase("--foo-bar--")
; => "Foo Bar"

_.startCase("fooBar")
; => "Foo Bar"

_.startCase("__FOO_BAR__")
; => "Foo Bar"

```



## .startsWith
Checks if `string` starts with the given target string.


#### Arguments
[string:=""] (string): The string to inspect.

[target] (string): The string to search for.

[position:=1] (number): The position to search from.


#### Returns
(boolean): Returns true if string starts with target, else false.


#### Example

```autohotkey
_.startsWith("abc", "a")
; => true

_.startsWith("abc", "b")
; => false

_.startsWith("abc", "b", 2)
; => true

_.stringCaseSense := true
_.startsWith("abc", "A")
; => false

```



## .template
Creates a function that inserts values into `string` and returns the result. The returned function takes an object of data. The placeholders are:

- `${ path }` and `<%= path %>` insert the value at `path`.
- `<%- path %>` inserts the value at `path` with `&`, `<`, `>`, `"`, and `'` escaped as HTML entities.

`path` may be a dotted path such as `user.name`. A path that does not exist inserts an empty string.

> [!Note]
> Unlike lodash, `template` does not evaluate arbitrary JavaScript (`<% %>` blocks) or custom delimiters.


#### Arguments
[string:=""] (string): The template string.


#### Returns
(Function): Returns the function that renders the template with the data it receives.


#### Example
```autohotkey
compiled := _.template("hello ${ user }!")
compiled({user: "neo"})
; => "hello neo!"
```




## .toLower
Converts `string`, as a whole, to lower case.


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the lower cased string.

#### Example

```autohotkey
_.toLower("--Foo-Bar--")
; => "--foo-bar--"

_.toLower("fooBar")
; => "foobar"

_.toLower("__FOO_BAR__")
; => "__foo_bar__"

```



## .toUpper
Converts `string`, as a whole, to upper case


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the upper cased string.

#### Example

```autohotkey
_.toUpper("--foo-bar--")
; => "--FOO-BAR--"

_.toUpper("fooBar")
; => "FOOBAR"

_.toUpper("__foo_bar__")
; => "__FOO_BAR__"

```



## .trim
Removes leading and trailing whitespace or specified characters from `string`.


#### Arguments
[string:=""] (string): The string to trim.

[chars:=whitespace] (string): The characters to trim.


#### Returns
(string): Returns the trimmed string.


#### Example

```autohotkey
_.trim("  abc  ")
; => "abc"

_.trim("-_-abc-_-", "_-")
; => "abc"

_.map([" foo  ", "  bar  "], _.trim)
; => ["foo", "bar"]

```



## .trimEnd
Removes trailing whitespace or specified characters from `string`.


#### Arguments
[string:=""] (string): The string to trim.

[chars:=whitespace] (string): The characters to trim.


#### Returns
(string): Returns the trimmed string.


#### Example

```autohotkey
_.trimEnd("  abc  ")
; => "  abc"

_.trimEnd("-_-abc-_-", "_-")
; => "-_-abc"

```



## .trimStart
Removes leading whitespace or specified characters from `string`.


#### Arguments
[string:=""] (string): The string to trim.

[chars:=whitespace] (string): The characters to trim.


#### Returns
(string): Returns the trimmed string.


#### Example

```autohotkey
_.trimStart("  abc  ")
; => "abc  "

_.trimStart("-_-abc-_-", "_-")
; => "abc-_-"

```



## .truncate
Truncates `string` if it's longer than the given maximum string length. The last characters of the truncated string are replaced with the omission string which defaults to "...".


#### Arguments
[string:=""] (string): The string to truncate.

[options:={}] (Object): The options object.

[options.length:=30] (number): The maximum string length.

[options.omission:="..."] (string): The string to indicate text is omitted.

[options.separator] (RegExp|string): The separator pattern to truncate to. A string is matched literally; use `"/pattern/flags"` for a regular expression.


#### Returns
(string): Returns the truncated string.


#### Example

```autohotkey
str := "free-your-mind Neo, the matrix has you"
_.truncate(str)
; => "free-your-mind Neo, the mat..."

_.truncate(str, {length: 24, separator: " "})
; => "free-your-mind Neo,..."

_.truncate(str, {length: 24, separator: "/,? +/"})
; => "free-your-mind Neo..."

```



## .unescape
The inverse of [_.escape](#escape) this method converts the HTML entities &amp;, &lt;, &gt;, &quot;, and &#39; in `string` to their corresponding characters.

> [!Note]
> No other HTML entities are unescaped. To unescape additional HTML entities use a dedicated third-party library.

#### Arguments
[string:=""] (string): The string to unescape.


#### Returns
(string): Returns the unescaped string.


#### Example

```autohotkey
str := "neo, morpheus, &amp; trinity"
_.unescape(str)
; => "neo, morpheus, & trinity"

```



## .upperCase
Converts `string`, as space separated words, to upper case.


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the upper cased string.


#### Example

```autohotkey
_.upperCase("--Foo-Bar--")
; => "FOO BAR"

_.upperCase("fooBar")
; => "FOO BAR"

_.upperCase("__FOO_BAR__")
; => "FOO BAR"

```



## .upperFirst
Converts the first character of `string` to upper case.


#### Arguments
[string:=""] (string): The string to convert.


#### Returns
(string): Returns the converted string.


#### Example

```autohotkey
_.upperFirst("neo")
; => "Neo"

_.upperFirst("TANK")
; => "TANK"

```



## .words
Splits `string` into an array of its words.


#### Arguments
[string:=""] (string): The string to inspect.

[pattern] (RegExp|string): The pattern to match words.


#### Returns

(Array): Returns the words of string.


#### Example

```autohotkey
_.words("neo, morpheus, & trinity")
; => ["neo", "morpheus", "trinity"]

_.words("neo, morpheus, & trinity", "[^, ]+")
; => ["neo", "morpheus", "&", "trinity"]

```




# **Util methods**
## .attempt
Attempts to invoke `func`, returning the result. If `func` throws, the error is returned instead.


#### Arguments
func (Function): The function to attempt.

[args] (...*): The arguments to invoke `func` with.


#### Returns
(*): Returns the result of `func`, or the caught error.


#### Example

```autohotkey
fn_attemptThrow() {
	throw Error("boom")
_.isError(_.attempt(fn_attemptThrow))
; => true

```



## .bindAll
Binds the named methods of `object` so they always run with `object` as `this`.


#### Arguments
object (Object): The object to bind methods on.

[methodNames] (...string): The names of the methods to bind, either as separate arguments or as one array.


#### Returns
(Object): Returns `object`.


#### Example

```autohotkey
fn_bindAllGet(param_self) {
	return param_self.n
bindObj := {n: 7, get: fn_bindAllGet}
_.bindAll(bindObj, "get")
bindObj.get()
; => 7

```



## .cond
Creates a function that iterates over `pairs`, invoking the function of the first pair whose predicate returns truthy for the arguments. Returns an empty string when no pair matches.


#### Arguments
pairs (Array): An array of `[predicate, func]` pairs.


#### Returns
(Function): Returns the new conditional function.


#### Example

```autohotkey
fn_condIsOne(param_value) {
	return param_value == 1
fn_condAlways(*) {
	return true
fn_condLabelOne(*) {
	return "one"
fn_condLabelOther(*) {
	return "other"
condFn := _.cond([[fn_condIsOne, fn_condLabelOne], [fn_condAlways, fn_condLabelOther]])
condFn.call(1)
; => "one"

```



## .conforms
Creates a function that invokes `.conformsTo` with a given `source` against the object it is called with.


#### Arguments
source (Object): The object of property predicates to conform to.


#### Returns
(Function): Returns the new conformance function.


#### Example

```autohotkey
fn_conformsUtilBig(param_n) {
	return param_n > 1
conformsFn := _.conforms({b: fn_conformsUtilBig})
conformsFn.call({b: 2})
; => true

```



## .constant
Creates a function that returns `value`.


#### Arguments
value (*): The value to return from the new function.


#### Returns
(Function): Returns the new constant function.


#### Example

```autohotkey
obj := _.times(2, _.constant({a: 1}))
; => [{a: 1}, {a: 1}]
```



## .defaultTo
Returns `defaultValue` if `value` is unset or `NaN`, otherwise returns `value`. AHK has no `null`, so unset stands in for `null` and `undefined`.


#### Arguments
value (*): The value to check.

defaultValue (*): The default value.


#### Returns
(*): Returns the resolved value.


#### Example

```autohotkey
_.defaultTo(unset, 1)
; => 1

_.defaultTo(2, 1)
; => 2

```



## .flow
Creates a function that invokes the given functions from left to right. The first function receives the arguments, and each later function receives the previous result.


#### Arguments
[funcs] (...Function): The functions to invoke, either as separate arguments or as one array.


#### Returns
(Function): Returns the new composed function.


#### Example

```autohotkey
fn_flowAddOne(param_value) {
	return param_value + 1
fn_flowDouble(param_value) {
	return param_value * 2
_.flow(fn_flowAddOne, fn_flowDouble).call(3)
; => 8

```



## .flowRight
Like `.flow`, but invokes the given functions from right to left.


#### Arguments
[funcs] (...Function): The functions to invoke, either as separate arguments or as one array.


#### Returns
(Function): Returns the new composed function.


#### Example

```autohotkey
fn_flowRightAddOne(param_value) {
	return param_value + 1
fn_flowRightDouble(param_value) {
	return param_value * 2
_.flowRight(fn_flowRightAddOne, fn_flowRightDouble).call(3)
; => 7

```



## .identity
This method returns the first argument it receives.

#### Arguments
value (*): Any value.


#### Returns
(*): Returns value.


#### Example

```autohotkey
obj := {a: 1}
_.identity(obj)
; => {a: 1}

(_.identity(obj) == obj)
; => true

```



## .iteratee
Creates a function that is used by the collection methods to invoke `func`. Without a `func`, the identity function is returned.


#### Arguments
[func] (Function): The function to convert to an iteratee.


#### Returns
(Function): Returns the new iteratee.


#### Example

```autohotkey
fnIteratee := _.iteratee((v) => v + 1)
fnIteratee.call(1)
; => 2

```



## .matches
Creates a function that performs a shallow comparison between a given object and source, returning `true` if the given object has equivalent property values, else `false`.


#### Arguments
source (Object): The object of property values to match.


#### Returns
(Function): Returns the new spec function.


#### Example

```autohotkey
objects := [{ a: 1, b: 2, c: 3 }, { a: 4, b: 5, c: 6 }]
_.filter(objects, _.matches({ a: 4, c: 6 }))
; => [{ a: 4, b: 5, c: 6 }]

functor := _.matches({ a: 4 })
_.filter(objects, functor)
; => [{ a: 4, b: 5, c: 6 }]

functor.call({ a: 1 })
; => false

```



## .matchesProperty
Creates a function that performs a partial deep comparison between the value at `path` of a given object to `srcValue`, returning true if the object value is equivalent, else false.


#### Arguments
path (Array|string): The path of the property to get.

srcValue (*): The value to match.


#### Returns
(Function): Returns the new spec function.


#### Example

```autohotkey
objects := [{ a: 1, b: 2, c: 3 }, { a: 4, b: 5, c: 6 }]
_.find(objects, _.matchesProperty("a", 4))
; => { a: 4, b: 5, c: 6 }

_.filter(objects, _.matchesProperty("a", 4))
; => [{ a: 4, b: 5, c: 6 }]

objects := [{ a: {b: 2} }, { a: {b: 1} }]
_.find(objects, _.matchesProperty(["a", "b"], 1))
; => { a: {b: 1} }

```



## .method
Creates a function that invokes the method at `path` of the object it is called with, using the given arguments.


#### Arguments
path (string|Array): The path of the method.

[args] (...*): The arguments to pass to the method.


#### Returns
(Function): Returns the new invoker function.


#### Example

```autohotkey
fn_methodAdd(param_self, param_x) {
	return param_self.n + param_x
methodObj := {n: 5, add: fn_methodAdd}
_.method("add", 2).call(methodObj)
; => 7

```



## .methodOf
The opposite of `.method`; creates a function that invokes the method at a given path of `object`, using the arguments it is called with.


#### Arguments
object (Object): The object to query.


#### Returns
(Function): Returns the new invoker function, which takes a path and arguments.


#### Example

```autohotkey
fn_methodOfAdd(param_self, param_x) {
	return param_self.n + param_x
methodOfObj := {n: 5, add: fn_methodOfAdd}
_.methodOf(methodOfObj).call("add", 2)
; => 7

```



## .mixin
Adds the function properties of `source` to `object`. When only `source` is given, the functions are added to this library.


#### Arguments
[object] (Object): The destination object. Defaults to this library when `source` is omitted.

source (Object): The object whose functions are added.


#### Returns
(Object): Returns the destination object.


#### Example

```autohotkey
fn_mixinTriple(param_value) {
	return param_value * 3
mixinTarget := {}
_.mixin(mixinTarget, {triple: fn_mixinTriple})
_.isFunction(mixinTarget.triple)
; => true

```



## .noConflict
Restores the previous `_` on conflict. AHK has no shared global to restore, so this returns the library itself.


#### Returns
(Object): Returns the library.


#### Example

```autohotkey
(_.noConflict() == _)
; => true

```



## .noop
A no-operation function that ignores its arguments and returns an empty string.


#### Returns
(string): Returns `""`.


#### Example

```autohotkey
_.noop(1, 2, 3)
; => ""

```



## .nthArg
Creates a function that returns its nth argument. A negative `n` counts from the last argument.


#### Arguments
[n:=0] (number): The index of the argument to return.


#### Returns
(Function): Returns the new function.


#### Example

```autohotkey
_.nthArg(1).call("a", "b", "c")
; => "b"

```



## .over
Creates a function that invokes each of the given functions with its arguments and returns an array of the results.


#### Arguments
[iteratees] (...Function): The functions to invoke, either as separate arguments or as one array.


#### Returns
(Function): Returns the new function.


#### Example

```autohotkey
fn_overDouble(param_value) {
	return param_value * 2
fn_overLabel(param_value) {
	return "" param_value
_.over(fn_overDouble, fn_overLabel).call(2)
; => [4, "2"]

```



## .overEvery
Creates a function that returns `true` if all of the given predicates return truthy for its arguments.


#### Arguments
[predicates] (...Function): The predicates to check, either as separate arguments or as one array.


#### Returns
(Function): Returns the new function.


#### Example

```autohotkey
fn_overEveryPositive(param_value) {
	return param_value > 0
fn_overEveryEven(param_value) {
	return Mod(param_value, 2) == 0
everyFn := _.overEvery(fn_overEveryPositive, fn_overEveryEven)
everyFn.call(4)
; => true

```



## .overSome
Creates a function that returns `true` if any of the given predicates return truthy for its arguments.


#### Arguments
[predicates] (...Function): The predicates to check, either as separate arguments or as one array.


#### Returns
(Function): Returns the new function.


#### Example

```autohotkey
fn_overSomeEven(param_value) {
	return Mod(param_value, 2) == 0
fn_overSomeNegative(param_value) {
	return param_value < 0
someFn := _.overSome(fn_overSomeEven, fn_overSomeNegative)
someFn.call(4)
; => true

```



## .property
Creates a function that returns the value at `path` of a given object.


#### Arguments
path (Array|string): The path of the property to get.


#### Returns
(Function): Returns the new accessor function.


#### Example

```autohotkey
objects := [{ a: { b: 2 } }, { a: { b: 1 } }]
_.map(objects, _.property("a.b"))
; => [2, 1]

_.map(objects, _.property(["a", "b"]))
; => [2, 1]

objects := [{name: "neo"}, {name: "morpheus"}]
_.map(objects, _.property("name"))
; => ["neo", "morpheus"]

```



## .range
Creates an array of numbers from `start` up to, but not including, `end`. With one argument, the range starts at `0`. A negative `step` counts down.


#### Arguments
[start:=0] (number): The start of the range.

[end] (number): The end of the range.

[step] (number): The increment between values. Defaults to `1` or `-1`.


#### Returns
(Array): Returns the range of numbers.


#### Example

```autohotkey
_.range(4)
; => [0, 1, 2, 3]

_.range(1, 5)
; => [1, 2, 3, 4]

_.range(0, 20, 5)
; => [0, 5, 10, 15]

```



## .rangeRight
Like `.range`, but returns the numbers in reverse order.


#### Arguments
[start:=0] (number): The start of the range.

[end] (number): The end of the range.

[step] (number): The increment between values. Defaults to `1` or `-1`.


#### Returns
(Array): Returns the range of numbers in reverse order.


#### Example

```autohotkey
_.rangeRight(4)
; => [3, 2, 1, 0]

_.rangeRight(0, 20, 5)
; => [15, 10, 5, 0]

```



## .runInContext
Creates a fresh copy of the library in a new context. AHK has no separate global context, so this returns the library itself.


#### Returns
(Object): Returns the library.


#### Example

```autohotkey
(_.runInContext() == _)
; => true

```



## .stubArray
Returns a new empty array. Useful as a default value.


#### Returns
(Array): Returns an empty array.


#### Example

```autohotkey
_.stubArray()
; => []

```



## .stubFalse
Returns `false`. Useful as a default function.


#### Returns
(boolean): Returns `false`.


#### Example

```autohotkey
_.stubFalse()
; => false

```



## .stubObject
Returns a new empty object. Useful as a default value.


#### Returns
(Object): Returns an empty object.


#### Example

```autohotkey
_.stubObject()
; => {}

```



## .stubString
Returns an empty string. Useful as a default value.


#### Returns
(string): Returns `""`.


#### Example

```autohotkey
_.stubString()
; => ""

```



## .stubTrue
Returns `true`. Useful as a default function.


#### Returns
(boolean): Returns `true`.


#### Example

```autohotkey
assert.true(_.stubTrue())
```



## .times
Invokes the `iteratee` `n` times, returning an array of the results of each invocation. The iteratee is invoked with one argument; (index).


#### Arguments
n (number): The number of times to invoke iteratee.

[iteratee:=.identity] (Function): The function invoked per iteration.


#### Returns
(Array): Returns the array of results.

#### Example
```autohotkey
_.times(4, _.constant(0))
; => [0, 0, 0, 0]

; make an array with random numbers
boundFunc := _.random.bind(1, 1000, 0)
arr := _.times(5, boundFunc)
; => [395, 364, 809, 904, 449]
```




## .toPath
Converts `value` to a property path array.


#### Arguments
value (*): The value to convert.


#### Returns
(Array): Returns the new property path array.


#### Example

```autohotkey
_.toPath("a.b.c")
; => ["a", "b", "c"]

_.toPath("a[1].b.c")
; => ["a", "1", "b", "c"]

```



## .uniqueId
Generates a unique string id. An optional prefix is prepended to the id.


#### Arguments
[prefix:=""] (string): The value to prefix the id with.


#### Returns
(string): Returns the unique id.


#### Example

```autohotkey
firstId := _.uniqueId()
secondId := _.uniqueId()
assert.true(firstId != secondId)
```
