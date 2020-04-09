@isTest
public class HopcroftKarpBipartiteMatchingTest {
  /*
   * Test matches people with a chore. Certain people can only be matched with specific
   * tasks as denoted by preferredTasks
   */
  @isTest
  private static void testSimple() {
    // Partition 1 of disjoint sets (people)
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

    // Partition 2 of disjoint sets (chores)
    Set<String> tasks = new Set<String>{
      'wash dishes',
      'vacuum',
      'do laundry',
      'sweep',
      'mop',
      'dust',
      'iron',
      'take out trash'
    };

    //Allowed Matchings
    Map<String, Set<String>> preferredTasks = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'wash dishes', 'sweep' },
      'Emily' => new Set<String>{ 'iron', 'do laundry', 'dust' },
      'John' => new Set<String>{ 'vacuum', 'mop', 'sweep' },
      'Luke' => new Set<String>{ 'iron', 'vacuum', 'take out trash' },
      'Timothy' => new Set<String>{ 'iron', 'dust', 'mop' },
      'Anna' => new Set<String>{ 'do laundry', 'dust' },
      'Raj' => new Set<String>{ 'dust', 'iron' },
      'Dustin' => new Set<String>{ 'take out trash' }
    };

    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(
      people,
      tasks,
      preferredTasks
    );

    // Return Set of matched vertices using H-K Algorithm
    Map<String, String> matches = alg.getMatching();

    System.assert(true, matches.containsKey('Emily'));
    System.assertEquals('iron', matches.get('Emily'));

    //handle results
    for (String vertex : matches.keySet()) {
      if (people.contains(vertex)) {
        System.debug(vertex + ' will ' + matches.get(vertex));
        people.remove(vertex);
        continue;
      }
      tasks.remove(vertex);
    }

    System.assertEquals(0, people.size());
    System.assertEquals(0, tasks.size());
  }

  /**
   * Test ExpandedHopcroftKarpBipartiteMatching
   */
  @isTest
  private static void testResourceAllocation() {
    // Partition 2 of disjoint sets (Hungry People)
    Map<String, Integer> people = new Map<String, Integer>{
      'Billy' => 2, //bill is a hungry boy. eats two wash dishes
      'Emily' => 1,
      'John' => 1,
      'Luke' => 1,
      'Timothy' => 1,
      'Anna' => 1,
      'Raj' => 1,
      'Dustin' => 1
    };

    // Partition 1 of disjoint sets (Menu items available => one each)
    Map<String, Integer> protein = new Map<String, Integer>{
      'steak' => 3,
      'chicken' => 2,
      'fish' => 2,
      'tofu' => 1
    };

    //Matchings allowed (Favorite menu items of hungry people)
    Map<String, Set<String>> proteinPreference = new Map<String, Set<String>>{
      'Billy' => new Set<String>{ 'steak', 'chicken' },
      'Emily' => new Set<String>{ 'fish', 'tofu' },
      'John' => new Set<String>{ 'chicken', 'fish' },
      'Luke' => new Set<String>{ 'steak' },
      'Timothy' => new Set<String>{ 'chicken', 'fish', 'tofu' },
      'Anna' => new Set<String>{ 'steak', 'fish' },
      'Raj' => new Set<String>{ 'chicken' },
      'Dustin' => new Set<String>{ 'tofu' }
    };

    ExpandedHopcroftKarpBipartiteMatching alg = new ExpandedHopcroftKarpBipartiteMatching(
      people,
      protein,
      proteinPreference
    );

    // Return Set of matched vertices using H-K Algorithm
    ExpandedHopcroftKarpBipartiteMatching.Result result = alg.getMatching();
    Map<String, Map<String, Integer>> matches = result.matches;
    for (String vertex : matches.keySet()) {
      if (protein.containsKey(vertex)) {
        Map<String, Integer> peopleMatches = matches.get(vertex);
        String[] peopleOutput = new List<String>{};
        for (String person : peopleMatches.keySet()) {
          peopleOutput.add(person + '(' + peopleMatches.get(person) + ')');
        }
        System.debug(
          vertex +
          ' will be had by ' +
          String.join(peopleOutput, ', ')
        );
      }
    }

    System.assertEquals(1, result.unmatched.size());
    for (String s : result.unmatched.keySet()) {
      System.debug(s + ' was unmatched ' + result.unmatched.get(s) + ' times');
    }
  }

  @isTest
  private static void performanceTest() {
    Integer startingHeap = Limits.getHeapSize();

    Integer scaler = 20; // change this to scale test

    Map<String, Integer> subscriptions = new Map<String, Integer>{
      'acme' => 2 * scaler,
      'stark' => 2 * scaler,
      'bell' => 2 * scaler,
      'facebook' => 3 * scaler,
      'google' => 5 * scaler,
      'microsoft' => 7 * scaler,
      'apple' => 1 * scaler,
      'salesforce' => 2 * scaler
    };

    Map<String, Integer> inventory = new Map<String, Integer>{
      'javascript' => 2 * scaler,
      'typescript' => 3 * scaler,
      'react' => 3 * scaler,
      'nextjs' => 3 * scaler,
      'java' => 3 * scaler,
      'python' => 5 * scaler,
      'apex' => 3 * scaler,
      'angular' => 1 * scaler,
      'webpack' => 2 * scaler,
      'php' => 1 * scaler,
      'ruby' => 5 * scaler,
      'xml' => 7 * scaler
    };

    Map<String, Set<String>> subAllowedInvMap = new Map<String, Set<String>>{
      'acme' => new Set<String>{ 'javascript', 'typescript' },
      'stark' => new Set<String>{ 'javascript', 'typescript' },
      'bell' => new Set<String>{ 'javascript' },
      'facebook' => new Set<String>{
        'javascript',
        'typescript',
        'react',
        'nextjs'
      },
      'google' => new Set<String>{ 'typescript', 'angular', 'webpack' },
      'microsoft' => new Set<String>{ 'php', 'ruby', 'angular', 'webpack' },
      'apple' => new Set<String>{ 'javascript', 'xml', 'python', 'nextjs' },
      'salesforce' => new Set<String>{ 'apex', 'java', 'python' }
    };

    System.debug('Setting Up Graph...');
    Integer startTime = Limits.getCpuTime();

    ExpandedHopcroftKarpBipartiteMatching alg = new ExpandedHopcroftKarpBipartiteMatching(
      subscriptions,
      inventory,
      subAllowedInvMap
    );

    Integer graphHeap = Limits.getHeapSize() - startingHeap;

    Integer stopTime = Limits.getCpuTime();
    System.debug('Finished! ' + (stopTime - startTime) + 'ms');
    System.debug('Graph Heap: ' + (graphHeap - startingHeap));

    System.debug('Running Matching...');
    startTime = Limits.getCpuTime();

    ExpandedHopcroftKarpBipartiteMatching.Result result = alg.getMatching();

    stopTime = Limits.getCpuTime();
    System.debug('Finished! ' + (stopTime - startTime) + 'ms');
    System.debug(
      'Remaining Heap: ' + (Limits.getLimitHeapSize() - Limits.getHeapSize())
    );

    Map<String, Map<String, Integer>> matches = result.matches;
    for (String vertex : matches.keySet()) {
      if (inventory.containsKey(vertex)) {
        Map<String, Integer> peopleMatches = matches.get(vertex);
        String[] peopleOutput = new List<String>{};
        for (String person : peopleMatches.keySet()) {
          peopleOutput.add(person + '(' + peopleMatches.get(person) + ')');
        }
        System.debug(
          vertex +
          ' will be had by ' +
          String.join(peopleOutput, ', ')
        );
      }
    }

    for (String s : result.unmatched.keySet()) {
      System.debug(s + ' was unmatched ' + result.unmatched.get(s) + ' times');
    }
  }
}
