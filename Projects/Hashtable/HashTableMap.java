// --== CS400 File Header Information ==--
// Name: Reid Brostoff
// Email: rbrostoff@wisc.edu
// Team: HD
// TA: Na Li
// Lecturer: Florian Heimerl
// Notes to Grader: <optional extra notes>
import java.util.NoSuchElementException;
import java.util.LinkedList;

/*
This class is the generic HashTableMap class that implements MapADT.java. Creates a hashtable
(an array of linked lists) each with a list of HashNodes that hold the key and value objects.
 */
public class HashTableMap<KeyType, ValueType> implements MapADT{
    private int capacity;
    private LinkedList<HashNode>[] hashTable;

    /*
    Constructor for given capacity
    Parameter: capacity - specified capacity
     */
    public HashTableMap(int capacity) {
        this.capacity = capacity;
        hashTable = new LinkedList[capacity]; //table of values
    }

    /*
    Default constructor
    Sets capacity to 10
     */
    public HashTableMap() {
        this.capacity = 10;
        hashTable = new LinkedList[capacity];
    }

    /*
    This method places a key and its value into the hashtable by creating a HashNode,
    checking if the size must change, then adding it to its respective linked list at
    the calculated index
    Parameter: key - KeyType to be used
    Parameter: value - ValueType to be used
    Returns: true if the item was added, false otherwise.
     */
    @Override
    public boolean put(Object key, Object value) {
        if(containsKey(key)) return false;

        //Checks if need to grow if load capacity > 80%
        if ((double) (size() + 1) / (double) capacity >= .8) grow();

        //Creates HashNode
        if (hashTable[getIndex(key)] == null) hashTable[getIndex(key)] = new LinkedList<HashNode>();
        HashNode nodeToBeAdded = new HashNode(key, value);
        hashTable[getIndex(key)].add(nodeToBeAdded); //adds the node to the linked list
        return true;
    }

    /*
    This method will retrieve a value from the HashTable when given a key
    Parameter: key - KeyType of Value to be retrieved
    Returns: Value corresponding to key
    Throws: NoSuchElementException is there is no associated value with the key
     */
    @Override
    public Object get(Object key) throws NoSuchElementException {
        int i = 0;
        while (true){ // if next element in LinkedList isn't null
            if (hashTable[getIndex(key)] == null || hashTable[getIndex(key)].isEmpty()) break; //if this list according to getIndex(key) is empty, break;
            HashNode currNode = hashTable[getIndex(key)].get(i); //set current node in loop

            if (currNode.getKey().equals(key)){ //if keys are equal return value
                return currNode.getValue();
            }
            else { //else keep searching
                if(hashTable[getIndex(key)].getLast().equals(currNode)) break; // if no next node exit the while loop
                ++i; //otherwise increment i and continue loop
                continue;
            }
        }
        throw new NoSuchElementException("Item not found"); //if item is not found throw no such element exception
    }

    /*
    This method calculates the amount of HashNodes (Key-Value pairs) in the HashTable
    Returns: the calculated amount
     */
    @Override
    public int size() {
        int size = 0;
        for (LinkedList<HashNode> currList : hashTable){ //goes through list and adds sizes
            if (currList == null || currList.isEmpty()) continue;
            size += currList.size();
        }
        return size;
    }

    /*
    This method checks if the HashTable contains a HashNode with a specific key.
    Calculates correct LinkedList index then searches list for key.
    Parameter: key - KeyType to be searched for
    Returns: True if the table contains the key, false otherwise
     */
    @Override
    public boolean containsKey(Object key) {
        LinkedList<HashNode> currList = hashTable[getIndex(key)];
        if (currList == null) return false; //if the list is empty, there is no key in there
        for (HashNode currNode: currList){ //checks all of the nodes in the LinkedList
            if (currNode.getKey().equals(key)) return true;
        }
        return false;
    }

    /*
    This method removes a HashNode from the HashTable then returns the value of the HashNode.
    Parameter: key - KeyType to be searched for
    Returns: ValueType corresponding to the given key.
     */
    @Override
    public Object remove(Object key) {
        LinkedList<HashNode> currList = hashTable[getIndex(key)];
        for (HashNode currNode : currList){ //loops through all HashNodes in LinkedList
            if (currNode.getKey().equals(key)) { //if equals key remove and return value
                Object retVal = currNode.getValue();
                currList.remove(currNode); //removes node
                return retVal;
            }

        }
        return null; //if no keys are matched return null
    }

    /*
    This method clears the entire HashTableMap by setting all LinkedLists to null
     */
    @Override
    public void clear() {
        for (LinkedList<HashNode> currList : hashTable){
            if (currList == null) continue;
            currList.clear();
        }
    }

    /*
    This method is a private helper method to double the LinkedList[] array when the load becomes >= 80%
    Creates a new larger table then indexes all past objects to their new corresponding index with the new capacity.
     */
    private void grow() { //helper method to grow LinkedList array
        LinkedList<HashNode>[] tempHashTable = new LinkedList[(capacity * 2)];
        capacity = (capacity * 2);
        for (LinkedList<HashNode> currList : hashTable){
            if (currList == null) continue; //if list is null keep going
            for (HashNode currNode : currList){
                if (tempHashTable[getIndex(currNode.getKey())] == null) tempHashTable[getIndex(currNode.getKey())] = new LinkedList<HashNode>(); //if there isnt a linkedList there yet add one
                tempHashTable[getIndex(currNode.getKey())].add(currNode); //finds the respective index for the key in the new array of linked lists, then adds that node to the array
            }
        }
        hashTable = tempHashTable;
    }

    /*
    This method finds the correct index in the current LinkedList[] using the
    absolute value of the hashcode of the key % capacity
    Parameter: currKey - KeyType to find index for
    Returns: the corresponding index
     */
    public int getIndex(Object currKey) {
        return Math.abs(currKey.hashCode() % capacity);
    }

    /*
    This public method is solely used to help test the growing and changing of the capacity
    in the TestHashTable.java class.
    Returns: the current capacity
     */
    public int getCapacity(){
        return capacity;
    }

}
