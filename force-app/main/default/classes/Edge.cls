public class Edge {
  public final String source;
  public final String target;

  public Edge(String source, String target) {
    this.source = source;
    this.target = target;
  }

  public String getOppositeVertex(String vertex) {
    if (vertex == source) {
      return target;
    } else if (vertex == target) {
      return source;
    } else {
      throw new IllegalArgumentException('Illegal Endpoint');
    }
  }

  public Integer hashCode() {
    return (source + target).hashCode();
  }

  public Boolean equals(Object obj) {
    Edge e = (Edge) obj;
    return (e.source == this.source && e.target == this.target);
  }
}
