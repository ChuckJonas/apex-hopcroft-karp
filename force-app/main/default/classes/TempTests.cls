@isTest
public with sharing class TempTests {
  /*
  * Test matches name(subscriptions) with a number(inventory). Certain names can only be matched with specific
  * numbers as denoted by subAllowedInvMap. In this case, every name should be matched with a number.
  */
  @isTest
  private static void testSimple() {


    Map<String, Integer> inventory = new Map<String, Integer> ();
      inventory.put('one', 1);
      inventory.put('two', 1);
      inventory.put('three', 1);
      inventory.put('four', 1);
      inventory.put('five', 1);
      inventory.put('six', 1);
      inventory.put('seven', 1);
        

    Map<String, Integer> subscriptions = new Map<String, Integer> ();
      subscriptions.put('Billy', 1);
      subscriptions.put('Emily', 1);
      subscriptions.put('John', 1);
      subscriptions.put('Luke', 1);
      subscriptions.put('Timothy', 1);
      subscriptions.put('Anna', 1);
      subscriptions.put('Raj', 1);

        //Matchings allowed
    Map<String, List<String>> subAllowedInvMap = new Map<String, List<String>> ();
      subAllowedInvMap.put('Billy', new String[]{'one','four'});
      subAllowedInvMap.put('Emily', new String[]{'seven','three', 'six'});
      subAllowedInvMap.put('John', new String[]{'two','five','four'});
      subAllowedInvMap.put('Luke', new String[]{'seven','two'});
      subAllowedInvMap.put('Timothy', new String[]{'seven', 'six', 'five'});
      subAllowedInvMap.put('Anna', new String[]{'three', 'six'});
      subAllowedInvMap.put('Raj', new String[]{'six', 'seven'});

    Map<String, String[]> inventoryClonedVertex = new Map<String, String[]>();

    Set<String> inventorySet = new Set<String>();
    for(String invKey : inventory.keySet()){
      Integer bundles = inventory.get(invKey);
      String[] tmp = new String[bundles];
      for(Integer i = 0; i < bundles; i++){
        String id = invKey + '-' + i;
        tmp[i] = id;
      }
      inventorySet.addAll(tmp);
      inventoryClonedVertex.put(invKey, tmp);
    }

    Integer edgeCount = 0;
    Map<String, Set<String>> edges = new Map<String, Set<String>>();
    //create a vertex to represent each 'bundle' of inventory purchased. 
    Set<String> subscriptionSet = new Set<String>();
    for(String subKey : subscriptions.keySet()){
      Integer bundles = subscriptions.get(subKey);
      for(Integer i = 0; i < bundles ; i++){
        String subId = subKey + '-' + i;
        subscriptionSet.add(subId);

        //create edges between each sub bundle and what they can purchase...
        //[optimize by tracking map of all inventory vertex by invKey]
        Set<String> invVertices = new Set<String>();
        for(String invKey : subAllowedInvMap.get(subKey)){         
          if(inventoryClonedVertex.containsKey(invKey)){
            String[] inventoryClonedVertexs = inventoryClonedVertex.get(invKey);
            edgeCount += inventoryClonedVertexs.size();
            for(String invVertex : inventoryClonedVertexs){
              invVertices.add(invVertex);
            }
          }
        }
        edges.put(subId, new Set<String>(invVertices));
      }

    }

    Integer stopTime = Limits.getCpuTime();
    System.debug('Inventory Vertex Count: ' + inventorySet.size());
    System.debug('Subscription Vertex Count: ' + subscriptionSet.size());

    System.debug('Edge Count: ' + edgeCount);

    System.debug('Running Matching...');
    HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(subscriptionSet, inventorySet, edges);

    System.assert(alg.containsVertex('Billy-0'));
    System.assert(alg.containsVertex('Emily-0'));
    System.assert(alg.containsVertex('John-0'));
    System.assert(alg.containsVertex('Luke-0'));

    Set<String> matches = alg.getMatching();
    for(String edge : matches){
      if (edge != null) {
        String[] vertexs= edge.split(':', 2);
        subscriptionSet.remove(vertexs[0]);
        inventorySet.remove(vertexs[1]);
      }  
    }


    System.assertNotEquals(null, alg.getEdge('Billy-0', 'one-0'));
    System.assertNotEquals(null, alg.getEdge('Emily-0', 'seven-0'));

    System.debug('=== Unmatched Subscriptions ===');
    System.assertEquals(0, subscriptionSet.size());
    System.debug(subscriptionSet);

    System.debug('=== Unmatched Inventory ===');
    System.assertEquals(0, inventorySet.size());
    System.debug(inventorySet);
    
    System.debug('=== Matched ===');
    for (String match : matches) {
      System.debug('Matched: ' + match);
    }
      
  }


  @isTest
  private static void testOptimized(){
      Integer startingHeap = Limits.getHeapSize();

      Integer scaler = 10; 

      System.debug('Optimized Test with scaler of ' + scaler);
      
      Map<String, Integer> inventory = new Map<String, Integer> ();
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

        Map<String, Integer> subscriptions = new Map<String, Integer> ();
        subscriptions.put('acme', 2);
        subscriptions.put('stark', 2);
        subscriptions.put('bell', 2);
        subscriptions.put('facebook', 3);
        subscriptions.put('google', 5);
        subscriptions.put('microsoft', 7);
        subscriptions.put('apple', 1);
        subscriptions.put('salesforce', 2);


        Map<String, List<String>> subAllowedInvMap = new Map<String, List<String>> ();
        subAllowedInvMap.put('acme', new String[]{'javascript','typescript'});
        subAllowedInvMap.put('stark', new String[]{'javascript','typescript'});
        subAllowedInvMap.put('bell', new String[]{'javascript'});
        subAllowedInvMap.put('facebook', new String[]{'javascript','typescript','react','nextjs'});
        subAllowedInvMap.put('google', new String[]{'typescript', 'angular', 'webpack'});
        subAllowedInvMap.put('microsoft', new String[]{'php', 'ruby', 'angular', 'webpack'});
        subAllowedInvMap.put('apple', new String[]{'javascript', 'xml', 'python', 'nextjs'});
        subAllowedInvMap.put('salesforce', new String[]{'apex', 'java', 'python'});


        System.debug('Setting Up Graph...');
        Integer startTime = Limits.getCpuTime();


        //create a vertex to represent each 'bundle' of inventory.  EG javascript-1, javascript-2

        // Stores vertexs by inventory group
        Map<String, String[]> inventoryClonedVertex = new Map<String, String[]>();

        Set<String> inventorySet = new Set<String>();
        for(String invKey : inventory.keySet()){
            Integer bundles = inventory.get(invKey) * scaler;
            String[] tmp = new String[bundles];
            for(Integer i = 0; i < bundles; i++){
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
        for(String subKey : subscriptions.keySet()){
            Integer bundles = subscriptions.get(subKey)* scaler;
            for(Integer i = 0; i < bundles ; i++){
                String subId = subKey + '-' + i;
                subscriptionSet.add(subId);

                //create edges between each sub bundle and what they can purchase...
                //[optimize by tracking map of all inventory vertex by invKey]
                Set<String> invVertices = new Set<String>();
                for(String invKey : subAllowedInvMap.get(subKey)){
                    if(inventoryClonedVertex.containsKey(invKey)){
                      String[] inventoryClonedVertexs = inventoryClonedVertex.get(invKey);
                      edgeCount += inventoryClonedVertexs.size();
                      for(String invVertex : inventoryClonedVertexs){
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
        HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(subscriptionSet, inventorySet, edges);

        System.assert(alg.containsVertex('acme-0'));
        System.assert(alg.containsVertex('acme-1'));
        System.assert(alg.containsVertex('javascript-0'));
        System.assert(alg.containsVertex('typescript-0'));

        System.assertNotEquals(null, alg.getEdge('acme-0', 'javascript-0'));
        System.assertNotEquals(null, alg.getEdge('acme-1', 'javascript-0'));

        System.assertNotEquals(null, alg.getEdge('acme-0', 'typescript-0'));
        System.assertNotEquals(null, alg.getEdge('acme-1', 'typescript-0'));
        Set<String> matches = alg.getMatching();
        stopTime = Limits.getCpuTime();
        System.debug('Finished! ' + (stopTime - startTime) + 'ms');
        System.debug('Remaining Heap: ' + (Limits.getLimitHeapSize() - Limits.getHeapSize()));
        for(String edge : matches){
          if (edge != null) {
            String[] vertexs= edge.split(':', 2);
            subscriptionSet.remove(vertexs[0]);
            inventorySet.remove(vertexs[1]);
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
