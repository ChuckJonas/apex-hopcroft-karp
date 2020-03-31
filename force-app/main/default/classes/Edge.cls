public with sharing class Edge {

    private final String V1;
    private final String V2;
    private final double weight;

    public Edge(String V1, String V2, double weight) {
        this.V1 = V1;
        this.V2 = V2;
        this.weight = weight;
    }

    public Edge(String V1, String V2) {
        this.V1 = V1;
        this.V2 = V2;
        this.weight = 1.0;
    }

    public double weight() {
        return weight;
    }

    public String getV1() {
        return V1;
    }

    public String getV2() {
        return V2;
    }

    public String getOppositeVertex(String vertex) {
        if (vertex == V1) return V2;
        else if (vertex == V2) return V1;
        else throw new IllegalArgumentException('Illegal Endpoint');
    }



}
