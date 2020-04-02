@isTest
public with sharing class TempTests {


  // Account acc = new Account();
  // Object b = acc;
  // Account acc2 = (Account) b;

  // List<Account> accList = new List<Account>();
  // List<Object> objList = accList;
  // Iterator<Object> itrFromObjL = objList.iterator(); //compiles

  // Iterator<Object> itrFromAccountL = accList.iterator();
  // //Illegal assignment from System.ListIterator<Account> to System.Iterator<Object>


  // // Iterator<Object> iterFromCast = (Iterator<Object>) l.iterator(); // doesn't compile

  @isTest
  private static void testOptimized(){
      Integer startingHeap = Limits.getHeapSize();

      Integer scaler = 40;

      System.debug('Optimized Test with scaler of ' + scaler);
      Graph graph = new Multigraph();
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
                graph.addVertex(id);
            }
            inventorySet.addAll(tmp);
            inventoryClonedVertex.put(invKey, tmp);
        }

        Integer edgeCount = 0;
        //create a vertex to represent each 'bundle' of inventory purchased.  EG acme-1, acme-2
        Set<String> subscriptionSet = new Set<String>();
        for(String subKey : subscriptions.keySet()){
            Integer bundles = subscriptions.get(subKey)* scaler;
            for(Integer i = 0; i < bundles ; i++){
                String subId = subKey + '-' + i;
                subscriptionSet.add(subId);
                graph.addVertex(subId);

                //create edges between each sub bundle and what they can purchase...
                //[optimize by tracking map of all inventory vertex by invKey]
                for(String invKey : subAllowedInvMap.get(subKey)){
                    if(inventoryClonedVertex.containsKey(invKey)){
                      String[] inventoryClonedVertexs = inventoryClonedVertex.get(invKey);
                      edgeCount += inventoryClonedVertexs.size();
                      for(String invVertex : inventoryClonedVertexs){
                        graph.addEdge(subId, invVertex);
                      }
                    }
                }
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

        // System.debug(JSON.serialize(graph));
        System.assert(graph.containsVertex('acme-0'));
        System.assert(graph.containsVertex('acme-1'));
        System.assert(graph.containsVertex('javascript-0'));
        System.assert(graph.containsVertex('typescript-0'));

        System.assertNotEquals(null, graph.getEdge('acme-0', 'javascript-0'));
        System.assertNotEquals(null, graph.getEdge('acme-1', 'javascript-0'));

        System.assertNotEquals(null, graph.getEdge('acme-0', 'typescript-0'));
        System.assertNotEquals(null, graph.getEdge('acme-1', 'typescript-0'));

        // System.assertEquals(2, Graphs.neighborListOf(graph, 'acme-0').size());

        System.debug('Running Matching...');
        startTime = Limits.getCpuTime();
        HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(graph, subscriptionSet, inventorySet);
        Matching matches = alg.getMatching();
        stopTime = Limits.getCpuTime();
        System.debug('Finished! ' + (stopTime - startTime) + 'ms');
        System.debug('Remaining Heap: ' + (Limits.getLimitHeapSize() - Limits.getHeapSize()));
        for(Edge edge : matches.getEdges()){
          subscriptionSet.remove(edge.source);
          inventorySet.remove(edge.target);
        }
        System.debug('=== Unmatched Subscriptions ===');
        System.assertEquals(4 * scaler, subscriptionSet.size());
        System.debug(subscriptionSet);

        System.debug('=== Unmatched Inventory ===');
        System.assertEquals(18 * scaler, inventorySet.size());
        System.debug(inventorySet);

  }

  @isTest
  private static void test(){
      Integer scaler = 29;
      System.debug('OG Test with scaler of ' + scaler);

      Graph graph = new Multigraph();
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
        Set<String> inventorySet = new Set<String>();
        for(String invKey : inventory.keySet()){
            Integer bundles = inventory.get(invKey);
            for(Integer i = 0; i < bundles * scaler; i++){
                String id = invKey + '-' + i;
                inventorySet.add(id);
                graph.addVertex(id);
            }
        }

        Integer edgeCount = 0;
        //create a vertex to represent each 'bundle' of inventory purchased.  EG acme-1, acme-2
        Set<String> subscriptionSet = new Set<String>();
        for(String subKey : subscriptions.keySet()){
            Integer bundles = subscriptions.get(subKey);
            for(Integer i = 0; i < bundles * scaler; i++){
                String subId = subKey + '-' + i;
                subscriptionSet.add(subId);
                graph.addVertex(subId);

                //create edges between each sub bundle and what they can purchase...
                //[optimize by tracking map of all inventory vertex by invKey]
                for(String invKey : subAllowedInvMap.get(subKey)){
                    Integer invBundles = inventory.get(invKey);
                    for(Integer j = 0; j < invBundles * scaler; j++){
                        edgeCount++;
                        String invId = invKey + '-' + j;
                        graph.addEdge(subId, invId);
                    }
                }
            }
        }

        Integer stopTime = Limits.getCpuTime();
        System.debug('Finished! ' + (stopTime - startTime) + 'ms');
        System.debug('Inventory Vertex Count: ' + inventorySet.size());
        System.debug('Subscription Vertex Count: ' + subscriptionSet.size());

        System.debug('Edge Count: ' + edgeCount);

        // System.debug(JSON.serialize(graph));
        System.assert(graph.containsVertex('acme-0'));
        System.assert(graph.containsVertex('acme-1'));
        System.assert(graph.containsVertex('javascript-0'));
        System.assert(graph.containsVertex('typescript-0'));

        System.assertNotEquals(null, graph.getEdge('acme-0', 'javascript-0'));
        System.assertNotEquals(null, graph.getEdge('acme-1', 'javascript-0'));

        System.assertNotEquals(null, graph.getEdge('acme-0', 'typescript-0'));
        System.assertNotEquals(null, graph.getEdge('acme-1', 'typescript-0'));

        // System.assertEquals(2, Graphs.neighborListOf(graph, 'acme-0').size());

        System.debug('Running Matching...');
        startTime = Limits.getCpuTime();
        HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(graph, subscriptionSet, inventorySet);
        Matching matches = alg.getMatching();
        stopTime = Limits.getCpuTime();
        System.debug('Finished! ' + (stopTime - startTime) + 'ms');
        for(Edge edge : matches.getEdges()){
          subscriptionSet.remove(edge.source);
          inventorySet.remove(edge.target);
        }
        System.debug('=== Unmatched Subscriptions ===');
        System.assertEquals(4 * scaler, subscriptionSet.size());
        System.debug(subscriptionSet);

        System.debug('=== Unmatched Inventory ===');
        System.assertEquals(18 * scaler, inventorySet.size());
        System.debug(inventorySet);
  }
}
