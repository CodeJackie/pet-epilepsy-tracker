import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/seizure_entry.dart';
import 'detailed_entry_page.dart';

class EntryItem extends StatefulWidget {
  final SeizureEntry entry;

  EntryItem({required this.entry});

  @override
  _EntryItemState createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_isExpanded ? 0 : 0),
      ),
      color: _isExpanded ? Color(0xFF7a65b7) : Colors.white,
        child: ExpansionTile(
          onExpansionChanged: (bool expanded) {
            //change card background color
            setState(() => _isExpanded = expanded);
          },
          tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          title: _isExpanded ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                  DateFormat('MMMM d, yyyy').format(DateTime.parse(widget.entry.seizureDate)),
                  style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  '${widget.entry.seizureCount} Seizure(s)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            ],
          ) : Text(
            DateFormat('MMMM d, yyyy').format(DateTime.parse(widget.entry.seizureDate)),
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
            trailing: _isExpanded ? SizedBox.shrink() : Text(
              '${widget.entry.seizureCount} Seizure(s)',
              style: TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          children: <Widget>[
            Container(
              color: Color(0xFF7a65b7),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedEntryPage(entry:widget.entry), 
                        ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text('View Entry', style: TextStyle(color:Colors.black87)),
                ),
                ]
              ),
            ),
          ],
        ),
      );

  }
}
