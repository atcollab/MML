#ifndef _INT_HASH_H_
#define _INT_HASH_H_ 1

// Define for iterator debugging
#define PARANOID

// System
#include <string.h>
#ifdef PARANOID
#include <stdio.h>
#endif

/** One node in a hash, mapping integer keys to 'T' pointers. */ 
template<class T>
class IntHashNode
{
public:
    IntHashNode(int key, T *value, IntHashNode *next)
      : key(key), value(value), next(next)
    {}
    
    int getKey() const
    {   return key; }

    T *getValue() const
    {   return value; }
    
    void setValue(T *value)
    {   this->value = value; }
    
    IntHashNode *getNext() const
    {   return next; }

    void setNext(IntHashNode *next)
    {   this->next = next; }
    
private:
	int            key;
	T              *value;
	IntHashNode<T> *next;
};

/** Hash, mapping integer keys to 'T' pointers. */ 
template<class T>
class IntHash
{
public:
    IntHash  ( void )
        : Elements(0)
    {
        memset(nodes, 0, sizeof(nodes));
#ifdef PARANOID
        mods = 0;
#endif
    }

    ~IntHash ( void )
    {
        for (int i=0; i<HASH_CNT; i++)
        {
            IntHashNode<T> *node = nodes[i];
            while (node)
            {
                IntHashNode<T> *tmp = node->getNext();
                delete node;
                node = tmp;
            }
        }
    }

    void insert(int key, T *value)
    {
        unsigned char idx = hash(key);
        IntHashNode<T> *node = nodes[idx];
#ifdef PARANOID
        ++mods;
#endif        
        while (node)
        {
            if (node->getKey() == key)
            {   // Found, update value
                node->setValue(value);
                return;
            }
            node = node->getNext();
        }
        // Not found, add to front
        nodes[idx] = new IntHashNode<T>(key, value, nodes[idx]);
        Elements++;
    }

    /** Remove element with given key.
     *  <p>
     *  <b>NOTE:</b>
     *  Calling 'remove' invalidates any iterator
     *  that is currently attached to the hash!
     * 
     *  @return The value for that key or 0.
     */
    T *remove (int key)
    {
        unsigned char idx = hash(key);
        IntHashNode<T> *prev = 0, *node = nodes[idx];
#ifdef PARANOID
        ++mods;
#endif        
        while (node)
        {
            if (node->getKey() == key)
            {   // Unlink 'node' and delete
                if (prev)
                    prev->setNext(node->getNext());
                else           
                    nodes[idx] = node->getNext();
                T *value = node->getValue();
                delete node;
                Elements--;
                return value;
            }
            prev = node;
            node = node->getNext();
        }
        return 0;
    }

    /** Find an entry.
     *  @return The value for that key or 0.
     */
    T *find (int key)
    {
        unsigned char idx = hash(key);
        IntHashNode<T> *node = nodes[idx];
        while (node)
        {
            if (node->getKey() == key)
                return node->getValue();
            node = node->getNext();
        }
        return 0;
    }

    /** @return Number of entries in the hash. */
    int size ()
    {   return Elements; }
    
    class Iterator
    {
    public:
        /** Create an iterator for the given hash.
         *  It will be positioned on the first element.
         *  @see #next()
         */
        Iterator(IntHash<T> &hash)
        : hash(hash), idx(-1), node(0)
        {
#ifdef PARANOID
            hash.mods = 0;
#endif
            next();
        }

        /** Get the current element's key.
         *  This is the one routine which cannot distinguish
         *  between '0' as 'key is 0' or 'there is no current element'.
         *  So it might be a good idea to avoid 0 keys.
         * 
         *  @return Key of current element or 0.
         */
        int getKey() const
        {   return node ? node->getKey() : 0; }
        
        /** @return Value of current element or 0. */
        T *getValue() const 
        {   return node ? node->getValue() : 0; }

        /** Move iterator to next element, get its value.
         *  <p>
         *  @return Value of next element or 0.
         */
        T *next()
        { 
#ifdef PARANOID
            if (hash.mods != 0)
            {
                printf("IntHash::Iterator::next(): Hash was modified %d times\n",
                       hash.mods);
                return 0;
            }
#endif
            // init: node 0, idx -1
            if (node)
                node = node->getNext();
            if (!node)
            {
                while (++idx < HASH_CNT)
                {
                    node = hash.nodes[idx];
                    if (node)
                        break;
                }
            }
            return getValue();
        }
        
        /** Remove the current element from the hash, move to next.
         *  @return Value of first/next element or 0.
         */
        T *remove ()
        {
#ifdef PARANOID
            if (hash.mods != 0)
            {
                printf("IntHash::Iterator::remove(): Hash was modified %d times\n",
                       hash.mods);
                return 0;
            }
#endif
            // done, or not initialized?
            T *value = getValue();
            if (!value)
                return 0;
            int del_idx = idx;
            IntHashNode<T> *del_node = node;
            // Move on
            next();
            
            // Locate the node-to-delete
            IntHashNode<T> *p = 0, *n = hash.nodes[del_idx];
            while (n)
            {
                if (n == del_node)
                {   // unhook
                    
                    if (p)
                        p->setNext(n->getNext());
                    else           
                        hash.nodes[del_idx] = n->getNext();
                    delete n;
                    --hash.Elements;
                    return value;
                }
                p = n;
                n = n->getNext();
            }
            printf("IntHash::Iterator::remove(): Cannot find node to remove\n");
            return 0;
        }

    private:
        IntHash<T>    &hash;
        int           idx;  
        IntHashNode<T> *node;
    };
    
private:
    enum { HASH_CNT=256 };

    int hash (int key)
    {
        return (key % HASH_CNT);
    }

    IntHashNode<T> *nodes[HASH_CNT];
    int Elements;
#ifdef PARANOID
    int mods;
#endif
};


#endif /* _INT_HASH_H_ */
