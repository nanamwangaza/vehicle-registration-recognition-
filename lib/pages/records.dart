import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponsesScreen extends StatefulWidget {
  const ResponsesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResponsesScreenState createState() => _ResponsesScreenState();
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<ResponseWithDateTime> _responses = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    List<ResponseWithDateTime> refreshedData =
        await DBHelper.instance.getPlateNumbers();
    setState(() {
      _responses = refreshedData;
    });
    // ignore: avoid_print
    print('Data refreshed');
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String response) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteResponse(context, response);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponseListItem(
      BuildContext context, ResponseWithDateTime response, int itemIndex) {
    return Card(
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(' $itemIndex:',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    )),
                Text(
                  ' ${response.plateNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(' ${response.dayOfWeek}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    )),
                Text(' ${response.formattedDate}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(
                  width: 20,
                ),
                Text(' ${response.formattedTime}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      color: const Color(0xFF003366),
                    )),
              ],
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color(0xFF003366),
          ),
          onPressed: () {
            _showDeleteConfirmationDialog(context, response.plateNumber);
          },
        ),
      ),
    );
  }

  Future<void> _deleteResponse(BuildContext context, String response) async {
    await DBHelper.instance.deleteResponse(response);

    setState(() {
      _responses.removeWhere((item) => item.plateNumber == response);
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Record deleted'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'HISTORY',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: _responses.isEmpty
            ? const Center(
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
