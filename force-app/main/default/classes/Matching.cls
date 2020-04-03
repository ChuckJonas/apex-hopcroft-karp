/*
 * (C) Copyright 2013-2020, by Alexey Kudinkin and Contributors.
 *
 * JGraphT : a free Java graph-theory library
 *
 * See the CONTRIBUTORS.md file distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0, or the
 * GNU Lesser General Public License v2.1 or later
 * which is available at
 * http://www.gnu.org/licenses/old-licenses/lgpl-2.1-standalone.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR LGPL-2.1-or-later
 */
//package org.jgrapht.alg.interfaces;



public class Matching {
    
    private Multigraph graph;
    private Set<Edge> edges;
    private double weight;
    private Set<String> matchedVertices = null;

    /**
    * Construct a new instance
    *
    * @param graph graph on which the matching is defined
    * @param edges the edges of the matching
    * @param weight the weight of the matching
    */
    public Matching(Multigraph graph, Set<Edge> edges, double weight)
    {
        this.graph = graph;
        this.edges = edges;
        this.weight = weight;
    }


    public Multigraph getGraph()
    {
        return graph;
    }


    public double getWeight()
    {
        return weight;
    }


    public Set<Edge> getEdges()
    {
        return edges;
    }


    public boolean isMatched(String v)
    {
        if (matchedVertices == null) { // lazily index the vertices that have been matched
            matchedVertices = new Set<String>();
            for (Edge e : edges) {
                matchedVertices.add(e.source);
                matchedVertices.add(e.target);
            }
        }
        return matchedVertices.contains(v);
    }

    /**
    * {@inheritDoc}
    */

    public override String toString()
    {
        return 'Matching [edges=' + edges + ', weight=' + weight + ']';
    }



}
