import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggerGrid extends StatelessWidget {
  const StaggerGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("staggered grid demo")),
        body:  Padding(
          padding: const EdgeInsets.all(20.0),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 4,
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 50 * (index % 3 + 3).toDouble(),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              );
            },
          )
        ));
  }
}
