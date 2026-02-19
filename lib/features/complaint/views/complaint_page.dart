import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/features/complaint/controllers/complaint_controller.dart';
import 'package:ausy/features/complaint/views/widgets/complaint_appbar.dart';
// import 'package:ausy/core/widgets/icon_box.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  ComplaintPageState createState() => ComplaintPageState();
}

class ComplaintPageState extends State<ComplaintPage> {
  final ComplaintController complaintController =
      Get.put(ComplaintController(), permanent: true);
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxBool showFab = false.obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      complaintController.complaints.clear();
      complaintController.loadComplaint();

      _scrollController.addListener(() {
        if (_scrollController.offset > 100) {
          if (!showFab.value) showFab.value = true;
        } else {
          if (showFab.value) showFab.value = false;
        }
      });


      Future.delayed(const Duration(milliseconds: 500), () {
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent == 0) {
          showFab.value = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            snap: true,
            floating: true,
            elevation: 0,
            title: ComplaintAppBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(context),
              childCount: 1,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            showAddComplaintModal(context); // buka modal isi pengaduan
          },
          backgroundColor: AppColor.primary,
          child: const Icon(Icons.add), // ➕ INI YANG BENAR
        ),
      ),



    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      return Column(
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
                    hint: "Cari",
                    prefix: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 16,
                    ),
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      complaintController.changeQuery(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: complaintController.isLoading.value
                ? ListView.builder(
                    padding: EdgeInsets.zero,
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
                : complaintController.filteredComplaints.isNotEmpty
                    ? ListView.builder(
                      padding: EdgeInsets.zero,
                        itemCount: complaintController.filteredComplaints.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final complaint =
                              complaintController.filteredComplaints[index];
                                final imageAsset = complaint.gender == 'L'
                                  ? 'assets/images/male.png'
                                  : 'assets/images/female.png';
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        imageAsset,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaint.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          complaint.message,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          complaint.date,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.shade200,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : _buildEmptyState(context),
          ),
        ],
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
  void showAddComplaintModal(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Kirim Pengaduan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tulis keluhan Anda di sini...",
                contentPadding: const EdgeInsets.all(14),


                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),


                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.trim().isEmpty) return;
              complaintController.sendComplaint(messageController.text.trim());
            },
            child: const Text("Kirim"),
          )
        ],
      ),
    );
  }

}

