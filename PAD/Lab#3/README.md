## Study of HTTP protocol used in distributed systemns

Study of HTTP protocol used in distributed systemns. Implementation of connection between client and server using HTTP methods.

Implementation of the thread safe system of processing of data.

## Structure

Below you can see the structure of the application, there are represented the classes used and their variables and methods. The main are client and server which the helper class Http Handler that server the purpose of sending the http requests to the Main Server.

The client will be responsible for sending GET request to the Main Server, then the Main Server will find the node with max connections and return the information to the Client Then the Client will establish a TCP connection necessary node. After it receive all necesary data, this data will be analyzed and shown to the user.

In order to allow multiple requests from server nodes and client, each connection will be handled in different thread and in a safe way.



## Implementation

### Stored data

Like in the previous laboratory work all information of servers is stored in one single json file (*data.json*) in order to reduce redundancy in real project each server will have separate file that will contain its specific data.


```json
{
	"10000": {
		"neigthbours": [10001],
		"employers":[]
	},

    "10004": {
      "neigthbours": [10003],
      "employers":[]
    }
}

```

```json
"employers":[
	{"firstName":"John", "lastName":"Doe", "salary": 150, "department": "Marketing"},
	
	{"firstName":"Alex", "lastName":"Carturari", "salary": 478, "department": "Testing"}
]
```

### Dependencies

In the application we used some external packages, (gems), that provide additional functionality. Below I will provide a small description of each one.

- *socket* - provides access to the underlying operating system socket implementations. It can be used to provide more operating system specific functionality than the protocol-specific socket classes.
- *json* - allow to generate or parse json easily.
- *optparse* - is a class for command-line option analysis. It is much more advanced, yet also easier to use.
- *rainbow* - is a ruby gem for colorizing printed text on ANSI terminals.
- *terminal-table* - is a fast and simple, yet feature rich ASCII table generator written in Ruby.


### Client side

The client part of the application is composed of four main file that together provide functionality necesary to assure the request to server, receive, save, parse and show the response in form of the list of emplyoers from server with the maximum nodes and its neighbours.


**HTTP handler**

We don’t use the UDP helper like in the previous laboratory work, instead we send the GET request to the Main Server and receive the response that will contain the port and average of the node with maximum connections.


- *initialize* - initialize all necesary variables and a TCP socket.
- *send get request* - send GET request and receives the response from Main Server.
- *send put request* - send PUT request in the case of server node.
- *max port* - returns the node with max connections.
- *average* - computes the total average of all nodes.

**TCP protocol Data Manipulation**

See the laboratory work 2 for these sections.

**Main Server**
The most important function of the main server is to receive different request, and depending on type and parameters of request to perform certain actions.

The run function is the function that receives requests from nodes or client in a thread safe way and depending of the type of request it acess different methods.

**Main**

The main class Client contains all methods that are necesary to start and perform necesary work, it also has HTTP and TCP functionality by using the classes with the same name. Below there is a short description of methods that it has, for the implementation you can see the full code.

- In the *contructor* we save provided options and setup udp server.
- *receive data* - we setup a tcp server, send requests to servers and save response to a file.
- *prepare data* - read the json file and initiate the data manipulation class.
- *show data results* - show data received from server, based on option from console.


## Conclusion

In this laboratory work we built a distributed system that different http requests to send information from nodes to main server and from main server to client, each request doing its own predefined task.

We build a helper class that handles all required requests GET and PUT, and receives the responses from the Main Server. Depending on the request Main Server will perform different action, in the GET case it will return the information about node with maximum connection, when PUT it will add the information in an array.

Thus we learned how to build a small distributed system with a collection of objects using different http requests.
