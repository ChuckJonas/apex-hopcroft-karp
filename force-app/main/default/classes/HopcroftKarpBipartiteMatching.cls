/*
 * @author Chuck Jonas (charlie@callaway.cloud) and Dustin Kovac
 *
 * Derived from: JGraphT
 * (C) Copyright 2017-2020, by Joris Kinable and Contributors.
 * https://github.com/jgrapht
 */
public class HopcroftKarpBipartiteMatching {
  private Set<String> partition1;
  private Set<String> partition2;

  /* Ordered list of vertices */
  private List<String> vertices;
  /* Mapping of a vertex to their unique position in the ordered list of vertices */
  private Map<String, Integer> vertexIndexMap;

  /* Number of matched vertices i partition 1. */
  private Integer matchedVertices = 0;

  /* Dummy vertex. All vertices are initially matched against this dummy vertex */
  private final Integer DUMMY = 0;

  private static final String LOOPS_NOT_ALLOWED = 'loops not allowed';
  private static final String INVALID_VERTEX = 'Invalid Vertex';

  /* Infinity */
  private final Integer INF = 999999999;

  /* Array keeping track of the matching. */
  private Integer[] matching;
  /* Distance array. Used to compute shoretest augmenting paths */
  private Integer[] dist;

  /* queue used for breadth first search */
  private Queue queue;

  //graph data
  private Set<String> edgeSet;
  private Map<String, Set<String>> vertexMap;

  /**
   * Constructor
   * @param partition1 Set 1 of two disjoint sets
   * @param partition2 Set 2 of two disjoint sets
   * @param edgeMap    Map containing all possible matchings. Edges are undirected (you only need to include one direction)
   */
  public HopcroftKarpBipartiteMatching(
    Set<String> partition1,
    Set<String> partition2,
    Map<String, Set<String>> edgeMap
  ) {
    this.vertexMap = new Map<String, Set<String>>();
    for (String part : partition1) {
      addVertex(part);
    }
    for (String part : partition2) {
      addVertex(part);
    }
    this.edgeSet = new Set<String>();

    for (String vert1 : edgeMap.KeySet()) {
      for (String vert2 : edgeMap.get(vert1)) {
        addEdge(vert1, vert2);
      }
    }

    if (partition1.size() <= partition2.size()) {
      this.partition1 = partition1;
      this.partition2 = partition2;
    } else {
      // else, swap
      this.partition1 = partition2;
      this.partition2 = partition1;
    }
  }

  /**
   * This method uses the Hopcroft-Karp matching algorithm to return a
   * matches with maximal cardinality.
   * @return Map<String,String> of all matches (include vertices from both partitions)
   */
  public virtual Map<String, String> getMatching() {
    this.init();
    this.warmStart();

    while (matchedVertices < partition1.size() && bfs()) {
      // Greedily search for vertex disjoint augmenting paths
      for (
        Integer v = 1;
        v <= partition1.size() &&
        matchedVertices < partition1.size();
        v++
      ) {
        if (
          matching[v] == DUMMY // v is unmatched
        ) {
          if (dfs(v)) {
            matchedVertices++;
          }
        }
      }
    }
    system.assert(matchedVertices <= partition1.size());

    Map<String, String> edges = new Map<String, String>();
    for (Integer i = 0; i < vertices.size(); i++) {
      if (matching[i] != DUMMY) {
        edges.put(vertices.get(i), vertices.get(matching[i]));
      }
    }
    return edges;
  }

  /**
   * Initialize data structures
   */
  private void init() {
    vertices = new List<String>();
    vertices.add(null);
    vertices.addAll(partition1);
    vertices.addAll(partition2);
    vertexIndexMap = new Map<String, Integer>();
    for (Integer i = 0; i < vertices.size(); i++)
      vertexIndexMap.put(vertices.get(i), i);

    matching = initializeFixedIntArray(vertices.size() + 1);
    dist = initializeFixedIntArray(partition1.size() + 1);
    queue = new Queue(vertices.size());
  }

  /**
   * Greedily compute an initial feasible matching
   */
  private void warmStart() {
    for (String uOrig : partition1) {
      Integer u = vertexIndexMap.get(uOrig);
      for (String vOrig : neighborListOf(uOrig)) {
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

  //MultiGraph Methods
  private void addEdge(String sourceVertex, String targetVertex) {
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

  private List<String> neighborListOf(String vertex) {
    if (!vertexMap.containsKey(vertex)) {
      throw new IllegalArgumentException(INVALID_VERTEX);
    }
    List<String> neighbors = new List<String>();

    for (String oppV : vertexMap.get(vertex)) {
      neighbors.add(oppV);
    }

    return neighbors;
  }

  private boolean addVertex(String v) {
    if (v == null) {
      throw new NullPointerException();
    } else if (vertexMap.containsKey(v)) {
      return false;
    } else {
      Set<String> ec = vertexMap.get(v);
      if (ec == null) {
        vertexMap.put(v, new Set<String>());
      }
      return true;
    }
  }

  private boolean assertVertexExist(String v) {
    if (vertexMap.containsKey(v)) {
      return true;
    } else if (v == null) {
      throw new NullPointerException();
    } else {
      throw new IllegalArgumentException('no such vertex in graph: ' + v);
    }
  }

  //Breadth-First Search Algorithm
  private boolean bfs() {
    queue.clear();

    for (Integer u = 1; u <= partition1.size(); u++)
      if (matching[u] == DUMMY) {
        // Add all unmatched vertices to the queue and set their
        // distance to 0
        dist[u] = 0;
        queue.enqueue(u);
      } else
        // Set distance of all matched vertices to INF
        dist[u] = INF;
    dist[DUMMY] = INF;

    while (!queue.isEmpty()) {
      Integer u = queue.poll();
      if (dist[u] < dist[DUMMY])
        for (String vOrig : neighborListOf(vertices.get(u))) {
          Integer v = vertexIndexMap.get(vOrig);
          if (dist[matching[v]] == INF) {
            dist[matching[v]] = dist[u] + 1;
            queue.enqueue(matching[v]);
          }
        }
    }
    return dist[DUMMY] != INF; // Return true if an augmenting path is found
  }

  //Depth-First Search Algorithm
  private boolean dfs(Integer u) {
    if (u != DUMMY) {
      for (String vOrig : neighborListOf(vertices.get(u))) {
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

  //Initializes fixed length list
  private static Integer[] initializeFixedIntArray(Integer len) {
    Integer[] iArr = new List<Integer>(len);
    for (Integer i = 0; i < len; i++) {
      iArr[i] = 0;
    }
    return iArr;
  }

  //Constructs a fixed sixed queue
  private class Queue {
    private List<Integer> ls;
    public Queue() {
      ls = new List<Integer>();
    }

    public Queue(Integer size) {
      ls = initializeFixedIntArray(size);
    }

    public Integer size() {
      return ls.size();
    }

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
      if (isEmpty()) {
        return null;
      }
      return ls.get(0);
    }

    public Integer poll() {
      if (isEmpty()) {
        return null;
      }
      Integer firstEntry = ls.get(0);
      ls.remove(0);
      return firstEntry;
    }

    public void addAll(List<Integer> neighbors) {
      ls.addAll(neighbors);
    }
  }
}
