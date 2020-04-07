@isTest
public with sharing class TempTests {
  /*
   * Test matches name(subscriptions) with a number(inventory). Certain names can only be matched with specific
   * numbers as denoted by subAllowedInvMap. In this case, every name should be matched with a number.
   */
  @isTest
  private static void testSimple() {
    // Map key = item, value = number of items
    Set<String> partition1 = new Set<String>();
    partition1.add('one');
    partition1.add('two');
    partition1.add('three');
    partition1.add('four');
    partition1.add('five');
    partition1.add('six');
    partition1.add('seven');

    // Set key = customer name, value = number of "subscriptions" or vertices/customer
    Set<String> partition2 = new Set<String>();
    partition2.add('Billy');
    partition2.add('Emily');
    partition2.add('John');
    partition2.add('Luke');
    partition2.add('Timothy');
    partition2.add('Anna');
    partition2.add('Raj');

    //Matchings allowed
    Map<String, Set<String>> possibleEdges = new Map<String, Set<String>>();
    possibleEdges.put('Billy', new Set<String>{ 'one', 'four' });
    possibleEdges.put('Emily', new Set<String>{ 'seven', 'three', 'six' });
    possibleEdges.put('John', new Set<String>{ 'two', 'five', 'four' });
    possibleEdges.put('Luke', new Set<String>{ 'seven', 'two' });
    possibleEdges.put('Timothy', new Set<String>{ 'seven', 'six', 'five' });
    possibleEdges.put('Anna', new Set<String>{ 'three', 'six' });
    possibleEdges.put('Raj', new Set<String>{ 'six', 'seven' });

    Integer stopTime = Limits.getCpuTime();
    System.debug('Inventory Vertex Count: ' + partition1.size());
    System.debug('Subscription Vertex Count: ' + partition2.size());

    System.debug('Running Matching...');

    // Creates new instance of HKPM with parameters (Set<partition1>, Set<partition1>, Map<vertex, Set<possibleVertices>>)  )
    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      partition2,
      partition1,
      possibleEdges
    );

    // Return Set of mathed vertices using H-K Algorithm
    Set<String> matches = alg.getMatching();
    for (String edge : matches) {
      if (edge != null) {
        String[] vertexs = edge.split(':', 2);
        partition2.remove(vertexs[0]);
        partition1.remove(vertexs[1]);
      }
    }

    System.debug('=== Unmatched Subscriptions ===');
    System.assertEquals(0, partition2.size());
    System.debug(partition2);

    System.debug('=== Unmatched Inventory ===');
    System.assertEquals(0, partition1.size());
    System.debug(partition2);

    System.debug('=== Matched ===');
    System.assert(true, matches.contains('Emily:seven'));
    for (String match : matches) {
      System.debug('Matched: ' + match);
    }
  }
}
