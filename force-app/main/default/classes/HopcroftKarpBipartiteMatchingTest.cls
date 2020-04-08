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
}
