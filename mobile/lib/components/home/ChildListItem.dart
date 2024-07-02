import 'package:flutter/material.dart';
import 'package:mobile/utilities/status.dart';
import 'package:provider/provider.dart';
import '../../providers/ChildrenListProvider.dart';

class ChildListItem extends StatelessWidget {
  final Child child;

  ChildListItem({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, "/child", arguments: child),
      child: Consumer<ChildrenListProvider>(
        builder: (context, provider, _) {
          // Extract child from provider
          Child updatedChild = provider.childrenMap[child.id];

          // Use updated child data
          bool live = updatedChild.live;
          bool tracking = updatedChild.tracking;
          bool safe = updatedChild.safe;
          String name = updatedChild.name;

          return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: setBgColor(tracking, live, safe),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Child: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Status: ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              setStatus(tracking, live, safe),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 35,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
