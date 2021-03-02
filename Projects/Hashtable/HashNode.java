// --== CS400 File Header Information ==--
// Name: Reid Brostoff
// Email: rbrostoff@wisc.edu
// Team: HD
// TA: Na Li
// Lecturer: Florian Heimerl
// Notes to Grader: <optional extra notes>

/*
This class creates a singular HashNode that contains both the KeyType and ValueType
This is for ease of accessing a key-value pair within the hashtable
 */
public class HashNode<KeyType, ValueType>{
    private KeyType key;
    private ValueType value;

    /*
    Constructor for a HashNode
    Parameter: key - KeyType of HashNode
    Parameter: value - ValueType of HashNode
     */
    public HashNode(KeyType key, ValueType value){
        this.key = key;
        this.value = value;
    }

    /*
    Accessor method for KeyType
    Returns: key of HashNode
     */
    public KeyType getKey(){
        return key;
    }

    /*
    Accessor method for ValueType
    Returns: value of HashNode
     */
    public ValueType getValue(){
        return value;
    }



}