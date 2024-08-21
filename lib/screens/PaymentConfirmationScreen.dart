import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../resources/colors.dart';
import 'DashBoardScreen.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final double amount;
  final String nickname;
  final String accountNumber;
  final String bankName;
  final String bankLogo;

  PaymentConfirmationScreen({
    required this.amount,
    required this.nickname,
    required this.accountNumber,
    required this.bankName,
    required this.bankLogo,
  });

  @override
  _PaymentConfirmationScreenState createState() => _PaymentConfirmationScreenState();
}
class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd-MM-yyyy – HH:mm').format(DateTime.now());
    final String transactionId = _generateTransactionId();
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money', style: TextStyle(color: AppColors.yellowcolor)),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: AppColors.yellowcolor),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.yellowcolor),
            onPressed: () {
              // Handle notifications button action
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new, color: AppColors.yellowcolor),
            onPressed: () {
              // Handle power off button action
            },
          ),
        ],
      ),
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
              Text(accountHolderaccountNmber, style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              Text('Money Transferred', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Text('Rs. ${widget.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
              SizedBox(height: 10),
              Text('to', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text('${widget.nickname} - Account Number: ${widget.accountNumber.substring(0, 4)}*****${widget.accountNumber.substring(widget.accountNumber.length - 4)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 20),
              Image.asset(widget.bankLogo, width: 50, height: 50),
              Text(widget.bankName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text(formattedDate, style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              Text('Transaction ID (TID): $transactionId', style: TextStyle(fontSize: 16, color: Colors.white)),
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

  String _generateTransactionId() {
    var rng = Random();
    return List.generate(7, (_) => rng.nextInt(10)).join();
  }
}
