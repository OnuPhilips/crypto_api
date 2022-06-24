import 'dart:async';
import 'dart:convert';

import 'package:crypto_api/models/coin.dart';
import 'package:crypto_api/widgets/button_widget.dart';
import 'package:crypto_api/widgets/total_balance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/design/coin_card_design.dart';
import '../widgets/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Fetching the Coins from the API

  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=30&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.FromJson(map));
          }
        }
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    fetchCoin();
    Timer.periodic(const Duration(seconds: 10), ((timer) => fetchCoin()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x111b232A),
      bottomNavigationBar: GlassBottomNav(
        onPressed: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
        selectedIndex: _selectedIndex,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TotalBalance(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 75,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonWidget(text: "Coins", onTap: () {}, acttive: true),
                    ButtonWidget(text: "Deposit", onTap: () {}, acttive: false),
                    ButtonWidget(
                        text: "Withdraw", onTap: () {}, acttive: false),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              //Design Coin Cards
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.3,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: coinList.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: CoinCardDesign(
                        name: coinList[index].name,
                        symbol: coinList[index].symbol,
                        imageUrl: coinList[index].imageUrl,
                        price: coinList[index].price.toDouble(),
                        change: coinList[index].change.toDouble(),
                        changePercentage:
                            coinList[index].changePercentage.toDouble(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
