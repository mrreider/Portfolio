// --== CS400 File Header Information ==--
// Name: Reid Brostoff
// Email: rbrostoff@wisc.edu
// Team: HD
// TA: Na
// Lecturer: Florian
// Notes to Grader: <optional extra notes>
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import java.util.LinkedList;
import java.util.NoSuchElementException;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

/**
 * Tests the implementation of CS400Graph for the individual component of
 * Project Three: the implementation of Dijsktra's Shortest Path algorithm.
 */
public class GraphTest {

    private CS400Graph<Integer> graph;
    @BeforeEach
    /**
     * Instantiate graph from last week's shortest path activity.
     */
    public void createGraph() {
        graph = new CS400Graph<>();
        // insert verticies 0-9
        for(int i=0;i<10;i++)
            graph.insertVertex(i);
//         insert edges from Week 08. Dijkstra's Activity
        graph.insertEdge(0,2,1);
        graph.insertEdge(1,7,2);
        graph.insertEdge(1,8,4);
        graph.insertEdge(2,4,4);
        graph.insertEdge(2,6,3);
        graph.insertEdge(3,1,6);
        graph.insertEdge(3,7,2);
        graph.insertEdge(4,5,4);
        graph.insertEdge(5,0,2);
        graph.insertEdge(5,1,4);
        graph.insertEdge(5,9,1);
        graph.insertEdge(6,3,1);
        graph.insertEdge(7,0,3);
        graph.insertEdge(7,6,1);
        graph.insertEdge(8,9,3);
        graph.insertEdge(9,4,5);
    }


    /**
     * Tests the case from activity from last week. Checks that the path is the same as my submission
     */
    @Test
    public void testPathLongestPathFromActivity(){
        assertTrue(graph.shortestPath(4,8).toString().equals("[4, 5, 1, 8]"));
    }

    /**
     * Tests the case from the activity from last week. My node was node four and the longest path was 12 to node 8.
     */
    @Test
    public void testLongestPathFromActivity(){
        assertTrue(graph.getPathCost(4,8) == 12);
    }

    /**
     * Checks the case in which the start and end data elements are not vertices of the graph
     */
    @Test
    public void testInvalidVerticesForException(){
        try{
            graph.getPathCost(55,22);
            fail();
        }
        catch(NoSuchElementException e){
            //success
        }
        catch(Exception e) {
            fail();
        }
    }

    /**
     * Tests that the path cost from a node to itself is zero.
     */
    @Test
    public void testNoLength(){
        assertTrue(graph.getPathCost(4,4) == 0);
    }

    /**
     * Checks the distance/total weight cost from the vertex labelled 0 to 8
     * (should be 15), and from the vertex labelled 9 to 8 (should be 17).
     */
    @Test
    public void providedTestToCheckPathCosts() {
        assertTrue(graph.getPathCost(0,8) == 15);    
        assertTrue(graph.getPathCost(9,8) == 17);
    }

    /**
     * Checks the ordered sequence of data within vertices from the vertex 
     * labelled 0 to 8, and from the vertex labelled 9 to 8.
     */
    @Test
    public void providedTestToCheckPathContents() {
        assertTrue(graph.shortestPath(0, 8).toString().equals(
            "[0, 2, 6, 3, 1, 8]"
        ));
        assertTrue(graph.shortestPath(9, 8).toString().equals(
            "[9, 4, 5, 1, 8]"
        ));
    }

}
