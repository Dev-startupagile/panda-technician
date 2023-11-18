import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panda_technician/app/service/app_setting_service.dart';
import 'package:panda_technician/models/charge_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicianTransactionWidget extends StatefulWidget {
  TechnicianTransactionWidget();

  @override
  _TechnicianTransactionWidgetState createState() =>
      _TechnicianTransactionWidgetState();
}

class _TechnicianTransactionWidgetState
    extends State<TechnicianTransactionWidget> {
  List<ChargeTransaction> transactions = [];
  AppSettingService _appSettingService = Get.find<AppSettingService>();

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("apiToken");

    var response = await http.get(
      Uri.parse(
          '${_appSettingService.config.baseURL}/account/getStripeTransactions'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    setState(() {
      transactions = List.from(json.decode(response.body)["data"]["data"])
          .map<ChargeTransaction>((e) => ChargeTransaction.fromMap(e))
          .toList();
    });
    // strapiToken = json.decode(response.body)["url"];
  }

  void showChargeTransactionDetails(
      BuildContext context, ChargeTransaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Transaction Details',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildDetailRow('Object:', transaction.object),
                _buildDetailRow('Amount:', transaction.amountFormated),
                _buildDetailRow('Captured Amount:',
                    '${(transaction.amountCaptured / 100).toStringAsFixed(2)} ${transaction.currency}'),
                _buildDetailRow('Refunded Amount:',
                    '${(transaction.amountRefunded / 100).toStringAsFixed(2)} ${transaction.currency}'),
                _buildDetailRow('Application:', transaction.application),
                _buildDetailRow('Application Fee:', transaction.applicationFee),
                _buildDetailRow('Application Fee Amount:',
                    transaction.applicationFeeAmount.toStringAsFixed(2)),
                _buildDetailRow(
                    'Balance Transaction:', transaction.balanceTransaction),
                _buildDetailRow('Currency:', transaction.currency),
                _buildDetailRow(
                    'Captured:', transaction.captured ? 'Yes' : 'No'),
                _buildDetailRow(
                    'Refunded:', transaction.refunded ? 'Yes' : 'No'),
                _buildDetailRow('Source Transfer:', transaction.sourceTransfer),
                _buildDetailRow('Status:', transaction.status),
                _buildDetailRow('Created:', transaction.createdFormated),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _launchURL(transaction.receiptUrl),
                  child: Text('Open Receipt'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: transactions.isEmpty
            ? Center(
                child: Text("No Payment History Yet!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)))
            : Container(
                margin: const EdgeInsets.only(top: 100),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Transaction History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return Column(
                            children: [
                              ListTile(
                                horizontalTitleGap: 5,
                                style: ListTileStyle.drawer,
                                onTap: () {
                                  showChargeTransactionDetails(
                                      context, transaction);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${transaction.amountFormated}',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Color(0xfff0fbf6)),
                                        child: Text(
                                          '${transaction.object}',
                                          style: TextStyle(
                                              color: Color(0xff5bda9d)),
                                        )),
                                  ],
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Color(0xfff0fbf6)),
                                        child: Text(
                                          '${transaction.status}',
                                          style: TextStyle(
                                              color: Color(0xff5bda9d)),
                                        )),
                                    Text(
                                      'Date: ${transaction.createdFormated}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Divider()
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
