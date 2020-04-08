# Apex Hopcroft-Karp

## Overview

This algorithm takes an unweighted bipartite graph and returns the maximal cardinality matching as
a Map of matched values from two partitions.

This algorithm can be used to solve complex problems like resource allocation, load balancing, routing and much more.

### More information:

- [Hopcroft-Karp Algorithm video](youtube.com/watch?v=lM5eIpF0xjA)
- [Hopcroft-Karp Wikipedia](https://en.wikipedia.org/wiki/Hopcroft–Karp_algorithm)

## Install

1. `git clone ...`
1. `cd ...`
1. `sfdx force:source:convert -d deploy-package`
1. `sfdx force:mdapi:deploy -d deploy-package -u you@yourorg -w 1000`

## Usage

Say we have a limited number of dishes and a list of people, for who we know their favorite dishes. This algorithm will match the people with one of their favorite foods so that the least amount of people are left out.

```java
    // Partition 2 of disjoint sets (Hungry People)
    Set<String> people = new Set<String>{
      'Billy',
      'Emily',
      'John',
      'Luke',
      'Timothy',
      'Anna',
      'Raj',
      'Dustin'
    };

    // Partition 1 of disjoint sets (Menu items available => one each)
    Set<String> dishes = new Set<String>{
      'tacos',
      'pizza',
      'chili',
      'pasta',
      'burger',
      'wrap',
      'steak',
      'pho'
    };

    //Matchings allowed (Favorite menu items of hungry people)
    Map<String, Set<String>> favoriteDishes = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'tacos', 'pasta' },
      'Emily' => new Set<String>{ 'steak', 'chili', 'wrap' },
      'John' => new Set<String>{ 'pizza', 'burger', 'pasta' },
      'Luke' => new Set<String>{ 'steak', 'pizza' },
      'Timothy' => new Set<String>{ 'steak', 'wrap', 'burger' },
      'Anna' => new Set<String>{ 'chili', 'wrap' },
      'Raj' => new Set<String>{ 'wrap', 'steak' },
      'Dustin' => new Set<String>{ 'steak' }
    };

    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      people,
      dishes,
      favoriteDishes
    );

    Map<String, String> matches = alg.getMatching();

    printMatches(matches); //see HopcroftKarpBipartiteMatchingTest for example
```

**Results**

```
=== Matched ===
Billy will have tacos
Emily will have steak
John will have pasta
Luke will have pizza
Timothy will have burger
Anna will have chili
Raj will have wrap

=== Unmatched People ===
No dish left for Dustin

=== Unmatched Food ===
No one is having Pho

```

As you may have noticed, this isn't the most realistic example. It's more likely we have a limited quantity of each dish (instead of just one of each).

However, the implementation is still the same. We just create a vertex for each unit.

For example, if we had enough to make 3 tacos, we would just need to create 3 unique vertex to represent these items:

```java

Set<String> dishes = new Set<String>{
    'tacos-0',
    'tacos-1',
    'tacos-2'
    //... continue with other dishes
};
```

Then in our `favoriteDishes`, anyone who likes tacos, would get an edge to each of these items:

```java
'Billy' => new Set<String>{ 'tacos-0', 'tacos-1', 'tacos-3', 'pasta-0'},
```

_WARNING: With these types of problems, the edge count can quickly ballon. See Performance section below._

### Implementation Considerations

- All vertex and edge values are of `String` type and case sensitive.

- Edges are undirected. If `vertex1` is connected to `vertex8`, than `vertex 8` is automatically connected to `vertex1`.

#### Performance

Needless to say, Apex is not the ideal environment for any operation that require heavy processing. Both the HEAP and CPU TIMEOUT limits are likely to come into play with sufficiently large graphs.

In our testing we've found that we can handle a couple thousand of vertices with over 300,000 edges.

In practical application, this will likely be significantly reduced by processing to setup the graph and what you do with the results.

We recommend building the partitions and edge sets, then passing them into a `@future` method which can run the matching and handle the result.

To reduce the heap size, we suggest using the shortest possible vertex names. Instead of `tacos-0, tacos-1, tacos-2`, create id aliases `0-1, 0-2, 1-1, 1-2`.

## License

This work was derived heavily from [JGraphT](https://jgrapht.org) (C) Copyright 2017-2020, by Joris Kinable and Contributors.

It is released under the Eclipse Public License - v 2.0 license.
