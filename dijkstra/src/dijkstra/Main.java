package dijkstra;

import java.io.*;
import java.util.*;

class Edge
{
	public int connectTo;
	public int cost;
	
	public Edge(int id, int c)
	{
		connectTo = id;
		cost = c;
	}
}

class Node implements Comparable<Node>
{
	public Set<Edge> edges = new HashSet<Edge>();
	
	public boolean determined;
	public int cost = Integer.MAX_VALUE;
	
	public int compareTo(Node n)
	{
		return cost == n.cost ? 0 : cost < n.cost ? -1 : 1;
	}
}

public class Main
{
	public static void main(String[] args)
	{
		Scanner sc = new Scanner(System.in);
		int N = sc.nextInt();
		Node[] nodes = new Node[N];
		for (int i = 0; i < N; i++) nodes[i] = new Node();
		for (int i = 0; i < N; i++)
		{
			int M = sc.nextInt();
			for (int j = 0; j < M; j++)
			{
				int id = sc.nextInt(), cost = sc.nextInt();
				nodes[i].edges.add(new Edge(id, cost));
				nodes[id].edges.add(new Edge(i, cost));
			}
		}
		Queue<Node> q = new PriorityQueue<Node>();
		nodes[0].cost = 0;
		q.add(nodes[0]);
		while (!nodes[N - 1].determined)
		{
			Node n = q.poll();
			if (n.determined) continue;
			n.determined = true;
			for (Edge e : n.edges)
			{
				Node n2 = nodes[e.connectTo];
				n2.cost = Math.min(n.cost + e.cost, n2.cost);
				q.add(n2);
			}
		}
		System.out.println(nodes[N - 1].cost);
	}
}
/*
8
3 1 1 2 7 3 2
2 4 2 5 4
2 5 2 6 3
1 6 5
1 5 1
1 7 6
1 7 2
0
*/
