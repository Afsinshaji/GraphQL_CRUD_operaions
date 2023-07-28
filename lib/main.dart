import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'contacts/contacts_list.dart';
import 'contacts/graphQL_Configuration.dart';

void main() {
  runApp( GraphQLProvider(
    client: GraphQLConfiguration.client,
    child: const CacheProvider(child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GraphQL Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ContactsList(),
    );
  }
}
