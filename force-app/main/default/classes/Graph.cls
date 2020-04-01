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
 * The root interface in the graph hierarchy. A mathematical graph-theory graph object
 * <code>G(V,E)</code> contains a set <code>V</code> of vertices and a set <code>
 * E</code> of edges. Each edge e=(v1,v2) in E connects vertex v1 to vertex v2. for more information
 * about graphs and their related definitions see <a href="http://mathworld.wolfram.com/Graph.html">
 * http://mathworld.wolfram.com/Graph.html</a>.
 *
 * <p>
 * This library generally follows the terminology found at:
 * <a href="http://mathworld.wolfram.com/topics/GraphTheory.html">
 * http://mathworld.wolfram.com/topics/GraphTheory.html</a>. Implementation of this interface can
 * provide simple-graphs, multigraphs, pseudographs etc. The package <code>org.jgrapht.graph</code>
 * provides a gallery of abstract and concrete graph implementations.
 * </p>
 *
 * <p>
 * This library works best when vertices represent arbitrary objects and edges represent the
 * relationships between them. Vertex and edge instances may be shared by more than one graph.
 * </p>
 *
 * <p>
 * Through generics, a graph can be typed to specific classes for vertices <code>V</code> and edges
 * <code>E&lt;T&gt;</code>. Such a graph can contain vertices of type <code>V</code> and all
 * sub-types and Edges of type <code>
 * E</code> and all sub-types.
 * </p>
 *
 * <p>
 * For guidelines on vertex and edge classes, see
 * <a href="https://github.com/jgrapht/jgrapht/wiki/EqualsAndHashCode">this wiki page</a>.
 *
 * @param <V> the graph vertex type
 * @param <E> the graph edge type
 *
 * @author Barak Naveh
 */
public interface Graph
{
    // Set<Edge> getAllEdges(String sourceVertex, String targetVertex);

    Edge getEdge(String sourceVertex, String targetVertex);


    //Supplier<String> getVertexSupplier();


    //Supplier<Edge> getEdgeSupplier();


    Edge addEdge(String sourceVertex, String targetVertex);


    // boolean addEdge(String sourceVertex, String targetVertex, Edge e);


    // String addVertex();


    boolean addVertex(String v);

    // boolean containsEdge(String sourceVertex, String targetVertex);

    // boolean containsEdge(Edge e);

    boolean containsVertex(String v);

    // Set<Edge> edgeSet();

    // Integer degreeOf(String vertex);

    Set<Edge> edgesOf(String vertex);

    // Integer inDegreeOf(String vertex);

    // Set<Edge> incomingEdgesOf(String vertex);

    // Integer outDegreeOf(String vertex);

    // Set<Edge> outgoingEdgesOf(String vertex);

    // boolean removeAllEdges(Set<Edge> edges);

    // Set<Edge> removeAllEdges(String sourceVertex, String targetVertex);

    // boolean removeAllVertices(Set<String> vertices);


    // Edge removeEdge(String sourceVertex, String targetVertex);


    // boolean removeEdge(Edge e);


    // boolean removeVertex(String v);

    //NEEDED
    Set<String> vertexSet();

    //NEEDED
    String getEdgeSource(Edge e);

    //NEEDED
    String getEdgeTarget(Edge e);

    //GraphType getType();

    //Double DEFAULT_EDGE_WEIGHT = 1.0;

    // double getEdgeWeight(Edge e);

    // void setEdgeWeight(Edge e, double weight);



}
