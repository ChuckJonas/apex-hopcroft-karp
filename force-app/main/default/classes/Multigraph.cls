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
public virtual class Multigraph {
  private static final String LOOPS_NOT_ALLOWED = 'loops not allowed';

  private Set<String> edgeSet;
  private Map<String, Set<String>> vertexMap;

  public Multigraph() {
    this.edgeSet = new Set<String>();
    this.vertexMap = new Map<String, Set<String>>();
  }

  public Edge getEdge(String sourceVertex, String targetVertex) {
    if (
      this.containsVertex(sourceVertex) && this.containsVertex(targetVertex)
    ) {
      if(vertexMap.get(sourceVertex).contains(targetVertex)){
        return new Edge(sourceVertex, targetVertex);
      }
    }
    return null;
  }

  public void addEdge(String sourceVertex, String targetVertex) {
    assertVertexExist(sourceVertex);
    assertVertexExist(targetVertex);

    if (sourceVertex == targetVertex) {
      throw new IllegalArgumentException(LOOPS_NOT_ALLOWED);
    }

    String edgeKey = sourceVertex + ':' + targetVertex;

    if (!edgeSet.contains(edgeKey)) {
      edgeSet.add(edgeKey);
      vertexMap.get(sourceVertex).add(targetVertex);
      vertexMap.get(targetVertex).add(sourceVertex);
    }
  }

  public boolean addVertex(String v) {
    if (v == null) {
      throw new NullPointerException();
    } else if (containsVertex(v)) {
      return false;
    } else {
      Set<String> ec = vertexMap.get(v);
      if (ec == null) {
        vertexMap.put(v, new Set<String>());
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


  public List<String> neighborListOf(String vertex)
    {
        List<String> neighbors = new List<String>();

        for (String oppV : getOppositeVertices(vertex)) {
            neighbors.add(oppV);
        }

        return neighbors;
    }

  public Set<String> neighborSetOf(String vertex)
    {
        return getOppositeVertices(vertex);
    }


  public Set<String> getOppositeVertices(String vertex) {
    assertVertexExist(vertex);
    return vertexMap.get(vertex);
  }


  public Set<String> vertexSet() {
    return vertexMap.keySet();
  }

  
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


}
