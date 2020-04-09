/**
 * Class that make it easy to use the H-K matching to run "Resource Allocation" matching.
 *   Each vertex gets an integer which represents the number of times it can be matched.
 *   NOTE: Optimized for "developer friendly-ness".  Not optimal performance.
 * @Author: Charlie Jonas (charlie@callaway.cloud)
 */
public class ExpandedHopcroftKarpBipartiteMatching {
  private HopcroftKarpBipartiteMatching matching;

  // used to track and return useful results
  private Map<String, Integer> partition1;
  private Map<String, Integer> partition2;
  private Map<String, String> reverseVertexLookupMap = new Map<String, String>();

  /**
   * Constructor
   * @param partition1 Map where key is the vertex and value is the number of times it should be added to the graph
   * @param partition2 Map where key is the vertex and value is the number of times it should be added to the graph
   * @param edgeMap    Map containing all possible matchings. Edges are undirected (you only need to include one direction)
   */
  public ExpandedHopcroftKarpBipartiteMatching(
    Map<String, Integer> partition1,
    Map<String, Integer> partition2,
    Map<String, Set<String>> edgeMap
  ) {
    this.partition1 = partition1;
    this.partition2 = partition2;

    Map<String, Set<String>> rightVertexExpansionMap = new Map<String, Set<String>>();
    Set<String> rightPartition = new Set<String>();
    for (String part : partition2.keySet()) {
      Set<String> expanded = new Set<String>();
      for (Integer i = 0; i < partition2.get(part); i++) {
        String vertexKey = part + '-' + i;
        reverseVertexLookupMap.put(vertexKey, part);
        expanded.add(vertexKey);
      }
      rightPartition.addAll(expanded);
      rightVertexExpansionMap.put(part, expanded);
    }

    Map<String, Set<String>> expandedEdgeMap = new Map<String, Set<String>>();
    for (String part : partition1.keySet()) {
      Set<String> edges = edgeMap.get(part);
      for (Integer i = 0; i < partition1.get(part); i++) {
        String vertexKey = part + '-' + i;
        reverseVertexLookupMap.put(vertexKey, part);
        Set<String> expandedEdges = new Set<String>();
        if (edges != null) {
          for (String edge : edges) {
            expandedEdges.addAll(rightVertexExpansionMap.get(edge));
          }
        }
        expandedEdgeMap.put(vertexKey, expandedEdges);
      }
    }

    matching = new HopcroftKarpBipartiteMatching(
      expandedEdgeMap.keySet(),
      rightPartition,
      expandedEdgeMap
    );
  }

  /**
   * @returns a result which contains both the matches and the unmatched vertices
   */
  public Result getMatching() {
    Map<String, String> matches = matching.getMatching();
    Result result = new Result();
    result.matches = new Map<String, Map<String, Integer>>();
    result.unmatched = new Map<String, Integer>();

    result.unmatched.putAll(partition1);
    result.unmatched.putAll(partition2);

    for (String match : matches.keySet()) {
      String v1 = reverseVertexLookupMap.get(match);
      String v2 = reverseVertexLookupMap.get(matches.get(match));

      if (result.matches.containsKey(v1)) {
        Map<String, Integer> edgeCounts = result.matches.get(v1);
        Integer count = edgeCounts.get(v2);
        if (count == null) {
          count = 0;
        }
        edgeCounts.put(v2, count + 1);
      } else {
        result.matches.put(v1, new Map<String, Integer>{ v2 => 1 });
      }
      result.unmatched.put(v1, result.unmatched.get(v1) - 1);
      if (result.unmatched.get(v1) == 0) {
        result.unmatched.remove(v1);
      }
    }
    return result;
  }

  /**
   * Class for returning results
   * @property matches: Vertex => Vertex => number of matches
   * @property unmatched: Vertex => remainder
   */
  public class Result {
    public Map<String, Map<String, Integer>> matches;
    public Map<String, Integer> unmatched;
  }
}
