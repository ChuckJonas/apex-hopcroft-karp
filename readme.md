# Apex Hopcroft-Karp

## Overview

This algorithm takes an unweighted bipartite graph and returns the maximal cardinality matching as
a Map of matched values from two partitions.

It can be used to solve complex problems like resource allocation, load balancing, routing and much more.

### More information:

- [Hopcroft-Karp Algorithm video](youtube.com/watch?v=lM5eIpF0xjA)
- [Hopcroft-Karp Wikipedia](https://en.wikipedia.org/wiki/Hopcroft–Karp_algorithm)

## Install

1. `git clone ...`
1. `cd ...`
1. `sfdx force:source:convert -d deploy-package`
1. `sfdx force:mdapi:deploy -d deploy-package -u you@yourorg -w 1000`

## Usage

### Simple Matching Example

Say we have a list of tasks and a list of people. Each person is capable of doing one at least one task.

The algorithm will match will match each person to a task in a way gives us the highest number of matches.

```java
    // Partition 1 of disjoint sets (people)
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

    // Partition 2 of disjoint sets (chores)
    Set<String> tasks = new Set<String>{
      'wash dishes',
      'vacuum',
      'do laundry',
      'sweep',
      'mop',
      'dust',
      'iron',
      'take out trash'
    };

    //Allowed Matchings
    Map<String, Set<String>> preferredTasks = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'wash dishes', 'sweep' },
      'Emily' => new Set<String>{ 'iron', 'do laundry', 'dust' },
      'John' => new Set<String>{ 'vacuum', 'mop', 'sweep' },
      'Luke' => new Set<String>{ 'iron', 'vacuum', 'take out trash' },
      'Timothy' => new Set<String>{ 'iron', 'dust', 'mop' },
      'Anna' => new Set<String>{ 'do laundry', 'dust' },
      'Raj' => new Set<String>{ 'dust', 'iron' },
      'Dustin' => new Set<String>{ 'take out trash' }
    };

    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      people,
      tasks,
      preferredTasks
    );

    // Return Set of matched vertices using H-K Algorithm
    Map<String, String> matches = alg.getMatching();

    printMatches(matches); //see HopcroftKarpBipartiteMatchingTest for example
```

**Results**

```
Billy will wash dishes
Emily will iron
John will sweep
Luke will vacuum
Timothy will mop
Anna will do laundry
Raj will dust
Dustin will take out trash
```

## Solving "Resource Allocation" problems

We can also use the same principle to solve resource allocation problems. Imagine we have a list of people who who each have one or more preferred protein (`beef, chicken, fish, tofu`). We want to feed everyone, but we have limited quantities of each protein.

For this we can use the `ExpandedHopcroftKarpBipartiteMatching` class:

```java
  Map<String, Integer> people = new Map<String, Integer>{
      'Billy' => 2, //bill is a hungry boy. he eats two wash dishes
      'Emily' => 1,
      'John' => 1,
      'Luke' => 1,
      'Timothy' => 1,
      'Anna' => 1,
      'Raj' => 1,
      'Dustin' => 1
    };

    Map<String, Integer> protein = new Map<String, Integer>{
      'steak' => 3,
      'chicken' => 2,
      'fish' => 2,
      'tofu' => 1
    };

    //Matchings allowed (preferred protein of hungry people)
    Map<String, Set<String>> proteinPreference = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'steak', 'chicken' },
      'Emily' => new Set<String>{ 'fish', 'tofu' },
      'John' => new Set<String>{ 'chicken', 'fish' },
      'Luke' => new Set<String>{ 'steak' },
      'Timothy' => new Set<String>{ 'chicken', 'fish', 'tofu' },
      'Anna' => new Set<String>{ 'steak', 'fish' },
      'Raj' => new Set<String>{ 'chicken' },
      'Dustin' => new Set<String>{ 'tofu' }
    };

    ExpandedHopcroftKarpBipartiteMatching alg = new ExpandedHopcroftKarpBipartiteMatching(
      people,
      protein,
      proteinPreference
    );

    // Return Set of matched vertices using H-K Algorithm
    ExpandedHopcroftKarpBipartiteMatching.Result result = alg.getMatching();
    printResults(results) //see test
```

** Results **

```
steak will be had by Billy(2), Luke(1)
chicken will be had by John(1), Timothy(1)
fish will be had by Emily(1), Anna(1)
tofu will be had by Dustin(1)

Raj was unmatched 1 time(s)
```

Behind the scenes, we're still using the same algorithm, however, we've just created an vertex and edge mapping for each "unit" we need to match:

```java
/* Equivalent setup */
Set<String> protein = new Set<String>{
    'steak-0',
    'steak-1',
    'steak-2',
    //... continue with other protein
};
Map<String, Set<String>> proteinPreference = new Map<String, Set<String>>{
  'Billy' => new Set<String>{ 'steak-0', 'steak-1', 'steak-3', 'chicken-0', 'chicken-1'},
  //... continue with other matchings
}
```

_WARNING: If your vertex high connectivity, the edge count will ballon! See Performance section below._

### Implementation Considerations

- All vertex and edge values are of `String` type and case sensitive.

- Edges are undirected. If `vertex1` is connected to `vertex8`, than `vertex 8` is automatically connected to `vertex1`.

#### Performance

Needless to say, Apex is not the ideal environment for any operation that require heavy processing. Both the HEAP and CPU TIMEOUT limits are likely to come into play with sufficiently large graphs.

In our testing we've found that we can handle a couple thousand of vertices with a few _hundred thousand_ edges.

In practical application, there will likely be significant overhead in both the processing required to setup the graph and handle the results. Follow these tips to optimize your performance:

- If possible, first build the partitions and edge sets, then passing them into a `@future` method which can run the matching and handle the result.

- To reduce the heap size, we suggest using the shortest possible vertex names. Instead of `'wash dishes', 'take out trash', 'sweep'`, create short aliases: `0, 1, 2` and store each in a reverse lookup map.

- For Resource Allocation problems, always scale your "units" to the lowest acceptable resolution. For example, you may have `600` ounces of steak, but since each serving size is `5 ounce`, you'd only want to set up the graph with `120` "units".

## License

This work was derived heavily from [JGraphT](https://jgrapht.org) (C) Copyright 2017-2020, by Joris Kinable and Contributors.

It is released under the Eclipse Public License - v 2.0 license.
