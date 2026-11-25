import 'package:get/get.dart';
import 'app_routes.dart';

import '../../features/navigation/bindings/navigation_binding.dart';
import '../../features/navigation/views/main_page.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/login_page.dart';
import '../../features/auth/views/register_page.dart';
import '../../features/shops/bindings/shop_binding.dart';
import '../../features/shops/views/shop_list/shops_page.dart';
import '../../features/shops/views/shop_detail/shop_detail_page.dart';
import '../../features/shops/views/product_detail/product_detail_page.dart';
import '../../features/contents/bindings/content_binding.dart';
import '../../features/contents/views/contents_page.dart';
import '../../features/contents/views/create_content_page.dart';
import '../../features/content_detail/bindings/content_detail_binding.dart';
import '../../features/content_detail/views/content_detail_page.dart';
import '../../features/cart/bindings/cart_binding.dart';
import '../../features/cart/views/cart_page.dart';
import '../../features/checkout/bindings/checkout_binding.dart';
import '../../features/checkout/views/checkout_page.dart';
import '../../features/checkout/views/payment_page.dart';
import '../../features/checkout/views/payment_success_page.dart';
import '../../features/orders/bindings/order_binding.dart';
import '../../features/orders/views/orders/orders_page.dart';
import '../../features/orders/views/order_detail/order_detail_page.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/views/profile/profile_page.dart';
import '../../features/profile/views/edit_profile/edit_profile_page.dart';
import '../../features/profile/views/my_contents/my_contents_page.dart';
import '../../features/profile/views/favorites/favorites_page.dart';
import '../../features/profile/views/browsing_history/browsing_history_page.dart';
import '../../features/merchant/bindings/merchant_binding.dart';
import '../../features/merchant/views/register_shop/register_shop_page.dart';
import '../../features/merchant/views/merchant_dashboard/merchant_dashboard_page.dart';
import '../../features/merchant/views/manage_products/manage_products_page.dart';
import '../../features/merchant/views/product_form/product_form_page.dart';
import '../../features/merchant/views/manage_orders/manage_orders_page.dart';
import '../../features/merchant/views/manage_contents/manage_contents_page.dart';
import '../../features/merchant/views/content_form/content_form_page.dart';
import '../../features/merchant/views/merchant_export/merchant_export_page.dart';
import '../../features/merchant/views/product_deals/product_deals_page.dart';
import '../../features/merchant/views/product_deal_form/product_deal_form_page.dart';
import '../../features/admin/bindings/admin_binding.dart';
import '../../features/admin/views/admin_dashboard/admin_dashboard_page.dart';
import '../../features/admin/views/admin_orders/admin_orders_page.dart';
import '../../features/admin/views/admin_payouts/admin_payouts_page.dart';
import '../../features/admin/views/manage_shops/manage_shops_page.dart';
import '../../features/admin/views/manage_products/manage_products_page.dart'
    as admin_products;
import '../../features/admin/views/manage_categories/manage_categories_page.dart';
import '../../features/admin/views/manage_contents/manage_contents_page.dart';
import '../../features/admin/views/manage_tags/manage_tags_page.dart';
import '../../features/admin/views/manage_schedules/manage_schedules_page.dart';
import '../../features/admin/views/reports/reports_page.dart';
import '../../features/admin/views/admin_export/admin_export_page.dart';

class AppPages {
  static const initial = AppRoutes.initial;

  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const MainPage(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.shops,
      page: () => const ShopsPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.shopDetail,
      page: () => const ShopDetailPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.contents,
      page: () => const ContentsPage(),
      binding: ContentBinding(),
    ),
    GetPage(
      name: AppRoutes.createContent,
      page: () => const CreateContentPage(),
      binding: ContentBinding(),
    ),
    GetPage(
      name: AppRoutes.contentDetail,
      page: () => const ContentDetailPage(),
      binding: ContentDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: CheckoutBinding(),
    ),
    GetPage(name: AppRoutes.payment, page: () => const PaymentPage()),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => const PaymentSuccessPage(),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersPage(),
      binding: OrderBinding(),
    ),
    GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailPage()),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.myContents,
      page: () => const MyContentsPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const BrowsingHistoryPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.registerShop,
      page: () => const RegisterShopPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShop,
      page: () => const MerchantDashboardPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopProducts,
      page: () => const ManageProductsPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopProductForm,
      page: () => const ProductFormPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopOrders,
      page: () => const ManageOrdersPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopContents,
      page: () => const ManageContentsPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopContentForm,
      page: () => const ContentFormPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopExports,
      page: () => const MerchantExportPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopProductDeals,
      page: () => const ProductDealsPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.myShopProductDealForm,
      page: () => const ProductDealFormPage(),
      binding: MerchantBinding(),
    ),
    GetPage(
      name: AppRoutes.admin,
      page: () => const AdminDashboardPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminOrders,
      page: () => const AdminOrdersPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminPayouts,
      page: () => const AdminPayoutsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminShops,
      page: () => const ManageShopsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminShopProducts,
      page: () => const admin_products.AdminManageProductsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminCategories,
      page: () => const ManageCategoriesPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminProductCategories,
      page: () => const ManageCategoriesPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminContents,
      page: () => const ManageAdminContentsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminContentCategories,
      page: () => const ManageAdminContentsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminTags,
      page: () => const ManageTagsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminSchedules,
      page: () => const ManageSchedulesPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminReports,
      page: () => const ReportsPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminExports,
      page: () => const AdminExportPage(),
      binding: AdminBinding(),
    ),
  ];
}
