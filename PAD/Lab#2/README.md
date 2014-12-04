## Building a distributed system.

Study of different transport protocols TCP/IP in order to build a application that contains collection of distributed data.

### Generic requirements

- Use UDP protocol for unicast and multicast transmission.
- Use TCP protocol for data transmission.
- Analyze and process collection of objects.

## Implementation

### Stored data

All information of servers is stored in one single json file (*data.json*) in order to reduce redundancy in real project each server will have separate file that will contain its specific data.

JSON or JavaScript Object Notation, is an open standard format that uses human-readable text to transmit data objects consisting of attributevalue pairs. It is used primarily to transmit data between a server and web application, as an alternative to XML.

```json
{
	"10000": {
		"neigthbours": [10001],
		"employers":[ ... ]
	},
	//...
    "10004": {
      "neigthbours": [10003],
      "employers":[ ... ]
    }
}

```


```json
"employers":[
	{"firstName":"John", "lastName":"Doe", "salary": 150, "department": "Marketing"},
	// ...
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

**UDP protocol**

The class below provides the functionality that assures the transmission between server and client using UDP protocol.

- *initialize* - creates a udp socket.
- *send requests* - method that will send requests to the ports available in its list.
- *listener* method serves for receiving udp messages, and store the responses in @nodes array, that will be used to analyze this information.
- *send requests* - method that sends request to the ports available in its list for information.
- *max port* - returns the node with max connections.
- *average* - computes the total average of all nodes.

**TCP protocol**

The class below provides the functionality that assures the transmission between server and client using TCP protocol.

- *initialize* - First we create a TCP socket, and
- *run* - here we call the following methods.
- *request node data* - send a tcp request to receive emplyoers information.
- *receive node data* - receives all information from server.
- *save data* - saves received data into a file.


**Data manipulation**

Data manipulation class as the name says it responsible to analyze, parse and show received data in a readable form.

- *show*  - display the information at the console.
- *filtered data* - analyze and parse the data.
- *table format* - add the table format to the parsed data.

**Main**

The main class Client contains all methods that are necesary to start and perform necesary work, it also has UDP and TCP functionality by using the classes with the same name. Below there is a short description of methods that it has, for the implementation you can see the full code.

- In the *contructor* we save provided options and setup udp server.
- *receive data* - we setup a tcp server, send requests to servers and save response to a file.
- *prepare data* - read the json file and initiate the data manipulation class.
- *show data results* - show data received from server, based on option from console.


## Conclusion

In this laboratory work we build a distributed system that has at its basis the different transport protocols TCP and UDP, that were used for individual purposes, each doing its own predefined task. Thus after learning more about the advantages and disadvantages of each protocol, we apply each to solve their individual task.

At first we used UDP protocol for unicast and multicast transmission in order to receive information related to the number of neighbours node of each server (node), and at the same time the average salary information. This decision was implemented because the average salary is represented by a number, and it is easy to send using the udp protocol, the downside of this approach is that there is a high chance to lose this data, and this will result in wrong calculation of total average of nodes, and represeting the information to the client.

We also worked with json in order to store our collection of necesary data, that contains the port number, list of neighboars and the list of employers of each node, by reading, parsing and then saving in the same format type.

Thus we learned how to build a small distributed system with a collection of objects using different types of transport protocols.