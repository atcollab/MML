#ifndef _QUEUE_H_
#define _QUEUE_H_

template <class T>
class Node {

private:
	
	T Data;								// The data contained in the node
	Node<T> *Next;						// The pointer to the next node
	Node<T> *Previous;					// The pointer to the previous node

public:

	// Constructor, Destructor
	//
	Node( void );						// Default Constructor
	~Node( void );						// Default Destructor

	// Selectors
	//
	T GetData( void ) const;			// Returns data contained in node
	Node<T> *GetNext( void ) const;		// Returns pointer to next node
	Node<T> *GetPrev( void ) const;		// Returns pointer to previous node

	// Modifiers
	//
	void SetData( T Value );			// Sets the data in the node
	void SetNext( Node<T> *NextPtr );	// Sets the pointer to the next node
	void SetPrev( Node<T> *PrevPtr );	// Sets the pointer to the previous node

};

template <class T>
class Queue {

private:

	Node<T> *TAIL;						// Points to the last item in the queue
	Node<T> *HEAD;						// Points to the first item in the queue

public:

	// Constructor, Destructor
	//
	Queue( void );						// Default constructor
	~Queue ( void );					// Default destructor

	// Selectors
	//
	int Size( void ) const;				// Returns the number of nodes in the queue
	bool IsEmpty ( void ) const;		// Returns True if the queue is empty

	// Modifiers
	//
	void Enqueue( T Value );			// Adds a new node to the queue
	T Dequeue( void );					// Removes the next node from the queue

};

template <class T>
Node<T>::Node( void ) {
	SetPrev(0);
	SetNext(0);
}

template <class T>
Node<T>::~Node( void ) {

}

template <class T>
T Node<T>::GetData( void ) const {
	return (Data);
}

template <class T>
Node<T>* Node<T>::GetNext( void ) const {
	return Next;
}

template <class T>
Node<T>* Node<T>::GetPrev( void ) const {
	return Prev;
}

template <class T>
void Node<T>::SetData( T Value ) {
	Data = Value;
}

template <class T>
void Node<T>::SetNext( Node<T> *NextPtr ) {
	Next = NextPtr;
}

template <class T>
void Node<T>::SetPrev( Node<T> *PrevPtr ) {
	Previous = PrevPtr;
}

template <class T>
Queue<T>::Queue( void ) {

	TAIL = 0;
	HEAD = 0;

}

template <class T>
Queue<T>::~Queue( void ) {

	while (!IsEmpty()) {
		Dequeue();
	}

}

template <class T>
int Queue<T>::Size( void ) const {

	int Count;
	if (Empty()) {
		Count = 0;
	}
	else {

		Node<T> *CountPtr = HEAD;
		for(Count = 1; CountPtr != TAIL; count++) {
			CountPtr = CountPtr->GetNext();
		}
	}
	return Count;
}

template <class T>
bool Queue<T>::IsEmpty( void ) const {
	return((HEAD == 0) && (TAIL == 0));
}

template <class T>
void Queue<T>::Enqueue( T Value ) {

	Node<T> *NodePtr = new Node<T>;
	NodePtr->SetData(Value);
	NodePtr->SetNext(0);

	if(IsEmpty())
		HEAD = NodePtr;
	else
		TAIL->SetNext(NodePtr);

	TAIL = NodePtr;

}

template <class T>
T Queue<T>::Dequeue( void ) {

	if(IsEmpty()) {

	}
	else {

		T Value = HEAD->GetData();
		Node<T> *TempPtr = HEAD;

		if(HEAD->GetNext() == 0) {
			HEAD = 0;
			TAIL = 0;
		}
		else
			HEAD = HEAD->GetNext();

		delete TempPtr;
		return Value;

	}
}

#endif /* _QUEUE_H_ */
