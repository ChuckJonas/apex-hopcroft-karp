// could make into interface 
//fixed size OR dynamic

public class Queue {
    private List<Integer> ls;
    public Queue() {
        ls = new List<Integer>();
    }

    public Queue(Integer size) {
        ls = new List<Integer>(size);
    }

    public Integer size() {return ls.size();}
    
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
        if (isEmpty()) {return null;}
        return ls.get(0);      
    }

    public Integer poll() {
        if(isEmpty()){return null;}
        Integer firstEntry = ls.get(0);
        ls.remove(0);
        return firstEntry;
    }

    public void addAll(List<Integer> neighbors) {
        ls.addAll(neighbors);
    }

    // this presents time complexity issues for large number of nodes
    public void removeAll(Set<Integer> nodesToRemove) {
        for (Integer node : nodesToRemove) {
            if (ls.contains(node)) {
                Integer index = ls.indexOf(node);
                ls.remove(index);
            }
        }
    }
}
