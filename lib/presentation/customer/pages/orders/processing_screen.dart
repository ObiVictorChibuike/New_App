import 'package:dexter_mobile/app/shared/app_assets/assets_path.dart';
import 'package:dexter_mobile/app/shared/app_colors/app_colors.dart';
import 'package:dexter_mobile/app/shared/constants/strings.dart';
import 'package:dexter_mobile/app/shared/utils/custom_date.dart';
import 'package:dexter_mobile/presentation/customer/controller/booking_controller.dart';
import 'package:dexter_mobile/presentation/customer/controller/order_controller.dart';
import 'package:dexter_mobile/presentation/customer/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_progress.dart';

class ProcessingOrderScreen extends StatefulWidget {
  const ProcessingOrderScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingOrderScreen> createState() => _ProcessingOrderScreenState();
}

class _ProcessingOrderScreenState extends State<ProcessingOrderScreen> {
  final _controller = Get.put(OrderController());
  @override
  void initState() {
    _controller.getFulfilledOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
        init: OrderController(),
        builder: (controller){
          return Builder(builder: (context){
            if(_controller.processingOrderResponseModel == null || _controller.processingOrderResponseModel!.isEmpty && _controller.getProcessingOrderLoadingState == true && _controller.getProcessingOrderErrorState == false ){
              return CircularLoadingWidget();
            }else if(_controller.processingOrderResponseModel == null || _controller.processingOrderResponseModel!.isEmpty &&
                _controller.getProcessingOrderLoadingState == false && _controller.getProcessingOrderErrorState == false ){
              return  Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
                    const SizedBox(height: 40,),
                    Text("You have no fulfilled bookings",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
                  ],
                ),
              );
            }else if (_controller.processingOrderResponseModel != null || _controller.processingOrderResponseModel!.isNotEmpty &&
                _controller.getProcessingOrderLoadingState == false && _controller.getProcessingOrderErrorState == false ){
              return  Column(
                children: [
                  const SizedBox(height: 10,),
                  ...List.generate( _controller.processingOrderResponseModel!.length, (index){
                    final item = _controller.processingOrderResponseModel![index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(()=> OrderProgressScreen(id: _controller.processingOrderResponseModel![index].id!));
                          },
                          child: Container(
                            width: double.maxFinite, padding: EdgeInsets.all(16),
                            decoration: BoxDecoration( borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: dustyGray)),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(borderRadius: BorderRadius.circular(80),
                                      child: Container(height: 40, width: 40, decoration: BoxDecoration(shape: BoxShape.circle),
                                        child: Image.network(
                                          item.shop?.coverImage ??
                                              imagePlaceHolder , height: 40, width: 40, fit: BoxFit.cover,),
                                      ),
                                    ),
                                    const SizedBox(width: 15,),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.shop?.name ?? "",
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14, fontWeight: FontWeight.w600),),
                                        Text(CustomDate.slash(item.createdAt.toString()),
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff8F92A1), fontSize: 12, fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                  ],
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(2)),
                                  child: Text(item.status?.toLowerCase() == "fulfilled" ? "Delivered" : item.status?.toLowerCase() ?? "",  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: white, fontSize: 10, fontWeight: FontWeight.w700),),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    );
                  })
                ],
              );
            } else if(_controller.processingOrderResponseModel == null || _controller.processingOrderResponseModel!.isEmpty &&
                _controller.getProcessingOrderLoadingState == false && _controller.getProcessingOrderErrorState == true ){
              return CircularLoadingWidget();
            }
            return SizedBox.shrink();
          });
        });
  }
}

