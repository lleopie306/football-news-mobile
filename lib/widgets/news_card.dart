import 'package:flutter/material.dart';
import 'package:football_news/screens/menu.dart' show ItemHomepage;
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';
import 'package:football_news/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  // Menampilkan kartu dengan ikon dan nama.
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  // Warna berbeda per tombol (optional: sesuaikan nama yang kamu pakai)
  Color _backgroundFor(ItemHomepage item) {
    switch (item.name) {
      case 'All Products':
        return Colors.blue;      // biru
      case 'My Products':
        return Colors.green;     // hijau
      case 'Create Product':
        return Colors.red;       // merah
      default:
        return Colors.blueAccent; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: _backgroundFor(item),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          // Snackbar info
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
            );

          // Contoh navigasi jika tombol tertentu ditekan
          if (item.name == 'Add News') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsFormPage()),
            );
          }
          else if (item.name == "See Football News") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewsEntryListPage()
              ),
            );
          }
          else if (item.name == "Logout") {
            // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
            // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
            // If you using chrome,  use URL http://localhost:8000

            final response = await request.logout(
                "http://localhost:8000/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message See you again, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const SizedBox(height: 3),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}