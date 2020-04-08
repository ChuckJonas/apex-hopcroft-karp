@isTest
public with sharing class HopcroftKarpBipartiteMatchingTest {
  /*
   * Test matches name(subscriptions) with a number(inventory). Certain names can only be matched with specific
   * numbers as denoted by subAllowedInvMap. In this case, every name should be matched with a number.
   */
  @isTest
  private static void testSimple() {
    // Partition 2 of disjoint sets (Hungry People)
    Set<String> partition1 = new Set<String>{
      'Billy',
      'Emily',
      'John',
      'Luke',
      'Timothy',
      'Anna',
      'Raj',
      'Dustin'
    };

    // Partition 1 of disjoint sets (Menu items available => one each)
    Set<String> partition2 = new Set<String>{
      'tacos',
      'pizza',
      'chili',
      'pasta',
      'burger',
      'wrap',
      'steak',
      'pho'
    };

    //Matchings allowed (Favorite menu items of hungry people)
    Map<String, Set<String>> possibleEdges = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'tacos', 'pasta' },
      'Emily' => new Set<String>{ 'steak', 'chili', 'wrap' },
      'John' => new Set<String>{ 'pizza', 'burger', 'pasta' },
      'Luke' => new Set<String>{ 'steak', 'pizza' },
      'Timothy' => new Set<String>{ 'steak', 'wrap', 'burger' },
      'Anna' => new Set<String>{ 'chili', 'wrap' },
      'Raj' => new Set<String>{ 'wrap', 'steak' },
      'Dustin' => new Set<String>{ 'steak' }
    };

    Integer stopTime = Limits.getCpuTime();
    System.debug('Inventory Vertex Count: ' + partition1.size());
    System.debug('Subscription Vertex Count: ' + partition2.size());

    System.debug('Running Matching...');

    // Creates new instance of HKPM with parameters (Set<partition1>, Set<partition1>, Map<vertex, Set<possibleVertices>>)  )
    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      partition1,
      partition2,
      possibleEdges
    );

    // Return Set of mathed vertices using H-K Algorithm
    Map<String, String> matches = alg.getMatching();

    System.debug('=== Matched ===');
    System.assert(true, matches.containsKey('Emily'));
    System.assertEquals('steak', matches.get('Emily'));

    for (String match : matches.keySet()) {
      if (partition1.contains(match)) {
        System.debug(match + ' will have ' + matches.get(match));
      } else {
        System.debug(
          'People having ' +
          match.capitalize() +
          ': ' +
          matches.get(match)
        );
      }
    }

    //Remove matched from partition list
    for (String vertex : matches.keySet()) {
      partition1.remove(vertex);
      partition2.remove(matches.get(vertex));
    }

    System.debug('=== Unmatched People ===');
    System.assertEquals(1, partition1.size());
    for (String person : partition1) {
      System.debug('No dish left for ' + person);
    }

    System.debug('=== Unmatched Food ===');
    System.assertEquals(1, partition2.size());
    for (String food : partition2) {
      System.debug('No one is having ' + food.capitalize());
    }
  }

  @isTest
  private static void testOptimized() {
    Integer startingHeap = Limits.getHeapSize();

    Integer scaler = 43;

    System.debug('Optimized Test with scaler of ' + scaler);

    Map<String, Integer> inventory = new Map<String, Integer>();
    inventory.put('javascript', 2);
    inventory.put('typescript', 3);
    inventory.put('react', 3);
    inventory.put('nextjs', 3);
    inventory.put('java', 3);
    inventory.put('python', 5);
    inventory.put('apex', 3);
    inventory.put('angular', 1);
    inventory.put('webpack', 2);
    inventory.put('php', 1);
    inventory.put('ruby', 5);
    inventory.put('xml', 7);

    Map<String, Integer> subscriptions = new Map<String, Integer>();
    subscriptions.put('acme', 2);
    subscriptions.put('stark', 2);
    subscriptions.put('bell', 2);
    subscriptions.put('facebook', 3);
    subscriptions.put('google', 5);
    subscriptions.put('microsoft', 7);
    subscriptions.put('apple', 1);
    subscriptions.put('salesforce', 2);

    Map<String, List<String>> subAllowedInvMap = new Map<String, List<String>>();
    subAllowedInvMap.put(
      'acme',
      new List<String>{ 'javascript', 'typescript' }
    );
    subAllowedInvMap.put(
      'stark',
      new List<String>{ 'javascript', 'typescript' }
    );
    subAllowedInvMap.put('bell', new List<String>{ 'javascript' });
    subAllowedInvMap.put(
      'facebook',
      new List<String>{ 'javascript', 'typescript', 'react', 'nextjs' }
    );
    subAllowedInvMap.put(
      'google',
      new List<String>{ 'typescript', 'angular', 'webpack' }
    );
    subAllowedInvMap.put(
      'microsoft',
      new List<String>{ 'php', 'ruby', 'angular', 'webpack' }
    );
    subAllowedInvMap.put(
      'apple',
      new List<String>{ 'javascript', 'xml', 'python', 'nextjs' }
    );
    subAllowedInvMap.put(
      'salesforce',
      new List<String>{ 'apex', 'java', 'python' }
    );

    System.debug('Setting Up Graph...');
    Integer startTime = Limits.getCpuTime();

    //create a vertex to represent each 'bundle' of inventory.  EG javascript-1, javascript-2

    // Stores vertexs by inventory group
    Map<String, String[]> inventoryClonedVertex = new Map<String, String[]>();

    Set<String> inventorySet = new Set<String>();
    for (String invKey : inventory.keySet()) {
      Integer bundles = inventory.get(invKey) * scaler;
      String[] tmp = new List<String>(bundles);
      for (Integer i = 0; i < bundles; i++) {
        String id = invKey + '-' + i;
        tmp[i] = id;
      }
      inventorySet.addAll(tmp);
      inventoryClonedVertex.put(invKey, tmp);
    }

    Integer edgeCount = 0;
    Map<String, Set<String>> edges = new Map<String, Set<String>>();
    //create a vertex to represent each 'bundle' of inventory purchased.  EG acme-1, acme-2
    Set<String> subscriptionSet = new Set<String>();
    for (String subKey : subscriptions.keySet()) {
      Integer bundles = subscriptions.get(subKey) * scaler;
      for (Integer i = 0; i < bundles; i++) {
        String subId = subKey + '-' + i;
        subscriptionSet.add(subId);

        //create edges between each sub bundle and what they can purchase...
        //[optimize by tracking map of all inventory vertex by invKey]
        Set<String> invVertices = new Set<String>();
        for (String invKey : subAllowedInvMap.get(subKey)) {
          if (inventoryClonedVertex.containsKey(invKey)) {
            String[] inventoryClonedVertexs = inventoryClonedVertex.get(invKey);
            edgeCount += inventoryClonedVertexs.size();
            for (String invVertex : inventoryClonedVertexs) {
              invVertices.add(invVertex);
            }
          }
        }
        edges.put(subId, new Set<String>(invVertices));
      }
    }

    Integer graphHeap = Limits.getHeapSize() - startingHeap;

    Integer stopTime = Limits.getCpuTime();
    System.debug('Finished! ' + (stopTime - startTime) + 'ms');
    System.debug('Inventory Vertex Count: ' + inventorySet.size());
    System.debug('Subscription Vertex Count: ' + subscriptionSet.size());

    System.debug('Edge Count: ' + edgeCount);
    // add data to heap

    System.debug('Graph Heap: ' + (graphHeap - startingHeap));

    System.debug('Running Matching...');
    startTime = Limits.getCpuTime();
    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      subscriptionSet,
      inventorySet,
      edges
    );

    Map<String, String> matches = alg.getMatching();
    stopTime = Limits.getCpuTime();
    System.debug('Finished! ' + (stopTime - startTime) + 'ms');
    System.debug(
      'Remaining Heap: ' + (Limits.getLimitHeapSize() - Limits.getHeapSize())
    );
    for (String edge : matches.keySet()) {
      if (edge != null) {
        subscriptionSet.remove(edge);
        inventorySet.remove(matches.get(edge));
      }
    }
    System.debug('=== Unmatched Subscriptions ===');
    System.assertEquals(4 * scaler, subscriptionSet.size());
    System.debug(subscriptionSet);

    System.debug('=== Unmatched Inventory ===');
    System.assertEquals(18 * scaler, inventorySet.size());
    System.debug(inventorySet);
  }
}