import 'package:flutter/material.dart';

class StepsPage extends StatelessWidget {
  final List<dynamic>? steps;

  StepsPage({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Steps'),
      ),
      body: steps == null || steps!.isEmpty
          ? Center(
              child: Text('No steps available.'),
            )
          : ListView.builder(
              itemCount: steps!.length,
              itemBuilder: (context, index) {
                final step = steps![index];
                final stepName = step['step_name']?.toString() ?? 'Step ${index + 1}';
                final description = step['description']?.toString() ?? 'No description';

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stepName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(description),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Time: ${step['time'] ?? 'N/A'}',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Flame: ${step['flame'] ?? 'N/A'}',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}