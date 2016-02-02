---
layout:         post
title:          "Faster list lookup"
date:           2016-02-01 13:13:13
permalink:      faster-list-lookup
---

Finding multiple items in a `list` might take a long time depending on the size of the `list` and the number of items that need to be found.

When looking for many items it's often faster to create a dict based on the original list.

This technique is not obvious because it requires an extra step compared to the common `item in list` but it's efficient because we are lowering the [time complexity](https://wiki.python.org/moin/TimeComplexity) a lot. When searching an item in a `list` the time complexity is O(n), when it's in a `dict` it's O(1). But the dict has to be built and this has an O(n) complexity.

That means that finding one object in a `list` is as complex as building a `dict` and finding the object in that dict. But finding `m` objects in a `list` has a complexity of O(n * m) while finding `m` objects in a `dict` has a complexity of O(n + m).

Let's look at a practical example :

{% highlight python %}
import uuid
items = [uuid.uuid4() for _ in xrange(100000)] # Generate 100000 random uuids
%timeit indexed_items = {item: 1 for item in items} # Put them in a dict
# 10 loops, best of 3: 38.3 ms per loop
search = items[45000:46000] # Define 1000 ids we want to find

def contained(items, search):
    result = 0

    for item in search:
        if item in items:
            result += 1

    return result

%timeit print_contained(items, search)
# 1 loops, best of 3: 16.6 s per loop
%timeit print_contained(indexed_items, search)
# 1000 loops, best of 3: 220 µs per loop
{% endhighlight %}

Here we are looking for 1000 items in a 100000 items list. When searching in the list it takes 16.6s and when searching in the dict it takes 220µs. Of course we have to add the indexing time : `0.22 + 38.3 = 38.5ms`.
