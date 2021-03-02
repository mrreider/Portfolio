// --== CS400 File Header Information ==--
// Name: Reid Brostoff
// Email: rbrostoff@wisc.edu
// Team: HD
// TA: Na Li
// Lecturer: Florian Heimerl
// Notes to Grader: <optional extra notes>
import java.util.NoSuchElementException;

/*
Class for testing HashTableMap.java. Includes 5 distinct tests that return true if the program runs
correctly, false otherwise. For most of the methods HashTableMap<Integer,String> will be used for simplicity
 */
public class TestHashTable {

    public static void main(String[] args) {
        System.out.println(test1() ? "Test1 passed" : "Test1 failed");
        System.out.println(test2() ? "Test2 passed" : "Test2 failed");
        System.out.println(test3() ? "Test3 passed" : "Test3 failed");
        System.out.println(test4() ? "Test4 passed" : "Test4 failed");
        System.out.println(test5() ? "Test5 passed" : "Test5 failed");
    }

    /*
     Test1 is a basic test that all of the put and size functions act correctly.
     Returns: true if all tests passed, false otherwise.
     */
    public static boolean test1() {
        HashTableMap<Integer, String> test = new HashTableMap<>(10); //new map of size 10
        test.put(1, "dog");
        test.put(5, "cat");
        test.put(3, "fish"); //add three objects to test the size of the hashtable map is equal to three

        if (!(test.size() == 3)) {
            System.out.println("Test1 failed on first test. Sizes are not equal");
            return false;
        }

        if (!(test.get(3).equals("fish"))) { //tests if the get with key returns proper value
            System.out.println("Test1 failed on second test. Get() not working correctly ");
            return false;
        }

        try {
            test.get(2); //tries to get() with a key not in table. Should throw NoSuchElementException
            System.out.println("Test1 failed on third test. Exception should have been thrown");
        } catch (NoSuchElementException e) {
        }

        return true;
    }

    /*
    Test2 test the basic remove and size functionality.
    Returns: true if all tests passed, false otherwise.
     */
    public static boolean test2() {
        HashTableMap<Integer, String> test = new HashTableMap<>(10); //new map of size 10
        test.put(1, "dog");
        test.put(5, "cat");
        test.put(3, "fish");
        test.remove(3); //size should go from three to two

        if (!(test.size() == 2)) {
            System.out.println("Test2 failed on first test, size() should be 2");
            return false;
        }

        test.put(6, "goat");
        if (!test.remove(6).equals("goat")) { //tests is remove(key) returns correct associated value
            System.out.println("Test2 failed on second test, remove() must return correct value");
            return false;
        }

        test.clear(); //clears the HashTableMap to check is size after equals 0
        if (!(test.size() == 0)) {
            System.out.println("Test2 failed on third test, clear() must make size equal zero");
            return false;
        }
        return true;

    }

    /*
    Test3 tests the functionality of the load, growing, and capacity of the hash table
    Returns: true if all tests passed, false otherwise.
     */
    public static boolean test3() {
        HashTableMap<Integer, String> test = new HashTableMap<>(5); //new map of size 5
        test.put(1, "dog");
        test.put(5, "cat");
        test.put(3, "fish");

        if (!(test.getCapacity() == 5)) { //tests that capacity won't until it hits 80% load (4/5)
            System.out.println("Test3 failed on first test. Capacity should not have changed by this point(60%)");
            return false;
        }

        test.put(4, "octopus"); //at 80% the capacity should double
        if (!(test.getCapacity() == 10)) {
            System.out.println("Test3 failed on second test. Capacity should have doubled to 10");
            return false;
        }

        if (!(test.get(3).equals("fish"))) { //checks if the array was restored correctly after expanding
            System.out.println("Test3 failed on third test, after expanding array, key-pair values should still be there");
            return false;
        }

        test = new HashTableMap<>(100); //now size 100
        for (int i = 0; i < 79; ++i) { //will add 79 items check the size, then add one more and see if the array expanded.
            test.put(i, "test" + i);
        }

        if (!(test.getCapacity() == 100)) {
            System.out.println("Test3 failed on fourth test, array should not have expanded at 79%");
            return false;
        }
        test.put(79, "final"); //adds the 80th item (0-79)
        if (!(test.getCapacity() == 200)) {
            System.out.println("Test3 failed on fifth test. Array should have doubled at 80%");
            return false;
        }
        return true;

    }

    /*
    Test4 tests containKey(), and getIndex() functions
    Returns: true if all tests passed, false otherwise
     */
    public static boolean test4() {
        HashTableMap<Integer, String> test = new HashTableMap<>(5); //new map of size 5
        test.put(1, "dog");
        test.put(5, "cat");
        test.put(3, "fish");

        if (!test.containsKey(3) || test.containsKey(4)) { //checks if the table contains three but not four.
            System.out.println("Test4 failed on first test. Should contain 3 and not 4");
            return false;
        }
        Integer three = 3;
        int predictedIndex = Math.abs(three.hashCode() % test.getCapacity());

        if (!(test.getIndex(3) == predictedIndex)) { //if the getIndex method does not work give the correct index based on key and capacity
            System.out.println("Test4 failed on second test. GetIndex() is not returning the correct index for capacity and key");
            return false;
        }

        //one more time, but first we are going to double the capacity

        test.put(4, "owl");
        predictedIndex = Math.abs(three.hashCode() % test.getCapacity());

        if (!(test.getIndex(3) == predictedIndex)) {
            System.out.println("Test4 failed on third test. GetIndex()is not returning the correct index for capacity and key after expanding");
            return false;
        }

        return true;
    }

    /*
    Test5 will test all methods used together
    Returns: true if all tests pass, false otherwise
     */
    public static boolean test5() {
        HashTableMap<Integer, String> test = new HashTableMap<>(5); //new map of size 5
        test.put(1, "dog");
        test.put(5, "cat");
        test.put(3, "fish");
        test.remove(3);

        try { //tests if a NoSuchElement exception is thrown when trying to get() a node that has been removed.
            test.get(3);
            System.out.println("Test5 failed on the first test. This line should never have been reached");
            return false;
        } catch (NoSuchElementException e) {
        }

        //Double capacity twice test
        test.put(3, "moose");
        test.put(4, "cow"); //80%
        if (test.getCapacity() == 10) {
            test.put(7, "mouse");
            test.put(15, "squirrel");
            test.put(11, "bird");
            test.put(40, "bee"); // 80% (8/10)
            if (!(test.getCapacity() == 20)) {
                System.out.println("Test5 failed on second test. Capacity should double at 4 and 8 items to 10 and 20 respectively");
                return false;
            }
        }

        //Int max test
        test.put(Integer.MAX_VALUE, "big number");
        if (!(test.get(Integer.MAX_VALUE)).equals("big number")) {
            System.out.println("Test5 failed on third test. Integer.MAX_VALUE as key should return \"big number\"");
            return false;
        }

        //Non <Integer,String> pair test
        HashTableMap<String, Boolean> otherTest = new HashTableMap<>(5);
        otherTest.put("This should be true", true);
        otherTest.put("This should be false", false);

        if (!(otherTest.get("This should be true") instanceof Boolean) || !(otherTest.get("This should be false") instanceof Boolean)) //if the method does not give a Boolean type for a String key
        {
            System.out.println("Test5 failed on fourth test. get() should return a boolean type");
            return false;
        }
        return true;
    }
}
