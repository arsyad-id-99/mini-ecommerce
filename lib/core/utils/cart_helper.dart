// lib/core/utils/cart_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/product/domain/entities/product_entity.dart';

class CartHelper {
  // Fungsi utama yang akan dipanggil dari UI
  static void handleAddToCart(BuildContext context, ProductEntity product) {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated || authState is AuthSuccess) {
      context.read<CartBloc>().add(AddToCart(product: product));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.title} berhasil ditambahkan ke keranjang'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      _showAuthBottomSheet(context);
    }
  }

  // Fungsi private untuk menampilkan Bottom Sheet
  static void _showAuthBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 64.w, color: Colors.orange),
              SizedBox(height: 16.h),
              Text(
                'Anda belum login!',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Silakan login terlebih dahulu untuk menambahkan produk ke keranjang.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(bottomSheetContext); // Tutup bottom sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: Text(
                    'Login Sekarang',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}
