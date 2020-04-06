# Hopcroft-Karp-Bipartite-Matching

## Overview

- This algorithm takes an unweighted bipartite graph and returns the maximal cardinality matching. Returns 
a set of matched values from the two partitions with getMatching();

## Install

How to get it in the org? ----->>>>> I have no idea

## Usage
- all vertex and edge values are of String type

- each vertex should be in one of two disjoint sets such as:  
`Set<String> partition1` and `Set<String> partition2`

- possible edges should be constructed to show any possible edge between the two disjoint sets. Format as following:
`Map<String,Set<String>> edges` (where key=vertex, value=Set of possible matched vertices)

- HopcroftKarpBipartiteMatching should be initliazed with parameters `Set<String> partition1`, `Set<String> partition2`, `Map<String,Set<String>> edges`

- use `getMatching()` to return a Set of matched vertices in form `String vertex1:vertex2`

## Linceses

This work was dervived from JGraphT which is authored by Joris Kinable et al

GNU2.1