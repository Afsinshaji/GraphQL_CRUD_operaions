


import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:qraphql_sample/contacts/profile_input_dialogue.dart';
import 'package:qraphql_sample/contacts/query_mutation.dart';
import 'package:qraphql_sample/contacts/user.dart';

import 'graphQL_Configuration.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<User> userList = [];
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  void fillList() async {
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient client = graphQLConfiguration.clientToQuery();
    QueryResult result =
        await client.query(QueryOptions(document: gql(queryMutation.getAll())));
 
      for (var i = 0; i < result.data!["users"].length; i++) {
        setState(() {
          userList.add(
            User(
              result.data!["users"][i]["id"],
              result.data!["users"][i]["name"],
              result.data!["users"][i]["lastName"],
              result.data!["users"][i]["phone"],
            ),
          );
        });
      
    }
  }

  void addUser(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (context) {
        return ProfileInputDialog(
          isToAdd: true,
          user: user,
        );
      },
    );
  }
    void deleteOrEditUser(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return ProfileInputDialog(
          isToAdd: false,
          user: user,
        );
      },
    );
  }
  

  @override
  void initState() {
    super.initState();
    fillList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => addUser(context,null),
            tooltip: "Insert new user",
          ),
        ],
      ),
            body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                User user = userList[index];
                return ListTile(
              
                  title: Text(
                    user.name,
                  ),
                  onTap: () {
                    deleteOrEditUser(context, user);
                  },
                );
              },
            ),
          ),
        ],
      ),

);
  }
}
