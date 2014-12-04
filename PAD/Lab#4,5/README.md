## Processing and distribution of xml and json data

The aim of the laboratory work lies in the study of models for processing XML data (DOM / SAX) and JSON to distribution.

Develop a system of distributed heterogeneous data, centralized in one node type warehousing.

## Structure

Below you can see the structure of the application, there are represented the classes used and their variables and methods. The application is composed of three main clasess Client and Server and Main Server.

The Client and Server classes use the HttpHandler helper class in order to send the necesary requests to the Main Server and also recieve the response from it.

The requests are handled and analyzed on Main Server in different threads and saved on a single file, the server doesn’t duplicate the records it already has them in his json database file, for this it uses an additional Hash file that saves the messages received in a Hash format

## Implementation

### Main Server

The most important function of the main server is to receive different request, and depending on type and parameters of request to perform certain actions.

The run function is the function that receives requests from nodes or client in a thread safe way and depending of the type of request it acess different methods.

Below I will describe how the GET sequence it is executed. The PUT request processing was implemented and described by my colegue.

The first function that is accessed is
- *send response* - the method that sends data depending on the type of request received.
- *json_response* - returns the json response.
- *xml_response* - returns the xml response.
- *response* - the method that returns the data depending of the user request.
- *send_get_response* - sends the response in the right format with the right data.


### Client side

The client side suffered a small number of modifications compared to previous versions, because the all the necessary data is received with GET request, there is no need to establish a TCP connection with other nodes to get the data.

**HTTP handler**

The handler permforms the same functions that it done previously but with some adjustments.
- *send_get_request* - method that will send get request that contains the type.
- *get_response* - method that receives the GET response from the main server.
- *parse_json* - parse the response with json.
- *parse_xml* - parses the xml response with json.

**Data manipulation**

Data manipulation class as the name says it responsible to analyze, parse and show received data in a readable form.

- *show_all* - display all the employers received from GET request.
- *show_entry* - display the entry in a table format.
- *table_format* - add the table format to the parsed data.
- *check_xml?* - checks if received data was in xml format.

**Main**

The main class Client contains all methods that are necesary to start and perform necesary work. Below there is a short description of methods that it has, for the implementation you can see the full code.

- In the *contructor* we save provided options and setup http handler.
- *run* - performs get request to the main server.
- *show_data_results* - show data received from mian server, based on option from console.

### Xml checker

The nodes send the contents of their files with help of PUT request, the Main Server has the functionality to check if the contents of the send message are valid and then save them into the file. First he loads the schema file of the xml that should match the xml it will receive.

And the main check take place before saving to the database, it checks if the type is xml and then validates with help of Nokogiri librari with in case of errors will return an array of errors. Then we check if that array is empty then we pass the xml to json to our save method, otherwise the return a message of error to the terminal.


## Conclusion

In this laboratory work we build a distributed system that uses different type of data and different requests, each doing its own predefined task. Thus after learning more about the uses and formats of data, we apply each to solve their individual task.

We built a helper class that handles all required requests GET and PUT, and receives the responses from the Main Server. Depending on the request ”/employess” or specific one ”employees/id=1” and the type specified ”json” or ”xml”, the Main Server will return the list of users or a single required user. 

We also worked with json in order to store our collection of necesary data, on the Main Server and also a array of hashes to prevent duplicated entries. 

Thus we learned how to build a small distributed system with a collection of objects using different tpes and requests.

