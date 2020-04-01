public virtual class UndirectedSpecifics {
  // private static final long serialVersionUID = 4206026440450450992L;

  protected Graph graph;
  protected Map<String, UndirectedEdgeContainer> vertexMap;

  /**
   * Construct a new undirected specifics.
   *
   * @param graph the graph for which these specifics are for
   * @param vertexMap map for the storage of vertex edge sets. Needs to have a predictable
   *        iteration order.
   * @param edgeSetFactory factory for the creation of vertex edge sets
   */
  public UndirectedSpecifics(
      Graph graph, Map<String, UndirectedEdgeContainer> vertexMap
  )
  {
      this.graph = graph;
      this.vertexMap = vertexMap;
  }

  /**
   * {@inheritDoc}
   */
  public boolean addVertex(String v)
  {
      UndirectedEdgeContainer ec = vertexMap.get(v);
      if (ec == null) {
          vertexMap.put(v, new UndirectedEdgeContainer());
          return true;
      }
      return false;
  }

  /**
   * {@inheritDoc}
   */
  public Set<String> getVertexSet()
  {
      return vertexMap.keySet();
  }

  /**
   * {@inheritDoc}
   */
  // public Set<Edge> getAllEdges(String sourceVertex, String targetVertex)
  // {
  //     Set<Edge> edges = null;

  //     if (graph.containsVertex(sourceVertex) && graph.containsVertex(targetVertex)) {
  //         edges = new List<Edge>();

  //         for (Edge e : getEdgeContainer(sourceVertex).vertexEdges) {
  //             boolean equal = isEqualsStraightOrInverted(sourceVertex, targetVertex, e);

  //             if (equal) {
  //                 edges.add(e);
  //             }
  //         }
  //     }

  //     return edges;
  // }

  /**
   * {@inheritDoc}
   */
  public Edge getEdge(String sourceVertex, String targetVertex)
  {
      if (graph.containsVertex(sourceVertex) && graph.containsVertex(targetVertex)) {

          for (Edge e : getEdgeContainer(sourceVertex).vertexEdges) {
              boolean equal = isEqualsStraightOrInverted(sourceVertex, targetVertex, e);

              if (equal) {
                  return e;
              }
          }
      }

      return null;
  }

  private boolean isEqualsStraightOrInverted(String sourceVertex, String targetVertex, Edge e)
  {
      boolean equalStraight = sourceVertex.equals(graph.getEdgeSource(e))
          && targetVertex.equals(graph.getEdgeTarget(e));

      boolean equalInverted = sourceVertex.equals(graph.getEdgeTarget(e))
          && targetVertex.equals(graph.getEdgeSource(e));
      return equalStraight || equalInverted;
  }

  public boolean addEdgeToTouchingVertices(String sourceVertex, String targetVertex, Edge e)
  {
      getEdgeContainer(sourceVertex).addEdge(e);

      if (!sourceVertex.equals(targetVertex)) {
          getEdgeContainer(targetVertex).addEdge(e);
      }
      return true;
  }

  public boolean addEdgeToTouchingVerticesIfAbsent(String sourceVertex, String targetVertex, Edge e)
  {
      // lookup for edge with same source and target
      UndirectedEdgeContainer ec = getEdgeContainer(sourceVertex);
      for (Edge edge : ec.vertexEdges) {
          if (isEqualsStraightOrInverted(sourceVertex, targetVertex, edge)) {
              return false;
          }
      }

      // add
      ec.addEdge(e);
      getEdgeContainer(targetVertex).addEdge(e);
      return true;
  }

  public Edge createEdgeToTouchingVerticesIfAbsent(
      String sourceVertex, String targetVertex)
  {
      // lookup for edge with same source and target
      UndirectedEdgeContainer ec = getEdgeContainer(sourceVertex);
      for (Edge edge : ec.vertexEdges) {
          if (isEqualsStraightOrInverted(sourceVertex, targetVertex, edge)) {
              return null;
          }
      }

      // create and add
      Edge e = new Edge(sourceVertex, targetVertex, 0);
      ec.addEdge(e);
      getEdgeContainer(targetVertex).addEdge(e);

      return e;
  }

  /**
   * {@inheritDoc}
   */
  public Integer degreeOf(String vertex)
  {
    return getEdgeContainer(vertex).edgeCount();
  }

  /**
   * {@inheritDoc}
   */

  public Set<Edge> edgesOf(String vertex)
  {
      return getEdgeContainer(vertex).getUnmodifiableVertexEdges();
  }

  /**
   * {@inheritDoc}
   */
  public Integer inDegreeOf(String vertex)
  {
      return degreeOf(vertex);
  }

  /**
   * {@inheritDoc}
   */
  public Set<Edge> incomingEdgesOf(String vertex)
  {
      return getEdgeContainer(vertex).getUnmodifiableVertexEdges();
  }

  /**
   * {@inheritDoc}
   */
  public Integer outDegreeOf(String vertex)
  {
      return degreeOf(vertex);
  }

  /**
   * {@inheritDoc}
   */
  public Set<Edge> outgoingEdgesOf(String vertex)
  {
      return getEdgeContainer(vertex).getUnmodifiableVertexEdges();
  }

  /**
   * {@inheritDoc}
   */
  public void removeEdgeFromTouchingVertices(String sourceVertex, String targetVertex, Edge e)
  {
      getEdgeContainer(sourceVertex).removeEdge(e);

      if (!sourceVertex.equals(targetVertex)) {
          getEdgeContainer(targetVertex).removeEdge(e);
      }
  }

  /**
   * Get the edge container for a specified vertex.
   *
   * @param vertex a vertex in this graph
   *
   * @return an edge container
   */
  protected UndirectedEdgeContainer getEdgeContainer(String vertex)
  {
      UndirectedEdgeContainer ec = vertexMap.get(vertex);

      if (ec == null) {
          ec = new UndirectedEdgeContainer();
          vertexMap.put(vertex, ec);
      }

      return ec;
  }
}
