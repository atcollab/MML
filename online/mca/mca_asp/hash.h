#ifndef _INT_HASH_H_
#define _INT_HASH_H_ 1

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

class IntHashNode
{
friend class IntHash;
friend class IntHashIterator;

private:
	int           hashInt;
	void        * hashData;
	IntHashNode * next;

	IntHashNode  ( int HashInt, void * HashData);
	~IntHashNode ( void );
};


class IntHash
{
friend class IntHashIterator;

private:
	enum { HASH_CNT=256, HASH_NO=256 };

	IntHashNode * nodes[HASH_CNT];

	int Elements;

public:
	IntHash  ( void );
	~IntHash ( void );

	inline unsigned char hash ( int hashInt );

	inline void insert ( int hashInt, void * hashData );
	inline void remove ( int hashInt );
	inline void * find ( int hashInt );
	inline int size ( void );
};


class IntHashIterator
{
private:
	IntHash     * hashTbl;
	IntHashNode * node;
	int           idx;	

public:
	IntHashIterator( IntHash * HashTbl );	
	~IntHashIterator( void );
	
	inline void * first       ( void );
	inline void * operator ++ ( void );
	inline void * operator ++ ( int x );
	inline int    key         ( void );
	inline void * data        ( void );
};



inline IntHashNode::IntHashNode ( int HashInt, void * HashData )
	: next(NULL)
	{
	hashInt = HashInt;
    hashData  = HashData;
	}


inline IntHashNode::~IntHashNode ( void )
	{
        }


inline IntHash::IntHash  ( void )
	{
	memset(nodes, 0, sizeof(nodes));
	Elements = 0;
	}


inline IntHash::~IntHash ( void )
	{
	for(int i=0; i<HASH_CNT; i++)
		{
		while(nodes[i]!=NULL)
			{
			IntHashNode * node = nodes[i];
			nodes[i] = node->next;
			delete node;
            }
		}
	}

inline unsigned char IntHash::hash ( int hashInt )
	{
	return (hashInt%HASH_NO);
	}

inline void IntHash::insert (int hashInt, void * hashData )
	{
	unsigned char idx = hash(hashInt);
	IntHashNode * prev    = NULL, * node = nodes[idx];
	IntHashNode * newNode = new IntHashNode(hashInt, hashData);

	while(node!=NULL && node->hashInt!=hashInt)
		{
		prev = node;
		node = prev->next;
		}
	if(node!=NULL)
		{
		newNode->next = node->next;
		delete node;
		Elements--;
		}
	if(prev!=NULL) prev->next = newNode;
	else           nodes[idx] = newNode;
	Elements++;
	}

inline void IntHash::remove ( int hashInt )
	{
	unsigned char idx = hash(hashInt);
	IntHashNode * prev = NULL, * node = nodes[idx];
	while(node!=NULL && node->hashInt!=hashInt)
		{
		prev = node;
		node = prev->next;
		}
	if(node!=NULL)
		{
		if(prev!=NULL) prev->next = node->next;
		else           nodes[idx] = node->next;
		delete node;
		Elements--;
		}
	}

inline void * IntHash::find ( int hashInt )
	{
	unsigned char idx = hash(hashInt);
	IntHashNode * prev = NULL, * node = nodes[idx];
	while(node!=NULL && node->hashInt!=hashInt)
		{
		prev = node;
		node = prev->next;
		}
	return node!=NULL?node->hashData:NULL;
	}

inline int IntHash::size ( void )
	{
	return Elements;
	}

inline IntHashIterator::IntHashIterator(IntHash * HashTbl)
	: hashTbl(HashTbl), idx(0), node(NULL)
	{
	}
	
inline IntHashIterator::~IntHashIterator( void ) 
	{
	}
	
inline void * IntHashIterator::first ( void )
	{
	if(hashTbl!=NULL)
		{
		for(idx = 0; idx<IntHash::HASH_CNT &&
		   (node = hashTbl->nodes[idx])==NULL; idx++);
		}
	else node = NULL;
	return (node!=NULL)?node->hashData:NULL;
	}
	
inline void * IntHashIterator::operator ++ ( void )
	{
	if(hashTbl!=NULL)
		{
		if(node==NULL) first();
		else if(node->next!=NULL) node = node->next;
		else 
			{
			node = NULL;
			do 	{
				idx++;
				} while(idx<IntHash::HASH_CNT && 
				       (node = hashTbl->nodes[idx])==NULL);
			}
		}
	else node = NULL;
	return (node!=NULL)?node->hashData:NULL;
	}
	
inline void * IntHashIterator::operator ++ ( int x )
	{
	if(hashTbl!=NULL && x==0)
		{
		if(node==NULL) first();
		else if(node->next!=NULL) node = node->next;
		else 
			{
			node = NULL;
			do 	{
				idx++;
				} while(idx<IntHash::HASH_CNT && 
				       (node = hashTbl->nodes[idx])==NULL);
			}
		}
	else node = NULL;
	return (node!=NULL)?node->hashData:NULL;
	}

inline int IntHashIterator::key ( void )
	{
	return (node!=NULL)?node->hashInt:NULL;
	}
	
inline void * IntHashIterator::data ( void )
	{
	return (node!=NULL)?node->hashData:NULL;
	}
	

#endif /* _INT_HASH_H_ */
