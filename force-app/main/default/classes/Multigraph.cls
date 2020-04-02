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
 * @author Barak Naveh
 * @author Dimitrios Michail
 */
public virtual class Multigraph implements Graph {
  private static final String LOOPS_NOT_ALLOWED = 'loops not allowed';

  private Set<String> edgeSet;
  private Map<String, Set<Edge>> vertexMap;

  public Multigraph() {
    this.edgeSet = new Set<String>();
    this.vertexMap = new Map<String, Set<Edge>>();
  }

  public Edge getEdge(String sourceVertex, String targetVertex) {
    if (
      this.containsVertex(sourceVertex) && this.containsVertex(targetVertex)
    ) {
      for (Edge e : vertexMap.get(sourceVertex)) {
        if (
          sourceVertex.equals(e.source) && targetVertex.equals(e.target) ||
          sourceVertex.equals(e.target) && targetVertex.equals(e.source)
        ) {
          return e;
        }
      }
    }
    return null;
  }

  public Edge addEdge(String sourceVertex, String targetVertex) {
    assertVertexExist(sourceVertex);
    assertVertexExist(targetVertex);

    if (sourceVertex == targetVertex) {
      throw new IllegalArgumentException(LOOPS_NOT_ALLOWED);
    }

    String edgeKey = sourceVertex + ':' + targetVertex;

    if (!edgeSet.contains(edgeKey)) {
      Edge e = new Edge(sourceVertex, targetVertex);
      edgeSet.add(edgeKey);
      vertexMap.get(sourceVertex).add(e);
      vertexMap.get(targetVertex).add(e);
      return e;
    }
    return null;
  }

  public boolean addVertex(String v) {
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

  public boolean containsEdge(Edge e) {
    //does not work
    String edgeKey = e.source + ':' + e.target;
    return edgeSet.contains(edgeKey);
  }

  public boolean containsVertex(String v) {
    return vertexMap.containsKey(v);
  }

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

  public Set<Edge> edgesOf(String vertex) {
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

  public Set<String> vertexSet() {
    return vertexMap.keySet();
  }

  //
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
  protected boolean assertVertexExist(String v) {
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
}
