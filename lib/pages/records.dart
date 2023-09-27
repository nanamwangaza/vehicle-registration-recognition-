import 'package:flutter/material.dart';
import '../helper/database_helper.dart';

class ResponsesScreen extends StatefulWidget {
  @override
  _ResponsesScreenState createState() => _ResponsesScreenState();
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<String> _responses = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    List<String> refreshedData = await DBHelper.instance.getPlateNumbers();

    setState(() {
      _responses = refreshedData;
    });
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String response) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteResponse(context, response);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponseListItem(
    
      BuildContext context, String response, int itemIndex) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              ' $itemIndex:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              ' $response',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteConfirmationDialog(context, response);
          },
        ),
      ),
    );
  }

  Future<void> _deleteResponse(BuildContext context, String response) async {
    await DBHelper.instance.deleteResponse(response);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Record deleted'),
      duration: Duration(seconds: 2),
    ));

    setState(() {
      _responses.remove(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003366),
        title: Text('Records', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: _responses.isEmpty
            ? Center(
                child: Text('No records available.'),
              )
            : ListView.builder(
                itemCount: _responses.length,
                itemBuilder: (context, index) {
                  final response = _responses[index];
                  final itemIndex = index + 1;
                  return _buildResponseListItem(context, response, itemIndex);
                },
              ),
      ),
    );
  }
}
