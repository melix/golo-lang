# ............................................................................................... #
#
# Copyright 2012-2013 Institut National des Sciences Appliquées de Lyon (INSA-Lyon)
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ............................................................................................... #

module gololang.StandardPimps

# ............................................................................................... #

pimp java.lang.invoke.MethodHandle {

  function to = |this, interfaceClass| -> asInterfaceInstance(interfaceClass, this)

  function andThen = |this, filter| ->
    java.lang.invoke.MethodHandles.filterReturnValue(this, filter)

  function bindAt = |this, pos, val| ->
    java.lang.invoke.MethodHandles.insertArguments(this, pos, val)
}

# ............................................................................................... #

pimp java.util.Collection {

  function newWithSameType = |this| -> this: getClass(): newInstance()

  function reduce = |this, initialValue, func| {
    var acc = initialValue
    foreach (element in this) {
      acc = func(acc, element)
    }
    return acc
  }
}

# ............................................................................................... #

pimp java.util.List {

  function append = |this, element| {
    this: add(element)
    return this
  }

  function prepend = |this, element| {
    this: add(0, element)
    return this
  }
  
  function insert = |this, index, element| {
    this: add(index, element)
    return this
  }

  function append = |this, head, tail...| {
    this: append(head)
    foreach (element in atoList(tail)) {
      this: append(element)
    }
    return this
  }

  function prepend = |this, head, tail...| {
    for (var i = alength(tail) - 1, i >= 0, i = i - 1) {
      this: prepend(aget(tail, i))
    }
    return this: prepend(head)
  }

  function head = |this| -> this: get(0)
  function tail = |this| -> this: subList(1, this: size())
  function unmodifiableView = |this| -> java.util.Collections.unmodifiableList(this)

  function filter = |this, pred| {
    let filtered = this: newWithSameType()
    foreach (element in this) {
      if pred(element) {
        filtered: append(element)
      }
    }
    return filtered
  }

  function map = |this, func| {
    let mapped = this: newWithSameType()
    foreach (element in this) {
      mapped: append(func(element))
    }
    return mapped
  }

  function each = |this, func| {
    foreach (element in this) {
      func(element)
    }
  }
}

# ............................................................................................... #

pimp java.util.Set {
   
  function include = |this, element| {
    this: add(element)
    return this
  }

  function exclude = |this, element| {
    this: remove(element)
    return this
  }

  function include = |this, first, rest...| {
    this: add(first)
    foreach (element in atoList(rest)) {
      this: add(element)
    }
    return this
  }

  function exclude = |this, first, rest...| {
    this: remove(first)
    foreach (element in atoList(rest)) {
      this: remove(element)
    }
    return this
  }

  function has = |this, element| -> this: contains(element)

  function has = |this, first, rest...| {
    if not(this: contains(first)) {
      return false
    } else {
      foreach (element in atoList(rest)) {
        if not(this: contains(element)) {
          return false
        }
      }
    }
    return true
  }

  function unmodifiableView = |this| -> java.util.Collections.unmodifiableSet(this)

  function filter = |this, pred| {
    let filtered = this: newWithSameType()
    foreach (element in this) {
      if pred(element) {
        filtered: include(element)
      }
    }
    return filtered
  }

  function map = |this, func| {
    let mapped = this: newWithSameType()
    foreach (element in this) {
      mapped: include(func(element))
    }
    return mapped
  }

  function each = |this, func| {
    foreach (element in this) {
      func(element)
    }
  }
}

# ............................................................................................... #

pimp java.util.Map {

  function add = |this, key, value| {
    this: put(key, value)
    return this
  }

  function delete = |this, key| {
    this: remove(key)
    return this
  }

  function addIfAbsent = |this, key, value| {
    if not(this: containsKey(key)) {
      if isClosure(value) {
        this: put(key, value())
      } else {
        this: put(key, value)
      }
    }
    return this
  }

  function getOrElse = |this, key, replacement| {
    let value = this: get(key)
    if value isnt null {
      return value
    }
    if isClosure(replacement) {
      return replacement()
    } else {
      return replacement
    }
  }

  function unmodifiableView = |this| -> java.util.Collections.unmodifiableMap(this)

  function newWithSameType = |this| -> this: getClass(): newInstance()

  function filter = |this, pred| {
    let filtered = this: newWithSameType()
    foreach (entry in this: entrySet()) {
      let key = entry: getKey()
      let value = entry: getValue()
      if pred(key, value) {
        filtered: put(key, value)
      }
    }
    return filtered
  }

  function map = |this, func| {
    let mapped = this: newWithSameType()
    foreach (entry in this: entrySet()) {
      let key = entry: getKey()
      let value = entry: getValue()
      let result = func(key, value)
      mapped: put(result: getKey(), result: getValue())
    }
    return mapped
  }

  function reduce = |this, initialValue, func| {
    var acc = initialValue
    foreach (entry in this: entrySet()) {
      let key = entry: getKey()
      let value = entry: getValue()
      acc = func(acc, key, value)
    }
    return acc
  }

  function each = |this, func| {
    foreach (entry in this: entrySet()) {
      func(entry: getKey(), entry: getValue())
    }
  }
}

# ............................................................................................... #

