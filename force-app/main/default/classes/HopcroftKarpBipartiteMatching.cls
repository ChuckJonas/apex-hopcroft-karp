 /**
 * Implementation of the well-known Hopcroft Karp algorithm to compute a matching of maximum
 * cardinality in a bipartite graph. The algorithm runs in $O(|E| \cdot \sqrt{|V|})$ time. This
 * implementation accepts undirected graphs which may contain self-loops and multiple edges. To
 * compute a maximum cardinality matching in general (non-bipartite) graphs, use
 * {@link SparseEdmondsMaximumCardinalityMatching} instead.
 *
 * <p>
 * The Hopcroft Karp matching algorithm computes augmenting paths of increasing length, until no
 * augmenting path exists in the graph. At each iteration, the algorithm runs a Breadth First Search
 * from the exposed (free) vertices, until an augmenting path is found. Next, a Depth First Search
 * is performed to find all (vertex disjoint) augmenting paths of the same length. The matching is
 * augmented along all discovered augmenting paths simultaneously.
 *
 * <p>
 * The original algorithm is described in: Hopcroft, John E.; Karp, Richard M. (1973), "An n5/2
 * algorithm for maximum matchings in bipartite graphs", SIAM Journal on Computing 2 (4): 225–231,
 * doi:10.1137/0202019 A coarse overview of the algorithm is given in: <a href=
 * "http://en.wikipedia.org/wiki/Hopcroft-Karp_algorithm">http://en.wikipedia.org/wiki/Hopcroft-Karp_algorithm</a>
 *
 *
 * @author Chuck Jonas and Dustin Kovac
 * Derived from Joris Kinable
 */
public class HopcroftKarpBipartiteMatching {

  private final Multigraph graph;
  private final Set<String> partition1;
  private final Set<String> partition2;

  /* Ordered list of vertices */
  private List<String> vertices;
  /* Mapping of a vertex to their unique position in the ordered list of vertices */
  private Map<String, Integer> vertexIndexMap;

  /* Number of matched vertices i partition 1. */
  private Integer matchedVertices = 0;

  /* Dummy vertex. All vertices are initially matched against this dummy vertex */
  private final Integer DUMMY = 0;

  /* Infinity */
  private final Integer INF = 999999999;

  /* Array keeping track of the matching. */
  private Integer[] matching;
  /* Distance array. Used to compute shoretest augmenting paths */
  private Integer[] dist;

  /* queue used for breadth first search */
  private Queue queue;

  /**
   * Constructs a new instance of the Hopcroft Karp bipartite matching algorithm. The input graph
   * must be bipartite. For efficiency reasons, this class does not check whether the input graph
   * is bipartite. Invoking this class on a non-bipartite graph results in undefined behavior. To
   * test whether a graph is bipartite, use {@link GraphTests#isBipartite(Graph)}.
   *
   * @param graph bipartite graph
   * @param partition1 the first partition of vertices in the bipartite graph
   * @param partition2 the second partition of vertices in the bipartite graph
   */
  public HopcroftKarpBipartiteMatching(
      Multigraph graph, Set<String> partition1, Set<String> partition2)
  {
      this.graph = graph;

      // Ensure that partition1 is smaller or equal in size compared to partition 2
      if (partition1.size() <= partition2.size()) {
          this.partition1 = partition1;
          this.partition2 = partition2;
      } else { // else, swap
          this.partition1 = partition2;
          this.partition2 = partition1;
      }
  }

  /**
   * Initialize data structures
   */
  private void init()
  {
      vertices = new List<String>();
      vertices.add(null);
      vertices.addAll(partition1);
      vertices.addAll(partition2);
      vertexIndexMap = new Map<String, Integer> ();
      for (Integer i = 0; i < vertices.size(); i++)
          vertexIndexMap.put(vertices.get(i), i);

      matching = initializeFixedIntArray(vertices.size() + 1);
      dist = initializeFixedIntArray(partition1.size() + 1);
      queue = new Queue(vertices.size());
  }

  /**
   * Greedily compute an initial feasible matching
   */
  private void warmStart()
  {
      for (String uOrig : partition1) {
          Integer u = vertexIndexMap.get(uOrig);
          for (String vOrig : graph.neighborListOf(uOrig)) {
              Integer v = vertexIndexMap.get(vOrig);
              if (matching[v] == DUMMY) {
                  matching[v] = u;
                  matching[u] = v;
                  matchedVertices++;
                  break;
              }
          }
      }
  }

  /**
   * BFS function which finds the shortest augmenting path. The length of the shortest augmenting
   * path is stored in dist[DUMMY].
   *
   * @return true if an augmenting path was found, false otherwise
   */
  private boolean bfs()
  {
      queue.clear();

      for (Integer u = 1; u <= partition1.size(); u++)
          if (matching[u] == DUMMY) { // Add all unmatched vertices to the queue and set their
                                      // distance to 0
              dist[u] = 0;
              queue.enqueue(u);
          } else // Set distance of all matched vertices to INF
              dist[u] = INF;
      dist[DUMMY] = INF;

      while (!queue.isEmpty()) {
          Integer u = queue.poll();
          if (dist[u] < dist[DUMMY])
              for (String vOrig : graph.neighborListOf(vertices.get(u))) {
                  Integer v = vertexIndexMap.get(vOrig);
                  if (dist[matching[v]] == INF) {
                      dist[matching[v]] = dist[u] + 1;
                      queue.enqueue(matching[v]);
                  }
              }
      }
      return dist[DUMMY] != INF; // Return true if an augmenting path is found
  }

  /**
   * Find all vertex disjoint augmenting paths of length dist[DUMMY]. To find paths of dist[DUMMY]
   * length, we simply follow nodes that are 1 distance increments away from each other.
   *
   * @param u vertex from which the DFS is started
   * @return true if an augmenting path from vertex u was found, false otherwise
   */
  private boolean dfs(Integer u)
  {
      if (u != DUMMY) {
          for (String vOrig : graph.neighborListOf(vertices.get(u))) {
              Integer v = vertexIndexMap.get(vOrig);
              if (dist[matching[v]] == dist[u] + 1)
                  if (dfs(matching[v])) {
                      matching[v] = u;
                      matching[u] = v;
                      return true;
                  }
          }
          // No augmenting path has been found. Set distance of u to INF to ensure that u isn't
          // visited again.
          dist[u] = INF;
          return false;
      }
      return true;
  }


  public virtual Matching getMatching()
  {
      this.init();
      this.warmStart();

      while (matchedVertices < partition1.size() && bfs()) {
          // Greedily search for vertex disjoint augmenting paths
          for (Integer v = 1; v <= partition1.size() && matchedVertices < partition1.size(); v++)
              if (matching[v] == DUMMY) // v is unmatched
                  if (dfs(v))
                      matchedVertices++;
      }
      system.assert(matchedVertices <= partition1.size());

      Set<Edge> edges = new Set<Edge>();
      for (Integer i = 0; i < vertices.size(); i++) {
          if (matching[i] != DUMMY) {
              edges.add(graph.getEdge(vertices.get(i), vertices.get(matching[i])));
          }
      }
      return new Matching(graph, edges, edges.size());
  }
  private class Queue {
    private List<Integer> ls;
    public Queue() {
        ls = new List<Integer>();
    }

    public Queue(Integer size) {
        ls = initializeFixedIntArray(size);
    }

    public Integer size() {return ls.size();}

    public Boolean isEmpty() {
        return ls.isEmpty();
    }

    public void clear() {
        ls.clear();
    }

    public void enqueue(Integer o) {
        ls.add(o);
    }

    public Integer first() {
        if (isEmpty()) {return null;}
        return ls.get(0);
    }

    public Integer poll() {
        if(isEmpty()){return null;}
        Integer firstEntry = ls.get(0);
        ls.remove(0);
        return firstEntry;
    }

    public void addAll(List<Integer> neighbors) {
        ls.addAll(neighbors);
    }

    // this presents time complexity issues for large number of nodes
    public void removeAll(Set<Integer> nodesToRemove) {
        for (Integer node : nodesToRemove) {
            if (ls.contains(node)) {
                Integer index = ls.indexOf(node);
                ls.remove(index);
            }
        }
    }
}

//Initializes fixed length list 
public static Integer[] initializeFixedIntArray(Integer len){
    Integer[] iArr = new Integer[len];
    for(Integer i = 0; i < len; i++){
      iArr[i] = 0;
    }
    return iArr;
  }


}
