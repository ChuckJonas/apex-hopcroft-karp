@isTest
public with sharing class HopcroftKarpBipartiteMatchingTest {
  /*
   * Test matches people with a Dish. Certain people can only be matched with specific
   * dishes as denoted by favoriteDishes. In this case, every name should be matched with a number.
   */
  @isTest
  private static void testSimple() {
    // Partition 2 of disjoint sets (Hungry People)
    Set<String> people = new Set<String>{
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
    Set<String> dishes = new Set<String>{
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
    Map<String, Set<String>> favoriteDishes = new Map<String, Set<String>>{
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
    System.debug('Inventory Vertex Count: ' + people.size());
    System.debug('Subscription Vertex Count: ' + dishes.size());

    System.debug('Running Matching...');

    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      people,
      dishes,
      favoriteDishes
    );

    // Return Set of matched vertices using H-K Algorithm
    Map<String, String> matches = alg.getMatching();

    System.debug('=== Matched ===');
    System.assert(true, matches.containsKey('Emily'));
    System.assertEquals('steak', matches.get('Emily'));

    for (String vertex : matches.keySet()) {
      if (people.contains(vertex)) {
        System.debug(vertex + ' will have ' + matches.get(vertex));
      }
    }

    //Remove matched from partition lists
    for (String vertex : matches.keySet()) {
      people.remove(vertex);
      dishes.remove(vertex);
    }

    System.debug('=== Unmatched People ===');
    System.assertEquals(1, people.size());
    for (String person : people) {
      System.debug('No dish left for ' + person);
    }

    System.debug('=== Unmatched Food ===');
    System.assertEquals(1, dishes.size());
    for (String food : dishes) {
      System.debug('No one is having ' + food.capitalize());
    }
  }
}
