/*
 * (C) Copyright 2003-2020, by Barak Naveh and Contributors.
 *
 * JGraphT : a free Java graph-theory library
 *
 * See the CONTRIBUTORS.md file distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0, or the
 * GNU Lesser General Public License v2.1 or later
 * which is available at
 * http://www.gnu.org/licenses/old-licenses/lgpl-2.1-standalone.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR LGPL-2.1-or-later
 */

/**
 * A collection of utilities to assist with graph manipulation.
 *
 * @author Barak Naveh
 */
public abstract class Graphs
{

    // /**
    //  * Creates a new edge and adds it to the specified graph similarly to the
    //  * {@link Graph#addEdge(Object, Object)} method.
    //  *
    //  * @param g the graph for which the edge to be added
    //  * @param sourceVertex source vertex of the edge
    //  * @param targetVertex target vertex of the edge
    //  * @param weight weight of the edge
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  *
    //  * @return The newly created edge if added to the graph, otherwise <code>
    //  * null</code>.
    //  *
    //  * @throws UnsupportedOperationException if the graph has no edge supplier
    //  *
    //  * @see Graph#addEdge(Object, Object)
    //  */
    // public static Edge addEdge(Graph g, String sourceVertex, String targetVertex, double weight)
    // {
    //     //Supplier<E> edgeSupplier = g.getEdgeSupplier();
    //     //if (edgeSupplier == null) {
    //     //    throw new UnsupportedOperationException('Graph contains no edge supplier');
    //     //}
    //     Edge e = new Edge(sourceVertex, targetVertex);

    //     if (g.addEdge(sourceVertex, targetVertex, e)) {
    //         g.setEdgeWeight(e, weight);
    //         return e;
    //     } else {
    //         return null;
    //     }
    // }

    // /**
    //  * Adds the specified source and target vertices to the graph, if not already included, and
    //  * creates a new edge and adds it to the specified graph similarly to the
    //  * {@link Graph#addEdge(Object, Object)} method.
    //  */
    // public static Edge addEdgeWithVertices(Graph g, String sourceVertex, String targetVertex)
    // {
    //     g.addVertex(sourceVertex);
    //     g.addVertex(targetVertex);

    //     return g.addEdge(sourceVertex, targetVertex);
    // }

    // /**
    //  * Adds the specified edge to the graph, including its vertices if not already included.
    //  */
    // public static boolean addEdgeWithVertices(Graph targetGraph, Graph sourceGraph, Edge edge)
    // {
    //     String sourceVertex = sourceGraph.getEdgeSource(edge);
    //     String targetVertex = sourceGraph.getEdgeTarget(edge);

    //     targetGraph.addVertex(sourceVertex);
    //     targetGraph.addVertex(targetVertex);

    //     return targetGraph.addEdge(sourceVertex, targetVertex, edge);
    // }

    // /**
    //  * Adds the specified source and target vertices to the graph, if not already included, and
    //  * creates a new weighted edge and adds it to the specified graph similarly to the
    //  */
    // public static Edge addEdgeWithVertices(Graph g, String sourceVertex, String targetVertex, double weight)
    // {
    //     g.addVertex(sourceVertex);
    //     g.addVertex(targetVertex);

    //     return addEdge(g, sourceVertex, targetVertex, weight);
    // }

    // /**
    //  * Adds all the vertices and all the edges of the specified source graph to the specified
    //  * destination graph. First all vertices of the source graph are added to the destination graph.
    //  * Then every edge of the source graph is added to the destination graph. This method returns
    //  * <code>true</code> if the destination graph has been modified as a result of this operation,
    //  * otherwise it returns <code>false</code>.
    //  */
    // public static boolean addGraph(Graph destination, Graph source)
    // {
    //     boolean modified = addAllVertices(destination, source.vertexSet());
    //     modified |= addAllEdges(destination, source, source.edgeSet());

    //     return modified;
    // }

    // /**
    //  * Adds all the vertices and all the edges of the specified source digraph to the specified
    //  * destination digraph, reversing all of the edges. If you want to do this as a linked view of
    //  * the source graph (rather than by copying to a destination graph), use
    //  * {@link EdgeReversedGraph} instead.
    //  *
    //  * <p>
    //  * The behavior of this operation is undefined if any of the specified graphs is modified while
    //  * operation is in progress.
    //  */

    //  /*
    // public static void addGraphReversed(Graph destination, Graph source)
    // {
    //     if (!source.getType().isDirected() || !destination.getType().isDirected()) {
    //         throw new IllegalArgumentException('Graph must be directed');
    //     }

    //     addAllVertices(destination, source.vertexSet());

    //     for (E edge : source.edgeSet()) {
    //         destination.addEdge(source.getEdgeTarget(edge), source.getEdgeSource(edge));
    //     }
    // }
    // */
    // /**
    //  * Adds a subset of the edges of the specified source graph to the specified destination graph.
    //  * The behavior of this operation is undefined if either of the graphs is modified while the
    //  * operation is in progress. {@link #addEdgeWithVertices} is used for the transfer, so source
    //  * vertexes will be added automatically to the target graph.
    //  */


    // public static boolean addAllEdges(
    //     Graph destination, Graph source, Set<Edge> edges)
    // {
    //     boolean modified = false;

    //     for (Edge e : edges) {
    //         String s = source.getEdgeSource(e);
    //         String t = source.getEdgeTarget(e);
    //         destination.addVertex(s);
    //         destination.addVertex(t);
    //         modified |= destination.addEdge(s, t, e);
    //     }

    //     return modified;
    // }

    // /**
    //  * Adds all of the specified vertices to the destination graph. The behavior of this operation
    //  * is undefined if the specified vertex collection is modified while the operation is in
    //  * progress. This method will invoke the {@link Graph#addVertex(Object)} method.
    //  */
    // public static boolean addAllVertices(Graph destination, Set<String> vertices)
    // {
    //     boolean modified = false;

    //     for (String v : vertices) {
    //         modified |= destination.addVertex(v);
    //     }

    //     return modified;
    // }

    /**
     * Returns a list of vertices that are the neighbors of a specified vertex. If the graph is a
     * multigraph vertices may appear more than once in the returned list.
     *
     * <p>
     * The method uses {@link Graph#edgesOf(Object)} to traverse the graph.
     *
     * @param g the graph to look for neighbors in
     * @param vertex the vertex to get the neighbors of
     * @param <V> the graph vertex type
     * @param <E> the graph edge type
     *
     * @return a list of the vertices that are the neighbors of the specified vertex.
     */
    public static List<String> neighborListOf(Graph g, String vertex)
    {
        List<String> neighbors = new List<String>();

        for (String oppV : g.getOppositeVertices(vertex)) {
            neighbors.add(oppV);
        }

        return neighbors;
    }


    /**
     * Returns a set of vertices that are neighbors of a specified vertex.
     */
    public static Set<String> neighborSetOf(Graph g, String vertex)
    {
        return g.getOppositeVertices(vertex);
    }

    // /**
    //  * Returns a list of vertices that are the direct predecessors of a specified vertex. If the
    //  * graph is a multigraph, vertices may appear more than once in the returned list.
    //  */
    // public static List<String> predecessorListOf(Graph g, String vertex)
    // {
    //     List<String> predecessors = new List<String>();
    //     Set<Edge> edges = g.incomingEdgesOf(vertex);

    //     for (Edge e : edges) {
    //         predecessors.add(getOppositeVertex(g, e, vertex));
    //     }

    //     return predecessors;
    // }

    // /**
    //  * Returns a list of vertices that are the direct successors of a specified vertex. If the graph
    //  * is a multigraph vertices may appear more than once in the returned list.
    //  *
    //  * <p>
    //  * The method uses {@link Graph#outgoingEdgesOf(Object)} to traverse the graph.
    //  *
    //  * @param g the graph to look for successors in
    //  * @param vertex the vertex to get the successors of
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  *
    //  * @return a list of the vertices that are the direct successors of the specified vertex.
    //  */
    // public static List<String> successorListOf(Graph g, String vertex)
    // {
    //     List<String> successors = new List<String>();
    //     Set<Edge> edges = g.outgoingEdgesOf(vertex);

    //     for (Edge e : edges) {
    //         successors.add(getOppositeVertex(g, e, vertex));
    //     }

    //     return successors;
    // }

    // /**
    //  * Returns an undirected view of the specified graph. If the specified graph is directed,
    //  * returns an undirected view of it. If the specified graph is already undirected, just returns
    //  * it.

    //  * @see AsUndirectedGraph
    //  */

    //  /*
    // public static Graph undirectedGraph(Graph g)
    // {
    //     if (g.getType().isDirected()) {
    //         return new AsUndirectedGraph<>(g);
    //     } else if (g.getType().isUndirected()) {
    //         return g;
    //     } else {
    //         throw new IllegalArgumentException('graph must be either directed or undirected');
    //     }
    // }
    // */
    // /**
    //  * Tests whether an edge is incident to a vertex.
    //  */
    // public static boolean testIncidence(Graph g, Edge e, String v)
    // {
    //     return (g.getEdgeSource(e).equals(v)) || (g.getEdgeTarget(e).equals(v));
    // }

    // /**
    //  * Gets the vertex opposite another vertex across an edge.
    //  * @return vertex opposite to v across e
    //  */

    // public static String getOppositeVertex(Edge e, String v)
    // {
    //   return e.getOppositeVertex(v);
    // }

    // /**
    //  * Removes the given vertex from the given graph. If the vertex to be removed has one or more
    //  * predecessors, the predecessors will be connected directly to the successors of the vertex to
    //  * be removed.
    //  */


    // /*
    // public static boolean removeVertexAndPreserveConnectivity(Graph graph, String vertex)
    // {
    //     if (!graph.containsVertex(vertex)) {
    //         return false;
    //     }

    //     if (vertexHasPredecessors(graph, vertex)) {
    //         List<String> predecessors = Graphs.predecessorListOf(graph, vertex);
    //         List<String> successors = Graphs.successorListOf(graph, vertex);

    //         for (String predecessor : predecessors) {
    //             addOutgoingEdges(graph, predecessor, successors);
    //         }
    //     }

    //     graph.removeVertex(vertex);
    //     return true;
    // }
    // */

    // /**
    //  * Filters vertices from the given graph and subsequently removes them. If the vertex to be
    //  * removed has one or more predecessors, the predecessors will be connected directly to the
    //  * successors of the vertex to be removed.
    //  */


    // /*
    //  public static boolean removeVerticesAndPreserveConnectivity(Graph graph, Predicate<V> predicate)
    // {
    //     List<String> verticesToRemove = new List<String>();

    //     for (String node : graph.vertexSet()) {
    //         if (predicate.test(node)) {
    //             verticesToRemove.add(node);
    //         }
    //     }

    //     return removeVertexAndPreserveConnectivity(graph, verticesToRemove);
    // }
    // */


    // /**
    //  * Removes all the given vertices from the given graph. If the vertex to be removed has one or
    //  * more predecessors, the predecessors will be connected directly to the successors of the
    //  * vertex to be removed.
    //  *
    //  * @param graph to be mutated
    //  * @param vertices vertices to be removed from this graph, if present
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  *
    //  * @return true if at least one vertex has been removed; false otherwise.
    //  */


    //  /*
    // public static boolean removeVertexAndPreserveConnectivity(Graph graph, Iterable<String> vertices)
    // {
    //     boolean atLeastOneVertexHasBeenRemoved = false;

    //     for (V vertex : vertices) {
    //         if (removeVertexAndPreserveConnectivity(graph, vertex)) {
    //             atLeastOneVertexHasBeenRemoved = true;
    //         }
    //     }

    //     return atLeastOneVertexHasBeenRemoved;
    // }
    // */


    // /**
    //  * Add edges from one source vertex to multiple target vertices. Whether duplicates are created
    //  * depends on the underlying {@link Graph} implementation.
    //  *
    //  * @param graph graph to be mutated
    //  * @param source source vertex of the new edges
    //  * @param targets target vertices for the new edges
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  */


    // /*

    // public static void addOutgoingEdges(Graph graph, String source, Iterable<String> targets)
    // {
    //     if (!graph.containsVertex(source)) {
    //         graph.addVertex(source);
    //     }
    //     for (String target : targets) {
    //         if (!graph.containsVertex(target)) {
    //             graph.addVertex(target);
    //         }
    //         graph.addEdge(source, target);
    //     }
    // }
    // */


    // /**
    //  * Add edges from multiple source vertices to one target vertex. Whether duplicates are created
    //  * depends on the underlying {@link Graph} implementation.
    //  *
    //  * @param graph graph to be mutated
    //  * @param target target vertex for the new edges
    //  * @param sources source vertices for the new edges
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  */


    //  /*
    // public static void addIncomingEdges(Graph graph, String target, Iterable<String> sources)
    // {
    //     if (!graph.containsVertex(target)) {
    //         graph.addVertex(target);
    //     }
    //     for (V source : sources) {
    //         if (!graph.containsVertex(source)) {
    //             graph.addVertex(source);
    //         }
    //         graph.addEdge(source, target);
    //     }
    // }
    // */



    // /**
    //  * Check if a vertex has any direct successors.
    //  *
    //  * @param graph the graph to look for successors
    //  * @param vertex the vertex to look for successors
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  *
    //  * @return true if the vertex has any successors, false otherwise
    //  */
    // public static boolean vertexHasSuccessors(Graph graph, String vertex)
    // {
    //     return !graph.outgoingEdgesOf(vertex).isEmpty();
    // }

    // /**
    //  * Check if a vertex has any direct predecessors.
    //  *
    //  * @param graph the graph to look for predecessors
    //  * @param vertex the vertex to look for predecessors
    //  * @param <V> the graph vertex type
    //  * @param <E> the graph edge type
    //  *
    //  * @return true if the vertex has any predecessors, false otherwise
    //  */
    // public static boolean vertexHasPredecessors(Graph graph, String vertex)
    // {
    //     return !graph.incomingEdgesOf(vertex).isEmpty();
    // }

    // /*
    //  * Compute a new mapping from the vertices of a graph to the integer range $[0, n)$ where $n$ is
    //  * the number of vertices in the graph.
    //  */


    // /*
    // public static VertexToIntegerMapping<String> getVertexToIntegerMapping(Graph graph)
    // {
    //     return new VertexToIntegerMapping<String>(Objects.requireNonNull(graph).vertexSet());
    // }
    // */

}

