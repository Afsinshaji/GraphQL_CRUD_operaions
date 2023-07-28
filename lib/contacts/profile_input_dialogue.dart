import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:qraphql_sample/contacts/query_mutation.dart';
import 'package:qraphql_sample/contacts/user.dart';

import 'graphQL_Configuration.dart';

class ProfileInputDialog extends StatefulWidget {
  const ProfileInputDialog(
      {super.key, required this.isToAdd, required this.user});
  final bool isToAdd;
  final User? user;

  @override
  State<ProfileInputDialog> createState() => _ProfileInputDialogState();
}

class _ProfileInputDialogState extends State<ProfileInputDialog> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  @override
  void initState() {
    super.initState();
    if (!widget.isToAdd) {
      txtId.text = widget.user!.getId();
      txtName.text = widget.user!.getName();
      txtLastName.text = widget.user!.getLastName();
      txtPhone.text = widget.user!.getPhone().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isToAdd ? "Add" : "Edit or Delete"),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Stack(
            children: [
              TextField(
                maxLength: 255,
                controller: txtId,
                enabled: false,
                decoration: const InputDecoration(
                  icon: Icon(Icons.perm_identity),
                  labelText: "ID",
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 80.0),
                child: TextField(
                  maxLength: 40,
                  controller: txtName,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.text_format),
                    labelText: "Name",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 160.0),
                child: TextField(
                  maxLength: 40,
                  controller: txtLastName,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.text_rotate_vertical),
                    labelText: "Last name",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 240.0),
                child: TextField(
                  maxLength: 12,
                  controller: txtPhone,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Phone", icon: Icon(Icons.calendar_today)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        widget.isToAdd
            ? TextButton(
                child: const Text("Add"),
                onPressed: () async {
                  GraphQLClient client = graphQLConfiguration.clientToQuery();
                  await client
                      .mutate(
                    MutationOptions(
                      document: gql(
                        addMutation.createUser(
                          txtName.text,
                          txtLastName.text,
                          int.parse(txtPhone.text),
                        ),
                      ),
                    ),
                  )
                      .then((value) {
                    txtId.clear();
                    txtLastName.clear();
                    txtName.clear();
                    txtPhone.clear();
                    Navigator.pop(context);
                    setState(() {});
                  });
                })
            : TextButton(
                child: const Text("Edit"),
                onPressed: () async {
                  GraphQLClient client = graphQLConfiguration.clientToQuery();
                  await client
                      .mutate(
                    MutationOptions(
                      document: gql(
                        addMutation.updateUser(
                          txtId.text,
                          txtName.text,
                          txtLastName.text,
                          int.parse(txtPhone.text),
                        ),
                      ),
                    ),
                  )
                      .then((value) {
                    txtId.clear();
                    txtLastName.clear();
                    txtName.clear();
                    txtPhone.clear();
                    Navigator.pop(context);
                    setState(() {});
                  });
                }),
        !widget.isToAdd
            ? TextButton(
                child: const Text("Delete"),
                onPressed: () async {
                  GraphQLClient client = graphQLConfiguration.clientToQuery();
                  await client
                      .mutate(
                    MutationOptions(
                      document: gql(
                        addMutation.deleteUser(
                          txtId.text,
                        ),
                      ),
                    ),
                  )
                      .then((value) {
                    txtId.clear();
                    txtLastName.clear();
                    txtName.clear();
                    txtPhone.clear();
                    Navigator.pop(context);
                    setState(() {});
                  });
                })
            : const SizedBox(),
      ],
    );
  }
}
