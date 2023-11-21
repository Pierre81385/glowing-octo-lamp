# glowing-octo-lamp dependencies

- flutter
- socket.io
- node.js
- express.js
- mongodb
- bcrypt
- jwt

# Getting Started

- run 'nodemon server.js' to startup the server
- run 'flutter run' to startup the frontend

# About

- A point-of-sale terminal application with a flutter frontend and mongodb backend.
- REST API requests made through a Node.js server built with Express.js to Mongodb, accessed on the frontend through a API class to standardize the input and output.
- full create, read, update and delete functionality for users, products, and orders with role based access control.

![createUsers](https://github.com/Pierre81385/glowing-octo-lamp/blob/main/assets/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20Max%20-%202023-11-21%20at%2011.04.46.gif?raw=true)

- User accounts are secured with bcrypt encrypted passwords generate JSON web tokens for API access control.
- Admin users can update other users, products, and orders.

![addProduct](https://github.com/Pierre81385/glowing-octo-lamp/blob/main/assets/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20Max%20-%202023-11-21%20at%2011.05.58.gif?raw=true)

- Realtime updates accomplished through a combination of stateful components that pass data back and forth throughout the app, and Socket.io websocket events to force update when necessary.

![placeOrders](https://github.com/Pierre81385/glowing-octo-lamp/blob/main/assets/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20Max%20-%202023-11-21%20at%2011.06.39.gif?raw=true)

- Orders generate unique order numbers from suffled arrays of uppercase, lowercase, and numerical characters to 10 digitis.
- Orders record lists of Products, while the quantity ordered is maintained in each Product object

![orderQR](https://github.com/Pierre81385/glowing-octo-lamp/blob/main/assets/qr.png?raw=true)

- Orders generate a QR code for the customer to scan
  - currently this sends the user to the raw data of the order
  - QR code should take the user to payment processing
