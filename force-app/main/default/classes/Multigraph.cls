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
 * The most general implementation of the {@link org.jgrapht.Graph} interface.
 *
 * <p>
 * Its subclasses add various restrictions to get more specific graphs. The decision whether it is
 * directed or undirected is decided at construction time and cannot be later modified (see
 * constructor for details).
 *
 * <p>
 * The behavior of this class can be adjusted by changing the {@link GraphSpecificsStrategy} that is
 * provided from the constructor. All implemented strategies guarantee deterministic vertex and edge
 * set ordering (via {@link LinkedHashMap} and {@link LinkedHashSet}). The defaults are reasonable
 * for most use-cases, only change if you know what you are doing.
 *
 * @param <String> the graph vertex type
 * @param <Edge> the graph edge type
 *
 * @author Barak Naveh
 * @author Dimitrios Michail
 */
public virtual class Multigraph implements Graph
{

    // private static final long serialVersionUID = -3582386521833998627L;

    private static final String LOOPS_NOT_ALLOWED = 'loops not allowed';
    private static final String GRAPH_SPECIFICS_MUST_NOT_BE_NULL =
        'Graph specifics must not be null';
    private static final String INVALID_VERTEX_SUPPLIER_DOES_NOT_RETURN_UNIQUE_VERTICES_ON_EACH_CALL =
        'Invalid vertex supplier (does not return unique vertices on each call).';
    private static final String MIXED_GRAPH_NOT_SUPPORTED = 'Mixed graph not supported';
    private static final String GRAPH_SPECIFICS_STRATEGY_REQUIRED =
        'Graph specifics strategy required';
    private static final String THE_GRAPH_CONTAINS_NO_VERTEX_SUPPLIER =
        'The graph contains no vertex supplier';
    private static final String THE_GRAPH_CONTAINS_NO_EDGE_SUPPLIER =
        'The graph contains no edge supplier';

    // private Supplier<String> vertexSupplier;
    // private Supplier<Edge> edgeSupplier;
    // private GraphType type;

    //COMMENTED OUT FOR REFACTORING **** DUSTIN 4/1
    private Set<Edge> edgeSet;
    private Map<String,Set<Edge>> vertexMap;

    //private UndirectedSpecifics specifics;
    //private IntrusiveEdgesSpecifics intrusiveEdgesSpecifics;
    //****** */
    // private GraphSpecificsStrategy<V, E> graphSpecificsStrategy;

    // /**
    //  * Construct a new graph.
    //  *
    //  * @param vertexSupplier the vertex supplier, can be null
    //  * @param edgeSupplier the edge supplier, can be null
    //  * @param type the graph type
    //  *
    //  * @throws IllegalArgumentException if the graph type is mixed
    //  */
    // protected AbstractBaseGraph(
    //     Supplier<String> vertexSupplier, Supplier<Edge> edgeSupplier, GraphType type)
    // {
    //     this(vertexSupplier, edgeSupplier, type, new FastLookupGraphSpecificsStrategy<>());
    // }

    // /**
    //  * Construct a new graph.
    //  *
    //  * @param vertexSupplier the vertex supplier, can be null
    //  * @param edgeSupplier the edge supplier, can be null
    //  * @param type the graph type
    //  * @param graphSpecificsStrategy strategy for constructing low-level graph specifics
    //  *
    //  * @throws IllegalArgumentException if the graph type is mixed
    //  */
    public Multigraph()
    {
        this.edgeSet = new Set<Edge>();
        this.vertexMap = new Map<String,Set<Edge>>();

        //this.specifics = new UndirectedSpecifics(this, new Map<String, UndirectedEdgeContainer>());


        //this.intrusiveEdgesSpecifics = new IntrusiveEdgesSpecifics(new Map<Edge, Edge>());
    }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Set<Edge> getAllEdges(V sourceVertex, V targetVertex)
    // {
    //     return specifics.getAllEdges(sourceVertex, targetVertex);
    // }

    // // public Supplier<Edge> getEdgeSupplier()
    // // {
    // //     return edgeSupplier;
    // // }

    // /**
    //  * Set the edge supplier that the graph uses whenever it needs to create new edges.
    //  *
    //  * <p>
    //  * A graph uses the edge supplier to create new edge objects whenever a user calls method
    //  * {@link Graph#addEdge(Object, Object)}. Users can also create the edge in user code and then
    //  * use method {@link Graph#addEdge(Object, Object, Object)} to add the edge.
    //  *
    //  * <p>
    //  * In contrast with the {@link Supplier} interface, the edge supplier has the additional
    //  * requirement that a new and distinct result is returned every time it is invoked. More
    //  * specifically for a new edge to be added in a graph <code>e</code> must <i>not</i> be equal to
    //  * any other edge in the graph (even if the graph allows edge-multiplicity). More formally, the
    //  * graph must not contain any edge <code>e2</code> such that <code>e2.equals(e)</code>.
    //  *
    //  * @param edgeSupplier the edge supplier
    //  */
    // // public void setEdgeSupplier(Supplier<Edge> edgeSupplier)
    // // {
    // //     this.edgeSupplier = edgeSupplier;
    // // }

    // // @Override
    // // public Supplier<String> getVertexSupplier()
    // // {
    // //     return vertexSupplier;
    // // }

    // /**
    //  * Set the vertex supplier that the graph uses whenever it needs to create new vertices.
    //  *
    //  * <p>
    //  * A graph uses the vertex supplier to create new vertex objects whenever a user calls method
    //  * {@link Graph#addVertex()}. Users can also create the vertex in user code and then use method
    //  * {@link Graph#addVertex(Object)} to add the vertex.
    //  *
    //  * <p>
    //  * In contrast with the {@link Supplier} interface, the vertex supplier has the additional
    //  * requirement that a new and distinct result is returned every time it is invoked. More
    //  * specifically for a new vertex to be added in a graph <code>v</code> must <i>not</i> be equal
    //  * to any other vertex in the graph. More formally, the graph must not contain any vertex
    //  * <code>v2</code> such that <code>v2.equals(v)</code>.
    //  *
    //  * <p>
    //  * Care must also be taken when interchanging calls to methods {@link Graph#addVertex(Object)}
    //  * and {@link Graph#addVertex()}. In such a case the user must make sure never to add vertices
    //  * in the graph using method {@link Graph#addVertex(Object)}, which are going to be returned in
    //  * the future by the supplied vertex supplier. Such a sequence will result into an
    //  * {@link IllegalArgumentException} when calling method {@link Graph#addVertex()}.
    //  *
    //  * @param vertexSupplier the vertex supplier
    //  */
    // // public void setVertexSupplier(Supplier<String> vertexSupplier)
    // // {
    // //     this.vertexSupplier = vertexSupplier;
    // // }

    /**
     * {@inheritDoc}
     */
    public Edge getEdge(String sourceVertex, String targetVertex)
    {
        if (this.containsVertex(sourceVertex) && this.containsVertex(targetVertex)) {
            for (Edge e : vertexMap.get(sourceVertex)) {
                if (sourceVertex.equals(e.source) && targetVertex.equals(e.target)
                    || sourceVertex.equals(e.target) && targetVertex.equals(e.source))
                return e;
            }
        }
        return null;

    }

    /**
     * {@inheritDoc}
     */
    public Edge addEdge(String sourceVertex, String targetVertex)
    {
        assertVertexExist(sourceVertex);
        assertVertexExist(targetVertex);

        if (sourceVertex == targetVertex) {
            throw new IllegalArgumentException(LOOPS_NOT_ALLOWED);
        }

        Edge e = new Edge(sourceVertex, targetVertex);
        if (!edgeSet.contains(e)) {
            edgeSet.add(e);
            vertexMap.get(sourceVertex).add(e);
            if (!sourceVertex.equals(targetVertex)) {
                vertexMap.get(targetVertex).add(e);
            }
            return e;
        }
        return null;
    }

    // /**
    //  * {@inheritDoc}
    //  */
    // public boolean addEdge(String sourceVertex, String targetVertex, Edge e)
    // {
    //     if (e == null) {
    //         throw new NullPointerException();
    //     }

    //     assertVertexExist(sourceVertex);
    //     assertVertexExist(targetVertex);

    //     if (!type.isAllowingSelfLoops() && sourceVertex.equals(targetVertex)) {
    //         throw new IllegalArgumentException(LOOPS_NOT_ALLOWED);
    //     }

    //     if (!type.isAllowingMultipleEdges()) {
    //         // check that second operation will succeed
    //         if (intrusiveEdgesSpecifics.containsEdge(e)) {
    //             return false;
    //         }
    //         if (!specifics.addEdgeToTouchingVerticesIfAbsent(sourceVertex, targetVertex, e)) {
    //             return false;
    //         }
    //         // cannot fail due to first check
    //         intrusiveEdgesSpecifics.add(e, sourceVertex, targetVertex);
    //         return true;
    //     } else {
    //         if (intrusiveEdgesSpecifics.add(e, sourceVertex, targetVertex)) {
    //             specifics.addEdgeToTouchingVertices(sourceVertex, targetVertex, e);
    //             return true;
    //         }
    //         return false;
    //     }
    // }

    // public String addVertex()
    // {
    //     if (vertexSupplier == null) {
    //         throw new UnsupportedOperationException(THE_GRAPH_CONTAINS_NO_VERTEX_SUPPLIER);
    //     }

    //     String v = vertexSupplier.get();

    //     if (!specifics.addVertex(v)) {
    //         throw new IllegalArgumentException(
    //             INVALID_VERTEX_SUPPLIER_DOES_NOT_RETURN_UNIQUE_VERTICES_ON_EACH_CALL);
    //     }
    //     return v;
    // }

    /**
     * {@inheritDoc}
     */
    public boolean addVertex(String v)
    {
        if (v == null) {
            throw new NullPointerException();
        } else if (containsVertex(v)) {
            return false;
        } else {
            Set<Edge> ec = vertexMap.get(v);
            if (ec == null) {
                vertexMap.put(v, new Set<Edge>());
            }
            return true;

        }
    }

    /**
     * {@inheritDoc}
     */
    public String getEdgeSource(Edge e)
    {
        return e.source;
    }

    /**
     * {@inheritDoc}
     */
    public String getEdgeTarget(Edge e)
    {
        return e.target;
    }

    // // /**
    // //  * Returns a shallow copy of this graph instance. Neither edges nor vertices are cloned.
    // //  *
    // //  * @return a shallow copy of this graph.
    // //  *
    // //  * @throws RuntimeException in case the clone is not supported
    // //  *
    // //  * @see java.lang.Object#clone()
    // //  */
    // // public Object clone()
    // // {
    // //     try {
    // //         AbstractBaseGraph<V, E> newGraph = TypeUtil.uncheckedCast(super.clone());

    // //         newGraph.vertexSupplier = this.vertexSupplier;
    // //         newGraph.edgeSupplier = this.edgeSupplier;
    // //         newGraph.type = type;
    // //         newGraph.unmodifiableVertexSet = null;

    // //         newGraph.graphSpecificsStrategy = this.graphSpecificsStrategy;

    // //         // NOTE: it's important for this to happen in an object
    // //         // method so that the new inner class instance gets associated with
    // //         // the right outer class instance
    // //         newGraph.specifics = newGraph.graphSpecificsStrategy
    // //             .getSpecificsFactory().apply(newGraph, newGraph.type);
    // //         newGraph.intrusiveEdgesSpecifics = newGraph.graphSpecificsStrategy
    // //             .getIntrusiveEdgesSpecificsFactory().apply(newGraph.type);

    // //         Graphs.addGraph(newGraph, this);

    // //         return newGraph;
    // //     } catch (CloneNotSupportedException e) {
    // //         e.printStackTrace();
    // //         throw new RuntimeException();
    // //     }
    // // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public boolean containsEdge(Edge e)
    // {
    //     return intrusiveEdgesSpecifics.containsEdge(e);
    // }

    /**
     * {@inheritDoc}
     */
    public boolean containsVertex(String v)
    {
        return vertexMap.containsKey(v);
    }

    // /**
    //  * {@inheritDoc}
    //  */
    // public int degreeOf(String vertex)
    // {
    //     assertVertexExist(vertex);
    //     return specifics.degreeOf(vertex);
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Set<Edge> edgeSet()
    // {
    //     return intrusiveEdgesSpecifics.getEdgeSet();
    // }

    /**
     * {@inheritDoc}
     */
    public Set<Edge> edgesOf(String vertex)
    {
        assertVertexExist(vertex);
        return vertexMap.get(vertex);

    }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Integer inDegreeOf(String vertex)
    // {
    //     assertVertexExist(vertex);
    //     return specifics.inDegreeOf(vertex);
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Set<Edge> incomingEdgesOf(String vertex)
    // {
    //     assertVertexExist(vertex);
    //     return specifics.incomingEdgesOf(vertex);
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Integer outDegreeOf(String vertex)
    // {
    //     assertVertexExist(vertex);
    //     return specifics.outDegreeOf(vertex);
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Set<Edge> outgoingEdgesOf(String vertex)
    // {
    //     assertVertexExist(vertex);
    //     return specifics.outgoingEdgesOf(vertex);
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public Edge removeEdge(String sourceVertex, String targetVertex)
    // {
    //     E e = getEdge(sourceVertex, targetVertex);

    //     if (e != null) {
    //         specifics.removeEdgeFromTouchingVertices(sourceVertex, targetVertex, e);
    //         intrusiveEdgesSpecifics.remove(e);
    //     }

    //     return e;
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public boolean removeEdge(Edge e)
    // {
    //     if (containsEdge(e)) {
    //         String sourceVertex = getEdgeSource(e);
    //         String targetVertex = getEdgeTarget(e);
    //         specifics.removeEdgeFromTouchingVertices(sourceVertex, targetVertex, e);
    //         intrusiveEdgesSpecifics.remove(e);
    //         return true;
    //     } else {
    //         return false;
    //     }
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // public boolean removeVertex(String v)
    // {
    //     if (containsVertex(v)) {
    //         Set<Edge> touchingEdgesList = edgesOf(v);

    //         // cannot iterate over list - will cause
    //         // ConcurrentModificationException
    //         removeAllEdges(new List<Edge>(touchingEdgesList));

    //         specifics.getVertexSet().remove(v); // remove the vertex itself

    //         return true;
    //     } else {
    //         return false;
    //     }
    // }

    /**
     * {@inheritDoc}
     */
    public Set<String> vertexSet()
    {
        return vertexMap.keySet();
    }

    // /**
    //  * {@inheritDoc}
    //  */
    // public double getEdgeWeight(Edge e)
    // {
    //     if (e == null) {
    //         throw new NullPointerException();
    //     }
    //     return intrusiveEdgesSpecifics.getEdgeWeight(e);
    // }

    // /**
    //  * Set an edge weight.
    //  *
    //  * @param e the edge
    //  * @param weight the weight
    //  * @throws UnsupportedOperationException if the graph is not weighted
    //  */
    // public void setEdgeWeight(Edge e, double weight)
    // {
    //     if (e == null) {
    //         throw new NullPointerException();
    //     }
    //     intrusiveEdgesSpecifics.setEdgeWeight(e, weight);
    // }

    // /**
    //  * {@inheritDoc}
    //  */
    // @Override
    // public GraphType getType()
    // {
    //     return type;
    // }


    // // FROM Abstract GRAPH
    // /**
    //  * @see Graph#containsEdge(Object, Object)
    //  */
    // public boolean containsEdge(String sourceVertex, String targetVertex)
    // {
    //     return getEdge(sourceVertex, targetVertex) != null;
    // }

    // /**
    //  * @see Graph#removeAllEdges(Collection)
    //  */
    // public boolean removeAllEdges(List<Edge> edges)
    // {
    //     boolean modified = false;

    //     for (Edge e : edges) {
    //         modified |= removeEdge(e);
    //     }

    //     return modified;
    // }

    // /**
    //  * @see Graph#removeAllEdges(Object, Object)
    //  */
    // public Set<Edge> removeAllEdges(String sourceVertex, String targetVertex)
    // {
    //     Set<Edge> removed = getAllEdges(sourceVertex, targetVertex);
    //     if (removed == null) {
    //         return null;
    //     }
    //     removeAllEdges(removed);

    //     return removed;
    // }

    // /**
    //  * @see Graph#removeAllVertices(Collection)
    //  */
    // public boolean removeAllVertices(List<String> vertices)
    // {
    //     boolean modified = false;

    //     for (String v : vertices) {
    //         modified |= removeVertex(v);
    //     }

    //     return modified;
    // }

    // /**
    //  * Returns a string of the parenthesized pair (V, E) representing this G=(V,E) graph. 'V' is the
    //  * string representation of the vertex set, and 'E' is the string representation of the edge
    //  * set.
    //  *
    //  * @return a string representation of this graph.
    //  */
    // public override String toString()
    // {
    //     return toStringFromSets(vertexSet(), edgeSet(), this.getType().isDirected());
    // }

    /**
     * Ensures that the specified vertex exists in this graph, or else throws exception.
     *
     * @param v vertex
     *
     * @return <code>true</code> if this assertion holds.
     *
     * @throws NullPointerException if specified vertex is <code>null</code>.
     * @throws IllegalArgumentException if specified vertex does not exist in this graph.
     */
    protected boolean assertVertexExist(String v)
    {
        if (containsVertex(v)) {
            return true;
        } else if (v == null) {
            throw new NullPointerException();
        } else {
            throw new IllegalArgumentException('no such vertex in graph: ' + v);
        }
    }

    // /**
    //  * Removes all the edges in this graph that are also contained in the specified edge array.
    //  * After this call returns, this graph will contain no edges in common with the specified edges.
    //  * This method will invoke the {@link Graph#removeEdge(Object)} method.
    //  *
    //  * @param edges edges to be removed from this graph.
    //  *
    //  * @return <code>true</code> if this graph changed as a result of the call.
    //  *
    //  * @see Graph#removeEdge(Object)
    //  * @see Graph#containsEdge(Object)
    //  */
    // protected boolean removeAllEdges(Edge[] edges)
    // {
    //     boolean modified = false;

    //     for (Edge edge : edges) {
    //         modified |= removeEdge(edge);
    //     }

    //     return modified;
    // }

    // // /**
    // //  * Helper for subclass implementations of toString( ).
    // //  *
    // //  * @param vertexSet the vertex set V to be printed
    // //  * @param edgeSet the edge set E to be printed
    // //  * @param directed true to use parens for each edge (representing directed); false to use curly
    // //  *        braces (representing undirected)
    // //  *
    // //  * @return a string representation of (V,E)
    // //  */
    // // protected String toStringFromSets(
    // //     List<String> vertexSet, List<Edge> edgeSet, boolean directed)
    // // {
    // //     List<String> renderedEdges = new List<String>();

    // //     StringBuilder sb = new StringBuilder();
    // //     for (E e : edgeSet) {
    // //         if ((e.getClass() != DefaultEdge.class)
    // //             && (e.getClass() != DefaultWeightedEdge.class))
    // //         {
    // //             sb.append(e.toString());
    // //             sb.append('=');
    // //         }
    // //         if (directed) {
    // //             sb.append('(');
    // //         } else {
    // //             sb.append('{');
    // //         }
    // //         sb.append(getEdgeSource(e));
    // //         sb.append(',');
    // //         sb.append(getEdgeTarget(e));
    // //         if (directed) {
    // //             sb.append(')');
    // //         } else {
    // //             sb.append('}');
    // //         }

    // //         // REVIEW jvs 29-May-2006: dump weight somewhere?
    // //         renderedEdges.add(sb.toString());
    // //         sb.setLength(0);
    // //     }

    // //     return '(' + vertexSet + ', ' + renderedEdges + ')';
    // // }

    // /**
    //  * Returns a hash code value for this graph. The hash code of a graph is defined to be the sum
    //  * of the hash codes of vertices and edges in the graph. It is also based on graph topology and
    //  * edges weights.
    //  *
    //  * @return the hash code value this graph
    //  *
    //  * @see Object#hashCode()
    //  */
    // public Integer hashCode()
    // {
    //     Integer hash = vertexSet().hashCode();

    //     for (Edge e : edgeSet()) {
    //         Integer part = e.hashCode();

    //         Integer source = getEdgeSource(e).hashCode();
    //         Integer target = getEdgeTarget(e).hashCode();

    //         // see http://en.wikipedia.org/wiki/Pairing_function (VK);
    //         Integer pairing = ((source + target) * (source + target + 1) / 2) + target;
    //         part = (27 * part) + pairing;

    //         long weight = (long) getEdgeWeight(e);
    //         part = (27 * part) + (Integer) (weight ^ (weight >>> 32));

    //         hash += part;
    //     }

    //     return hash;
    // }

    // // /**
    // //  * Indicates whether some other object is "equal to" this graph. Returns <code>true</code> if
    // //  * the given object is also a graph, the two graphs are instances of the same graph class, have
    // //  * identical vertices and edges sets with the same weights.
    // //  *
    // //  * @param obj object to be compared for equality with this graph
    // //  *
    // //  * @return <code>true</code> if the specified object is equal to this graph
    // //  *
    // //  * @see Object#equals(Object)
    // //  */
    // // public boolean equals(Object obj)
    // // {
    // //     if (this == obj) {
    // //         return true;
    // //     }
    // //     if ((obj == null) || (getClass() != obj.getClass())) {
    // //         return false;
    // //     }

    // //     Graph<V, E> g = TypeUtil.uncheckedCast(obj);

    // //     if (!vertexSet().equals(g.vertexSet())) {
    // //         return false;
    // //     }
    // //     if (edgeSet().size() != g.edgeSet().size()) {
    // //         return false;
    // //     }

    // //     for (Edge e : edgeSet()) {
    // //         V source = getEdgeSource(e);
    // //         V target = getEdgeTarget(e);

    // //         if (!g.containsEdge(e)) {
    // //             return false;
    // //         }

    // //         if (!g.getEdgeSource(e).equals(source) || !g.getEdgeTarget(e).equals(target)) {
    // //             return false;
    // //         }

    // //         if (Math.abs(getEdgeWeight(e) - g.getEdgeWeight(e)) > 10e-7) {
    // //             return false;
    // //         }
    // //     }

    // //     return true;
    // // }
}
