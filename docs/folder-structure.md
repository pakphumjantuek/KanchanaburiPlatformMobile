# โครงสร้างโฟลเดอร์ Flutter

เอกสารนี้แสดงโครงสร้างโฟลเดอร์ของ source code ใน `lib/` ครบทุก feature รวมถึงโฟลเดอร์ view และ widget ที่แยกตามหน้าไว้แล้ว โฟลเดอร์ `widgets/` ภายใน `views/<ชื่อหน้า>/` เก็บ widget ที่ใช้กับหน้านั้น ส่วน widget ที่ใช้ร่วมกันทั้ง feature ให้อยู่ใน `features/<feature>/widgets/`

## ภาพรวม

```text
lib/
├── app/                         # การตั้งค่าแอป, routes, theme และ bindings เริ่มต้น
│   ├── bindings/
│   ├── config/
│   ├── routes/
│   └── theme/
├── core/                        # บริการและโค้ดพื้นฐานที่ใช้ข้าม feature
│   ├── constants/
│   ├── network/
│   ├── services/
│   └── utils/
├── features/                    # โค้ดแยกตามความสามารถของแอป
│   ├── admin/
│   ├── auth/
│   ├── cart/
│   ├── checkout/
│   ├── content_detail/
│   ├── contents/
│   ├── home/
│   ├── merchant/
│   ├── navigation/
│   ├── orders/
│   ├── profile/
│   └── shops/
├── shared/                      # widget ที่ใช้ร่วมกันหลาย feature
│   └── widgets/
└── main.dart                    # จุดเริ่มต้นของแอป
```

## โครงสร้างแต่ละ feature

```text
features/
├── admin/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   └── views/
│       ├── admin_dashboard/
│       │   ├── admin_dashboard_page.dart
│       │   └── widgets/
│       ├── admin_export/
│       │   ├── admin_export_page.dart
│       │   └── widgets/
│       ├── admin_orders/
│       │   ├── admin_orders_page.dart
│       │   └── widgets/
│       ├── admin_payouts/
│       │   ├── admin_payouts_page.dart
│       │   └── widgets/
│       ├── manage_categories/
│       │   ├── manage_categories_page.dart
│       │   └── widgets/
│       ├── manage_contents/
│       │   ├── manage_contents_page.dart
│       │   └── widgets/
│       ├── manage_products/
│       │   ├── manage_products_page.dart
│       │   └── widgets/
│       ├── manage_schedules/
│       │   ├── manage_schedules_page.dart
│       │   └── widgets/
│       ├── manage_shops/
│       │   ├── manage_shops_page.dart
│       │   └── widgets/
│       ├── manage_tags/
│       │   ├── manage_tags_page.dart
│       │   └── widgets/
│       └── reports/
│           ├── reports_page.dart
│           └── widgets/
│
├── auth/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   └── views/                   # login_page.dart, register_page.dart
│
├── cart/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   ├── views/                   # cart_page.dart
│   └── widgets/                 # widget สำหรับตะกร้าที่ใช้ใน feature
│
├── checkout/
│   ├── bindings/
│   ├── controllers/
│   ├── views/                   # checkout_page.dart, payment_page.dart,
│   │                            # payment_success_page.dart
│   └── widgets/
│       ├── checkout/
│       ├── payment/
│       └── payment_success/
│
├── content_detail/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   ├── views/                   # content_detail_page.dart
│   └── widgets/
│
├── contents/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   ├── views/                   # contents_page.dart, create_content_page.dart
│   └── widgets/
│
├── home/
│   ├── bindings/
│   ├── controllers/
│   ├── views/                   # home_page.dart
│   └── widgets/
│
├── merchant/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   └── views/
│       ├── content_form/
│       │   ├── content_form_page.dart
│       │   └── widgets/
│       ├── manage_contents/
│       │   ├── manage_contents_page.dart
│       │   └── widgets/
│       ├── manage_orders/
│       │   ├── manage_orders_page.dart
│       │   └── widgets/
│       ├── manage_products/
│       │   ├── manage_products_page.dart
│       │   └── widgets/
│       ├── merchant_dashboard/
│       │   ├── merchant_dashboard_page.dart
│       │   └── widgets/
│       ├── merchant_export/
│       │   ├── merchant_export_page.dart
│       │   └── widgets/
│       ├── product_deal_form/
│       │   ├── product_deal_form_page.dart
│       │   └── widgets/
│       ├── product_deals/
│       │   ├── product_deals_page.dart
│       │   └── widgets/
│       ├── product_form/
│       │   ├── product_form_page.dart
│       │   └── widgets/
│       └── register_shop/
│           ├── register_shop_page.dart
│           └── widgets/
│
├── navigation/
│   ├── bindings/
│   ├── controllers/
│   └── views/
│       ├── main_page.dart
│       └── widgets/             # tab stack, bottom navigation และ nav items
│
├── orders/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   └── views/
│       ├── order_date_format.dart
│       ├── order_detail/
│       │   ├── order_detail_page.dart
│       │   └── widgets/
│       └── orders/
│           ├── orders_page.dart
│           └── widgets/
│
├── profile/
│   ├── bindings/
│   ├── controllers/
│   ├── models/
│   ├── repositories/
│   └── views/
│       ├── browsing_history/
│       │   ├── browsing_history_page.dart
│       │   └── widgets/
│       ├── edit_profile/
│       │   ├── edit_profile_page.dart
│       │   └── widgets/
│       ├── favorites/
│       │   ├── favorites_page.dart
│       │   └── widgets/
│       ├── my_contents/
│       │   ├── my_contents_page.dart
│       │   └── widgets/
│       └── profile/
│           ├── profile_page.dart
│           └── widgets/
│
└── shops/
    ├── bindings/
    ├── controllers/
    ├── models/
    ├── repositories/
    ├── views/
    │   ├── product_detail/
    │   │   ├── product_detail_page.dart
    │   │   └── widgets/
    │   ├── products/            # products_page.dart
    │   ├── shop_detail/
    │   │   ├── shop_detail_page.dart
    │   │   └── widgets/
    │   └── shop_list/
    │       ├── shop_list_palette.dart
    │       ├── shops_page.dart
    │       └── widgets/
    └── widgets/
        └── shared/
```

## หน้าที่ของโฟลเดอร์

| โฟลเดอร์ | ใช้เก็บ |
| --- | --- |
| `bindings/` | การลงทะเบียน controller และ dependency ของ route/feature |
| `views/` | หน้า Flutter ที่ผูกกับ route รับสถานะจาก controller และแสดงผล |
| `controllers/` | สถานะหน้าจอและการประสานงานกับ repository |
| `repositories/` | การอ่านและเขียนข้อมูลผ่าน API หรือแหล่งข้อมูล |
| `models/` | รูปแบบข้อมูลที่ repository แปลงและส่งให้ส่วนอื่นใช้งาน |
| `views/<page>/widgets/` | widget ที่เป็นส่วนประกอบเฉพาะของหน้านั้น |
| `widgets/` | widget ที่ใช้ซ้ำในหลายหน้าภายใน feature เดียวกัน |
| `shared/widgets/` | widget ที่ใช้ร่วมกันข้าม feature |

## ตัวอย่าง feature: `shops`

ตัวอย่างนี้เรียงโฟลเดอร์ตามลำดับการทำงานตอนเปิดหน้าร้านค้าและโหลดข้อมูล: binding เตรียม controller, view เริ่มทำงาน, controller ขอข้อมูล, repository ติดต่อ API และ model แปลงข้อมูลให้แอปใช้

```text
lib/features/shops/
├── bindings/
│   └── shop_binding.dart
├── views/
│   └── shop_list/
│       ├── shop_list_palette.dart
│       ├── shops_page.dart
│       └── widgets/
│           ├── shop_card.dart
│           ├── shop_flash_sale_section.dart
│           ├── shop_interactive_map_view.dart
│           ├── shop_list_filters.dart
│           ├── shop_list_header.dart
│           └── special_product_card.dart
├── controllers/
│   └── shop_controller.dart
├── repositories/
│   └── shop_repository.dart
├── models/
│   └── shop_model.dart
└── widgets/
    └── shared/
        └── product_card.dart
```

### ลำดับการทำงานและโค้ด

1. **Route เรียก Binding** — ใน `app_pages.dart` route ร้านค้ากำหนดทั้ง `ShopsPage` และ `ShopBinding`:

```dart
GetPage(
  name: AppRoutes.shops,
  page: () => const ShopsPage(),
  binding: ShopBinding(),
),
```

2. **Binding สร้าง Controller** — `Get.lazyPut` ลงทะเบียน controller ให้ GetX สร้างเมื่อมีการเรียกใช้:

```dart
class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(() => ShopController());
  }
}
```

3. **View ผูก Controller** — `ShopsPage` ดึง `ShopController` จาก GetX; ในหน้า `Obx` จะ rebuild เมื่อข้อมูล observable ของ controller เปลี่ยน และส่งร้านให้ `ShopCard` แสดงผล:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_card.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  late final ShopController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ShopController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final displayedShops = controller.displayedShops;

      return ListView.builder(
        itemCount: displayedShops.length,
        itemBuilder: (context, index) => ShopCard(
          item: displayedShops[index],
          displayMode: index == 0 && controller.displayMode.value == 'grid'
              ? 'featured'
              : 'list',
        ),
      );
    });
  }
}
```

4. **Controller ประสานงาน** — เมื่อ controller เริ่มทำงาน จะเรียก repository แล้วเก็บผลใน `shops` ซึ่งเป็น observable:

```dart
@override
void onInit() {
  super.onInit();
  initMasterDataAndFetch();
}

Future<void> fetchShops() async {
  final result = await _repository.fetchShops(
    search: searchQuery.value,
    categoryId: selectedCategoryId.value,
    districtId: selectedDistrictId.value,
  );
  shops.assignAll(result);
}
```

5. **Repository ติดต่อ API และใช้ Model** — repository ขอข้อมูลร้านจาก API แล้วแปลงแต่ละรายการด้วย `ShopModel.fromJson`:

```dart
final response = await _apiClient.get('/shops', query: query);
if (response.isOk && response.body != null) {
  final data = response.body;
  List items = [];
  if (data is Map && data['items'] is List) {
    items = data['items'] as List;
  } else if (data is List) {
    items = data;
  }
  return items
      .map((item) => ShopModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
return [];
```

`ShopModel.fromJson` จัดข้อมูล JSON ให้เป็น object ที่ส่วนอื่นใช้งานได้:

```dart
factory ShopModel.fromJson(Map<String, dynamic> json) {
  return ShopModel(
    id: json['shopId']?.toString() ?? json['id']?.toString() ?? '',
    name: json['shopName']?.toString() ??
        json['name']?.toString() ??
        'ไม่มีชื่อร้านค้า',
  );
}
```

เมื่อ repository ส่งรายการ `ShopModel` กลับมา controller จะอัปเดต `shops`; `Obx` ใน view สังเกตการเปลี่ยนแปลงแล้ววาดรายการใหม่ ส่วน `ShopCard` และ widget เฉพาะอื่น ๆ อยู่ใน `views/shop_list/widgets/`.

โค้ดอ้างอิงจริงอยู่ที่ `lib/app/routes/app_pages.dart` และไฟล์ภายใต้ `lib/features/shops/` ตามแผนผังด้านบน ตัวอย่างย่อโค้ดให้เห็นหน้าที่ของแต่ละส่วน โดยตัดรายละเอียดการจัดการ error และ UI บางส่วนออก.

## จุดเริ่มต้นและ routes

- `lib/main.dart` เริ่มต้นแอปและตั้งค่า dependency หลัก
- `lib/app/routes/app_routes.dart` กำหนดชื่อ route
- `lib/app/routes/app_pages.dart` ผูก route กับหน้าและ binding
- `lib/app/bindings/initial_binding.dart` ลงทะเบียน dependency เริ่มต้น

เมื่อเพิ่มหน้าที่มีหลายองค์ประกอบ ให้สร้าง `views/<page_name>/<page_name>_page.dart` และเก็บ widget เฉพาะหน้าไว้ใน `views/<page_name>/widgets/` เพื่อให้หาและแก้ไขส่วนของแต่ละหน้าได้ง่าย
