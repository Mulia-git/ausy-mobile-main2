import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/payment/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentController paymentController =
      Get.put(PaymentController(), permanent: true);
  TextEditingController searchController = TextEditingController();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentController.payments.clear();
      paymentController.changeQuery('');
      paymentController.loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Cara Bayar",
        backgroundColor: Colors.white,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search Box
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextBox(
                        hint: "Cari cara bayar",
                        prefix: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 16,
                        ),
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          paymentController.changeQuery(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // List of Doctors
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: paymentController.isLoading.value
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                    : paymentController.filteredPayments.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                paymentController.filteredPayments.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final payment =
                                  paymentController.filteredPayments[index];
                              return GestureDetector(
                                onTap: (){
                                  Get.back(result: payment);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              payment.name,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : _buildEmptyState(context),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.15,
        right: 20.5,
        left: 20.5,
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/no-data.json', // Ganti path sesuai file kamu
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ooops , tidak ada data.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Maaf data yang anda cari tidak ditemukan.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
