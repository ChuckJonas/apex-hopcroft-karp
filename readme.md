# Hopcroft-Karp-Bipartite-Matching

## Overview

This algorithm takes an unweighted bipartite graph and returns the maximal cardinality matching as
a set of matched values from two partitions.

For example... Say we have a menu of food items and a list of people who have chosen a list of their favorites from the menu. There is enough food to feed everyone but not if everyone chooses the first pick on their list. This algorithm will produce a list matching the people with one of their favorite foods so that the least amount of people are left out. To find who is left out, we simply subtract the people from the matching Set.

This same model can be used for more complex problems including impression subscriptions for advertising, allocating resources within the office, distributing sales leads, and much more.

For more information:

- youtube.com/watch?v=lM5eIpF0xjA
- https://en.wikipedia.org/wiki/Hopcroft–Karp_algorithm

## Install

- How to get it in the org? ----->>>>> I have no idea

## Usage

```
// Partition 1 of disjoint sets (Menu items available => one each)
    Set<String> partition1 = new Set<String>();
    partition1.add('tacos');
    partition1.add('pizza');
    partition1.add('chili');
    partition1.add('pasta');
    partition1.add('burger');
    partition1.add('wrap');
    partition1.add('steak');

    // Partition 2 of disjoint sets (Hungry People)
    Set<String> partition2 = new Set<String>();
    partition2.add('Billy');
    partition2.add('Emily');
    partition2.add('John');
    partition2.add('Luke');
    partition2.add('Timothy');
    partition2.add('Anna');
    partition2.add('Raj');

    //Matchings allowed (Favorite menu items of hungry people)
    Map<String, Set<String>> possibleEdges = new Map<String, Set<String>>();
    possibleEdges.put('Billy', new Set<String>{ 'tacos', 'pasta' });
    possibleEdges.put('Emily', new Set<String>{ 'steak', 'chili', 'wrap' });
    possibleEdges.put('John', new Set<String>{ 'pizza', 'burger', 'pasta' });
    possibleEdges.put('Luke', new Set<String>{ 'steak', 'pizza' });
    possibleEdges.put('Timothy', new Set<String>{ 'steak', 'wrap', 'burger' });
    possibleEdges.put('Anna', new Set<String>{ 'chili', 'wrap' });
    possibleEdges.put('Raj', new Set<String>{ 'wrap', 'steak' });

    //Set up matching
    HopcroftKarpBipartiteMatching matching = new HopcroftKarpBipartiteMatching(
        partition2,
        partition1,
        possibleEdges
        );

    //Set<String> matches stores each matching made
    Set<String> matches = matching.getMatching();
    for (String match : matches) {
      System.debug('Matched: ' + match);
    }
```

returns

```
Matched: Billy:tacos
Matched: Emily:steak
Matched: John:pasta
Matched: Luke:pizza
Matched: Timothy:burger
Matched: Anna:chili
Matched: Raj:wrap
```

All vertex and edge values are of String type

HopcroftKarpBipartiteMatching should be initliazed with parameters:

- `Set<String> partition1`
- `Set<String> partition2`
- `Map<String,Set<String>> edges`

Edges should be constructed to show any possible edge between the two disjoint sets.
Format as following:

- `Map<String,Set<String>> edges` (where key=vertex, value=Set of possible matched vertices)

Use `getMatching()` to return a Set of matched vertices:

- `String vertex1:vertex2`

## Linceses

- This work was dervived from JGraphT which is authored by Joris Kinable et al

  - https://jgrapht.org

- GNU2.1
