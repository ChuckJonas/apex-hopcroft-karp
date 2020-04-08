# Hopcroft-Karp-Bipartite-Matching

## Overview

This algorithm takes an unweighted bipartite graph and returns the maximal cardinality matching as
a Map of matched values from two partitions.

### Example

Say we have a menu of food items and a list of people who have chosen a list of their favorites from the menu. There is enough food to feed everyone but not if everyone chooses the first pick on their list. This algorithm will produce a list matching the people with one of their favorite foods so that the least amount of people are left out. To find who is left out, we simply subtract the people from the matching Set.

This same model can be used for more complex problems including impression subscriptions for advertising, allocating resources within the office, distributing sales leads, and much more.

### More information:

- [Introduction to the Hopcroft-Karp Algorithm](youtube.com/watch?v=lM5eIpF0xjA)
- [Hopcroft-Karp Wikipedia](https://en.wikipedia.org/wiki/Hopcroft–Karp_algorithm)

## Install

- How to get it in the org? ----->>>>> I have no idea

## Usage

```java
// Partition 2 of disjoint sets (Hungry People)
    Set<String> partition1 = new Set<String>{
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
    Set<String> partition2 = new Set<String>{
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
    Map<String, Set<String>> possibleEdges = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'tacos', 'pasta' },
      'Emily' => new Set<String>{ 'steak', 'chili', 'wrap' },
      'John' => new Set<String>{ 'pizza', 'burger', 'pasta' },
      'Luke' => new Set<String>{ 'steak', 'pizza' },
      'Timothy' => new Set<String>{ 'steak', 'wrap', 'burger' },
      'Anna' => new Set<String>{ 'chili', 'wrap' },
      'Raj' => new Set<String>{ 'wrap', 'steak' },
      'Dustin' => new Set<String>{ 'steak' }
    };

    //Set up matching
    HopcroftKarpBipartiteMatching matching = new HopcroftKarpBipartiteMatching(
        partition1,
        partition2,
        possibleEdges
        );

    //Map<String,String> matches stores each matching made
    Map<String,String> matches = matching.getMatching();
    System.debug('=== Matched ===');
    System.assert(true, matches.containsKey('Emily'));
    System.assertEquals('steak', matches.get('Emily'));

    for (String match : matches.keySet()) {
      if (partition1.contains(match)) {
        System.debug(match + ' will have ' + matches.get(match));
      } else {
          System.debug('People having ' + match.capitalize() + ': ' + matches.get(match));
      }
    }

    //Remove matched from partition list
    for (String vertex : matches.keySet()) {
      partition1.remove(vertex);
      partition2.remove(matches.get(vertex));
    }

    System.debug('=== Unmatched People ===');
    System.assertEquals(1, partition1.size());
    for (String person : partition1) {
      System.debug(('No dish left for ' + person));
    }

    System.debug('=== Unmatched Food ===');
    System.assertEquals(1, partition2.size());
    for (String food : partition2) {
      System.debug('No one is having ' + food.capitalize());
    }
```

returns

```
=== Matched ===
Billy will have tacos
Emily will have steak
John will have pasta
Luke will have pizza
Timothy will have burger
Anna will have chili
Raj will have wrap
People having Tacos: Billy
People having Steak: Emily
People having Pasta: John
People having Pizza: Luke
People having Burger: Timothy
People having Chili: Anna
People having Wrap: Raj

=== Unmatched People ===
No dish left for Dustin
=== Unmatched Food ===
No one is having Pho

```

**Implementation Considerations:**

- All vertex and edge values are of String type

- Edges are undirected. If vertex1 is connected to vertex8 than vertex 8 is automatically connected to vertex1.

- return value is: `Map<String,String> key(partition1)=>value(partition2)` and the reverse

## Performance

Needless to say, Apex is not the ideal enviroment for any operation that require heavy processing. Both the HEAP and CPU TIMEOUT limits are likely to come into play with sufficiently large graphs.

In our testing we've found that we can handle hundreds of vertices with hundreds of thousands of edges.

In Practical application, this will likely be significantly reduced by the functionality required to setup the graph and what you do with the results.

We recommend building the graph partitions and edge sets, then pass them into a @Future method which can run the matching and handle the result.

## Linceses

- This work was dervived from JGraphT which is authored by Joris Kinable et al

  - [JGraphT](https://jgrapht.org)

- GNU2.1
