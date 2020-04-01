//WTF does this do?  Seemly nothing for our purposes
public virtual class IntrusiveEdgesSpecifics {

  protected Map<Edge, Edge> edgeMap;

  /**
   * Constructor
   *
   * @param edgeMap the map to use for storage
   */
  public IntrusiveEdgesSpecifics(Map<Edge, Edge> edgeMap)
  {
      this.edgeMap = edgeMap;
  }

  /**
   * Check if an edge exists
   *
   * @param e the edge
   * @return true if the edge exists, false otherwise
   */
  public boolean containsEdge(Edge e)
  {
      return edgeMap.containsKey(e);
  }

  /**
   * Get the edge set.
   *
   * @return an unmodifiable edge set
   */
  public Set<Edge> getEdgeSet()
  {
      return edgeMap.keySet();
  }

  /**
   * Remove an edge.
   *
   * @param e the edge
   */
  public void remove(Edge e)
  {
      edgeMap.remove(e);
  }

  /**
   * Get the source of an edge.
   *
   * @param e the edge
   * @return the source vertex of an edge
   */
  public String getEdgeSource(Edge e)
  {
      Edge ie = getIntrusiveEdge(e);
      if (ie == null) {
          throw new IllegalArgumentException('no such edge in graph: ' + e.toString());
      }
      return e.source;
  }

  /**
   * Get the target of an edge.
   *
   * @param e the edge
   * @return the target vertex of an edge
   */
  public String getEdgeTarget(Edge e)
  {
      Edge ie = getIntrusiveEdge(e);
      if (ie == null) {
          throw new IllegalArgumentException('no such edge in graph: ' + e.toString());
      }
      return ie.target;
  }


  public boolean add(Edge e, String sourceVertex, String targetVertex)
    {
        if (edgeMap.containsKey(e)) {
            return false;
        }

        Edge intrusiveEdge  = new Edge(sourceVertex, targetVertex);


        edgeMap.put(e, intrusiveEdge);
        return true;
    }

    protected Edge getIntrusiveEdge(Edge e)
    {
        return edgeMap.get(e);
    }
}
