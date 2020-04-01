public class UndirectedEdgeContainer {
  public Set<Edge> vertexEdges;

  public UndirectedEdgeContainer()
  {
      vertexEdges = new Set<Edge>();
  }

  /**
   * Add a vertex edge
   *
   * @param e the edge to add
   */
  public void addEdge(Edge e)
  {
      vertexEdges.add(e);
  }

  /**
   * Get number of vertex edges
   *
   * @return the number of vertex edges
   */
  public Integer edgeCount()
  {
      return vertexEdges.size();
  }

  /**
   * Remove a vertex edge
   *
   * @param e the edge to remove
   */
  public void removeEdge(Edge e)
  {
      vertexEdges.remove(e);
  }

  public Set<Edge> getUnmodifiableVertexEdges()
  {
     return vertexEdges;
  }
}
