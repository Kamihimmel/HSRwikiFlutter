import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:in_app_review/in_app_review.dart';

const String _kDonationTier1Id = 'SR_donation_tier_1';
const String _kDonationTier2Id = 'SR_donation_tier_2';
const String _kDonationTier3Id = 'SR_donation_tier_3';
const String _kDonationTier4Id = 'SR_donation_tier_4';
const List<String> _kProductIds = <String>[
  _kDonationTier1Id,
  _kDonationTier2Id,
  _kDonationTier3Id,
  _kDonationTier4Id,
];

class DonatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DonatePageState();
  }
}

class DonatePageState extends State<DonatePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  // final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // handle error here.
      });
      initStoreInfo();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (!kIsWeb && Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (!kIsWeb && Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // fetch product details
    final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    // if error
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error?.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // is empty
    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    // final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
    });

    log('products: $_products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Buy me a coffee').tr(),
      // ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.black45,
        ),
        child: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 48),
                      InkWell(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(75)),
                          ),
                          child: Image(
                            image: AssetImage('images/icon.png'),
                            filterQuality: FilterQuality.medium,
                            height: 150,
                          ),
                        ),
                        onTap: () async {
                          // if (await inAppReview.isAvailable()) {
                          //   await inAppReview.requestReview();
                          // } else {
                          //   inAppReview.openStoreListing(appStoreId: '1620751192');
                          // }
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Sponsor the Project".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "We are individuals who are devoted into app making and exploring the game. Every cent of your donation will go directly to developing our free and excellent apps. Your generous support will help us create more value and make the world a better place."
                            .tr(),
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400, height: 1.2),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 40),
                      _buildProductList(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  Container _buildProductList() {
    if (kIsWeb || Platform.isWindows) {
      return Container(
        child: OutlinedButton(
            onPressed: () async {
              if (await canLaunchUrlString("https://genshincalc.yunlu18.net/secret.html".tr()) != null) {
                await launchUrlString("https://genshincalc.yunlu18.net/secret.html".tr());
              } else {
                throw 'Could not launch' + ' https://genshincalc.yunlu18.net/secret.html'.tr();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Open Sponsor page".tr(),
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            )),
      );
    } else {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        if (_loading || _purchasePending) {
          return Container(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          );
        }
        return Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1), borderRadius: BorderRadius.all(Radius.circular(50))),
          child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                  context: context,
                  color: Theme.of(context).colorScheme.secondary,
                  tiles: _products.map((product) => ListTile(
                        title: Center(
                            child: Text(
                          (product.title).substring(0, (product.title).indexOf("(") == -1 ? (product.title).length : (product.title).indexOf("(")),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 24,
                            height: 1.1,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                        subtitle: Center(
                            child: Text(
                          product.price,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            height: 1.1,
                          ),
                        )),
                        onTap: () {
                          final purchaseParam = PurchaseParam(productDetails: product);
                          InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
                        },
                      ))
                ).toList()
            ),
      );
    } else {
      return Container();
    }
  }
}

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void hidePendingUI() {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          await _inAppPurchase.completePurchase(purchaseDetails);
          // FIXME: disable ad when purchased 
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('adstatus', version);
          // adon = false;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Colors.red,
            content: Text('Congratulations! Ad Disabled').tr(),
            action: SnackBarAction(
              textColor: Colors.white,
              label: '×',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // Some code to undo the change.
              },
            ),
          ));
        }
        // if (Platform.isAndroid) {
        //   if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
        //     final InAppPurchaseAndroidPlatformAddition androidAddition =
        //         _inAppPurchase.getPlatformAddition<
        //             InAppPurchaseAndroidPlatformAddition>();
        //     await androidAddition.consumePurchase(purchaseDetails);
        //   }
        // }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
          hidePendingUI();
        }
      }
    }
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
