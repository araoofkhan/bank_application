import 'dart:io';
import 'dart:math';
import 'dart:typed_data'; // Correct import for ByteData
import 'package:audioplayers/audioplayers.dart'; // For playing sounds
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Correct import for ByteData
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../resources/colors.dart';
import '../widgets/CustomAppBar.dart';
import 'DashBoardScreen.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final double amount;
  final String beneficiaryname;
  final String accountNumber;
  final String bankName;
  final String bankLogo;
  final String transactionid;
  final String date;

  PaymentConfirmationScreen( {
    required this.amount,
    required this.beneficiaryname,
    required this.accountNumber,
    required this.bankName,
    required this.bankLogo,
    required this.transactionid,
    required this.date,
  });



  @override
  _PaymentConfirmationScreenState createState() => _PaymentConfirmationScreenState();

}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSuccessSound(context); // Pass context to _playSuccessSound
  }

  // Play sound function
  Future<void> _playSuccessSound(BuildContext context) async {
    try {
      final ByteData data = await rootBundle.load('lib/resources/sounds/confirmationsound.mp3');
      await _audioPlayer.play(BytesSource(data.buffer.asUint8List()));
    } catch (e) {
      print("Error playing sound: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing sound: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player to free up resources
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Access amount via widget.amount
    final formattedAmount = formatAmount(widget.amount);


    return Scaffold(
      appBar: CustomAppBar(title: "Send Money"),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text('Transaction Successful', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text(accountHolderName.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(accountHolderAccountNumber, style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              Text('Money Transferred', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Text('Rs. ${formattedAmount}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
              SizedBox(height: 10),
              Text('to', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text('${widget.beneficiaryname} - Account Number: ${widget.accountNumber.substring(0, 4)}*****${widget.accountNumber.substring(widget.accountNumber.length - 4)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 20),
              Image.asset(widget.bankLogo, width: 50, height: 50),
              Text(widget.bankName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text(widget.date, style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              Text('Transaction ID (TID): ${widget.transactionid}', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 20),
              Text(
                'Transactions conducted after 09:00 PM and during holidays will show up in receiver\'s statement in next working day but balance will be updated in real time.',
                style: TextStyle(fontSize: 14, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _captureAndSaveScreenshot,
                    child: Text('Screenshot'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _captureAndShareScreenshot();
                    },
                    child: Text('Share Receipt'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  // Capture and save screenshot
  Future<void> _captureAndSaveScreenshot() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final result = await ImageGallerySaver.saveImage(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['isSuccess'] ? 'Screenshot saved!' : 'Failed to save screenshot',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture screenshot')),
      );
    }
  }

  // Capture and share screenshot without saving
  Future<void> _captureAndShareScreenshot() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      try {
        // Save the captured image temporarily for sharing
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/screenshot.png');
        await file.writeAsBytes(image);

        // Share the screenshot using Share Plus
        await Share.shareXFiles([XFile(file.path)], text: 'Transaction Receipt');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share screenshot')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture screenshot')),
      );
    }
  }





}
