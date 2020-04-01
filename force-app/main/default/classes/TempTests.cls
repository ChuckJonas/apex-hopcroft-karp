@isTest
public with sharing class TempTests {
  @isTest
  private static void test(){

      Integer scaler = 12;

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
                        Edge edge = graph.addEdge(subId, invId);
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

        System.assertNotEquals(graph.getEdge('acme-0', 'javascript-0'), null);
        System.assertNotEquals(graph.getEdge('acme-1', 'javascript-0'), null);

        System.assertNotEquals(graph.getEdge('acme-0', 'typescript-0'), null);
        System.assertNotEquals(graph.getEdge('acme-1', 'typescript-0'), null);

        // System.assertEquals(2, Graphs.neighborListOf(graph, 'acme-0').size());

        System.debug('Running Matching...');
        startTime = Limits.getCpuTime();
        HopcroftKarpBipartiteMatching alg = new HopcroftKarpBipartiteMatching(graph, subscriptionSet, inventorySet);
        Matching matches = alg.getMatching();
        stopTime = Limits.getCpuTime();
        System.debug('Finished! ' + (stopTime - startTime) + 'ms');
        for(Edge edge : matches.getEdges()){
          subscriptionSet.remove(graph.getEdgeSource(edge));
          inventorySet.remove(graph.getEdgeTarget(edge));
        }
        System.debug('=== Unmatched Subscriptions ===');
        System.debug('Count: ' + subscriptionSet.size());
        System.debug(subscriptionSet);

        System.debug('=== Unmatched Inventory ===');
        System.debug('Count: ' + inventorySet.size());
        System.debug(inventorySet);
  }
}
