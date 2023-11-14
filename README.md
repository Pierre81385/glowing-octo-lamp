# glowing-octo-lamp

- flutter
- socket.io
- node.js
- express.js
- mongodb
- bcrypt
- jwt

# Getting Started

- launch with nodemon server.js && flutter run

# User AUTH + CRUD

- Create

  - password hashed with bcrypt
  - user object saved to mongodb collection
  - JSON Web Token generated at login and saved in user state

- Read

  - find user by id
  - find all users

- Update

  - update any and all user properties
  - updates saved to state and mongodb

- Delete
  - delete user/s
